//
//  CodWaitPayDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/1.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodWaitPayDetailVC.h"
#import "CodPayVC.h"

#import "CodWaitPayCell.h"

@interface CodWaitPayDetailVC ()<UITextFieldDelegate>


@end

@implementation CodWaitPayDetailVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewStyle)style parentVC:(AppBasicViewController *)pVC andIndexTag:(NSInteger)index {
    self = [super initWithStyle:style parentVC:pVC andIndexTag:index];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefreshNotification:) name:kNotification_CodWaitPayRefresh object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"代收款未收款查询" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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
        if (self.condition.cod_search_time_type) {
            [m_dic setObject:self.condition.cod_search_time_type.item_val forKey:@"time_type"];
        }
        if (self.condition.query_column && self.condition.query_val) {
            [m_dic setObject:self.condition.query_column.item_val forKey:@"query_column"];
            [m_dic setObject:self.condition.query_val forKey:@"query_val"];
        }
        if (self.condition.start_service) {
            [m_dic setObject:self.condition.start_service.service_id forKey:@"start_service_id"];
        }
        if (self.condition.cash_on_delivery_type) {
            [m_dic setObject:self.condition.cash_on_delivery_type.item_val forKey:@"cash_on_delivery_type"];
        }
        if (self.condition.waybill_receive_state) {
            [m_dic setObject:self.condition.waybill_receive_state forKey:@"waybill_receive_state"];
        }
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_finance_queryNotPayCashOnDeliveryListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppCashOnDeliveryWayBillInfo  mj_objectArrayWithKeyValuesArray:item.items]];
            
            if (item.total <= weakself.dataSource.count) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [weakself updateTableViewFooter];
            }
            [weakself updateSubviews];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)doUpdateOrSetCashOnDeliveryNoteByIdFunction:(NSIndexPath *)indexPath cause:(NSString *)cash_on_delivery_note {
    if (indexPath.row > self.dataSource.count - 1 || !cash_on_delivery_note.length) {
        return;
    }
    [self doShowHudFunction];
    AppCashOnDeliveryWayBillInfo *m_data = self.dataSource[indexPath.row];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_id" : m_data.waybill_id}];
    if (cash_on_delivery_note) {
        [m_dic setObject:cash_on_delivery_note forKey:@"cash_on_delivery_note"];
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_finance_updateOrSetCashOnDeliveryNoteByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself doShowHintFunction:@"设置成功"];
                m_data.cash_on_delivery_note = [cash_on_delivery_note copy];
                [weakself.tableView reloadData];
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

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppCashOnDeliveryWayBillInfo *item = self.dataSource[indexPath.row];
    return [CodWaitPayCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:item.cash_on_delivery_note.length ? 3 : 2];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CodWaitPay_cell";
    CodWaitPayCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CodWaitPayCell alloc] initWithHeaderStyle:PublicHeaderCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    id item = self.dataSource[indexPath.row];
    cell.indexPath = [indexPath copy];
    cell.data = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicMutableButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        NSIndexPath *indexPath = m_dic[@"indexPath"];
        AppCashOnDeliveryWayBillInfo *item = self.dataSource[indexPath.row];
        int tag = [m_dic[@"tag"] intValue];
        switch (tag) {
            case 0:{
                //收款
                CodPayVC *vc = [CodPayVC new];
                vc.billData = item;
                [self doPushViewController:vc animated:YES];
            }
                break;
                
            case 1:{
                //设置备注
                QKWEAKSELF;
                BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"设置备注" message:[NSString stringWithFormat:@"货号：%@", item.goods_number] cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        UITextField *textField = [view textFieldAtIndex:0];
                        [weakself doUpdateOrSetCashOnDeliveryNoteByIdFunction:indexPath cause:textField.text];
                    }
                }otherButtonTitles:@"确定", nil];
                
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField *alertTextField = [alert textFieldAtIndex:0];
                alertTextField.clearButtonMode = UITextFieldViewModeAlways;
                alertTextField.returnKeyType = UIReturnKeyDone;
                alertTextField.delegate = self;
                alertTextField.placeholder = @"请输入备注";
                [alertTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [alert show];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
