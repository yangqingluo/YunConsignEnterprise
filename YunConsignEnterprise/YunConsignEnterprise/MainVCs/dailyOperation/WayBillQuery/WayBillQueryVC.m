//
//  WayBillQueryVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillQueryVC.h"
#import "PublicQueryConditionVC.h"
#import "PublicWaybillDetailVC.h"
#import "WaybillEditVC.h"
#import "WaybillLogVC.h"

#import "WayBillCell.h"

@interface WayBillQueryVC ()<UITextFieldDelegate>

@end

@implementation WayBillQueryVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.condition.is_cancel = boolString(NO);
        self.condition.start_time = [self.condition.end_time dateByAddingTimeInterval:-2 * defaultDayTimeInterval];
        NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:@"waybill_type"];
        if (dicArray.count) {
            self.condition.waybill_type = dicArray[0];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefreshNotification:) name:kNotification_WaybillListRefresh object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.needRefresh) {
        [self beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:self.accessInfo.menu_name createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
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

- (void)searchBtnAction {
    PublicQueryConditionVC *vc = [PublicQueryConditionVC new];
    vc.type = QueryConditionType_WaybillQuery;
    vc.condition = self.condition;
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
        if (self.condition.waybill_type) {
            [m_dic setObject:self.condition.waybill_type.item_val forKey:@"waybill_type"];
        }
        if (self.condition.query_column && self.condition.query_val) {
            [m_dic setObject:self.condition.query_column.item_val forKey:@"query_column"];
            [m_dic setObject:self.condition.query_val forKey:@"query_val"];
        }
        if (self.condition.start_service) {
            [m_dic setObject:self.condition.start_service.service_id forKey:@"start_service_id"];
        }
        if (self.condition.end_service) {
            [m_dic setObject:self.condition.end_service.service_id forKey:@"end_service_id"];
        }
        if (self.condition.is_cancel) {
            [m_dic setObject:self.condition.is_cancel forKey:@"is_cancel"];
        }
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_queryWaybillListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppWayBillInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
            if (item.total < 10) {
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

- (void)cancelWaybill:(NSString *)waybill_id cause:(NSString *)change_cause {
    if (!waybill_id) {
        return;
    }
    if (!change_cause.length) {
        [self doShowHintFunction:@"请输入作废原因"];
        return;
    }
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_id" : waybill_id}];
    if (change_cause) {
        [m_dic setObject:change_cause forKey:@"change_cause"];
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_cancelWaybillByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself cancelWayBillSuccess];
            }
            else {
                [weakself showHint:item.message.length ? item.message : @"数据出错"];
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)cancelWayBillSuccess {
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"运单已作废" message:nil cancelButtonTitle:@"确定" clickButton:^(NSInteger buttonIndex) {
        [weakself beginRefreshing];
    } otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppWayBillInfo *item = self.dataSource[indexPath.row];
    return [WayBillCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:[item.cash_on_delivery_amount intValue] > 0 ? 4 : 3];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"way_bill_cell";
    WayBillCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[WayBillCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
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
        AppWayBillInfo *item = self.dataSource[indexPath.row];
        int tag = ([item.waybill_state integerValue] >= WAYBILL_STATE_5 ? 1 : 3) - [m_dic[@"tag"] intValue];
        switch (tag) {
            case 3:{
                QKWEAKSELF;
                BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"确定作废运单吗" message:nil cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        UITextField *textField = [view textFieldAtIndex:0];
                        [weakself cancelWaybill:item.waybill_id cause:textField.text];
                    }
                }otherButtonTitles:@"确定", nil];
                
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField *alertTextField = [alert textFieldAtIndex:0];
                alertTextField.clearButtonMode = UITextFieldViewModeAlways;
                alertTextField.returnKeyType = UIReturnKeyDone;
                alertTextField.delegate = self;
                alertTextField.placeholder = @"作废原因";
                [alertTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [alert show];
            }
                break;
                
            case 2:{
                WaybillEditVC *vc = [WaybillEditVC new];
                vc.detailData = [AppWayBillDetailInfo mj_objectWithKeyValues:[item mj_keyValues]];
//                QKWEAKSELF;
//                vc.doneBlock = ^(NSObject *object){
//                    if ([object isKindOfClass:[AppWayBillDetailInfo class]]) {
//                        [weakself.tableView.mj_header beginRefreshing];
//                    }
//                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case 1:{
                [self doShowHintFunction:defaultNoticeNotComplete];
            }
                break;
                
            case 0:{
                WaybillLogVC *vc = [WaybillLogVC new];
                vc.detailData = [AppWayBillDetailInfo mj_objectWithKeyValues:[item mj_keyValues]];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}


@end
