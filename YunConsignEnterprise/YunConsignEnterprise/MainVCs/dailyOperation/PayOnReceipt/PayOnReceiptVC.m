//
//  PayOnReceiptVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PayOnReceiptVC.h"
#import "PublicQueryConditionVC.h"
#import "PublicWaybillDetailVC.h"

#import "PayOnReceiptCell.h"

@interface PayOnReceiptVC ()

@end

@implementation PayOnReceiptVC

- (instancetype)init{
    self = [super init];
    if (self) {
        self.condition.start_time = [self.condition.end_time dateByAddingTimeInterval:-2 * defaultDayTimeInterval];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:self.accessInfo.menu_name createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewRightButton([UIImage imageNamed:@"navbar_icon_search"], nil);
            [btn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBtnAction {
    PublicQueryConditionVC *vc = [PublicQueryConditionVC new];
    vc.type = QueryConditionType_PayOnReceipt;
    vc.condition = [self.condition copy];
    QKWEAKSELF;
    vc.doneBlock = ^(NSObject *object){
        if ([object isKindOfClass:[AppQueryConditionInfo class]]) {
            weakself.condition = (AppQueryConditionInfo *)object;
            [weakself.tableView.mj_header beginRefreshing];
        }
    };
    [vc showFromVC:self];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    if (self.condition) {
        if (self.condition.start_time) {
            [m_dic setObject:stringFromDate(self.condition.start_time, nil) forKey:@"start_time"];
        }
        if (self.condition.end_time) {
            [m_dic setObject:stringFromDate(self.condition.end_time, nil) forKey:@"end_time"];
        }
        if (self.condition.query_column && self.condition.query_val) {
            [m_dic setObject:self.condition.query_column.item_val forKey:@"query_column"];
            [m_dic setObject:self.condition.query_val forKey:@"query_val"];
        }
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_receipt_queryNeedReceiptWaybillListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppNeedReceiptWayBillInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
            if (item.total <= weakself.dataSource.count) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [weakself updateTableViewFooter];
            }
            [weakself.tableView reloadData];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)doPayReceiptWaybillByIdFunction:(NSString *)waybill_id {
    if (!waybill_id) {
        return;
    }
    [self doShowHudFunction];
    NSDictionary *m_dic = @{@"waybill_id" : waybill_id};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_receipt_payReceiptWaybillByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself payReceiptWaybillSuccess];
            }
            else {
                [weakself doShowHintFunction:item.message.length ? item.message : @"数据出错"];
            }
        }
        else {
            [weakself doShowHintFunction:error.userInfo[@"message"]];
        }
    }];
}

- (void)doCancelPayReceiptWaybillByIdFunction:(NSString *)waybill_id {
    if (!waybill_id) {
        return;
    }
    [self doShowHudFunction];
    NSDictionary *m_dic = @{@"waybill_id" : waybill_id};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_receipt_cancelPayReceiptWaybillByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself cancelPayReceiptWaybillSuccess];
            }
            else {
                [weakself doShowHintFunction:item.message.length ? item.message : @"数据出错"];
            }
        }
        else {
            [weakself doShowHintFunction:error.userInfo[@"message"]];
        }
    }];
}

- (void)payReceiptWaybillSuccess {
    [self doShowHintFunction:@"付款成功"];
    [self beginRefreshing];
}

- (void)cancelPayReceiptWaybillSuccess {
    [self doShowHintFunction:@"取消付款成功"];
    [self beginRefreshing];
}

#pragma mark - getter

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppNeedReceiptWayBillInfo *item = self.dataSource[indexPath.row];
    NSInteger receipt_state = [item.receipt_state integerValue];
    return [PayOnReceiptCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:3 showFooter:(receipt_state == RECEIPT_STATE_TYPE_3 || receipt_state == RECEIPT_STATE_TYPE_4)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PayOnReceiptCell";
    PayOnReceiptCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[PayOnReceiptCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.data = self.dataSource[indexPath.row];
    cell.indexPath = [indexPath copy];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PublicWaybillDetailVC *vc = [PublicWaybillDetailVC new];
    vc.type = WaybillDetailType_WayBillQuery;
    vc.data = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicMutableButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        NSIndexPath *indexPath = m_dic[@"indexPath"];
        AppNeedReceiptWayBillInfo *item = self.dataSource[indexPath.row];
        int tag = [m_dic[@"tag"] intValue];
        switch (tag) {
            case 0:{
                //付款/取消付款
                QKWEAKSELF;
                if ([item.receipt_state integerValue] == RECEIPT_STATE_TYPE_4) {
                    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定取消付款吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [weakself doCancelPayReceiptWaybillByIdFunction:item.waybill_id];
                        }
                    } otherButtonTitles:@"确定", nil];
                    [alert show];
                }
                else if ([item.receipt_state integerValue] == RECEIPT_STATE_TYPE_3) {
                    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定付款吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [weakself doPayReceiptWaybillByIdFunction:item.waybill_id];
                        }
                    } otherButtonTitles:@"确定", nil];
                    [alert show];
                }
                else {
                    
                }
            }
                break;
                
            default:
                break;
        }
    }
}

@end
