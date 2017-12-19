//
//  PublicWaybillDetailListVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicWaybillDetailListVC.h"
#import "PublicWaybillDetailVC.h"

#import "CodLoanCheckDetailCell.h"

@interface PublicWaybillDetailListVC ()<UITextFieldDelegate>

@end

@implementation PublicWaybillDetailListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"运单明细" createMenuItem:^UIView *(int nIndex){
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
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"loan_apply_id" : self.codApplyData.loan_apply_id, @"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_loan_queryLoanApplyCheckWaybillListByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.selectSet removeAllObjects];
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppLoanApplyCheckWaybillInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
            if (item.total <= weakself.dataSource.count) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [weakself updateTableViewFooter];
            }
            [weakself updateSubviews];
        }
        else {
            [weakself doShowHintFunction:error.userInfo[@"message"]];
        }
    }];
}

- (void)doCancelLoanApplyWaybillByIdFunction:(NSString *)waybill_id cause:(NSString *)causeString {
    if (!waybill_id) {
        return;
    }
    if (!causeString.length) {
        [self doShowHintFunction:@"请输入驳回原因"];
        return;
    }
    [self doShowHudFunction];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_id" : waybill_id}];
    if (causeString) {
        [m_dic setObject:causeString forKey:@"loan_waybill_note"];
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_loan_cancelLoanApplyWaybillByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself cancelLoanApplyWaybillByIdSuccess];
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

- (void)cancelLoanApplyWaybillByIdSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_CodLoanCheckRefresh object:nil];
    [self doShowHintFunction:@"操作成功"];
    [self beginRefreshing];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppLoanApplyCheckWaybillInfo *m_data = self.dataSource[indexPath.row];
    return [CodLoanCheckDetailCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:(3 + ([m_data.cash_on_delivery_causes_amount intValue] > 0 ) + (m_data.reject_note.length > 0)) showFooter:(self.isChecker && [m_data.loan_apply_state integerValue] == LOAN_APPLY_STATE_1)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CodLoanCheckDetailCell_cell";
    CodLoanCheckDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CodLoanCheckDetailCell alloc] initWithHeaderStyle: PublicHeaderCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isChecker = self.isChecker;
    }
    id item = self.dataSource[indexPath.row];
    cell.indexPath = [indexPath copy];
    cell.data = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PublicWaybillDetailVC *vc = [PublicWaybillDetailVC new];
    vc.type = WaybillDetailType_CodQuery;
    vc.data = self.dataSource[indexPath.row];
    [self doPushViewController:vc animated:YES];
}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicMutableButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        NSIndexPath *indexPath = m_dic[@"indexPath"];
        AppLoanApplyCheckWaybillInfo *item = self.dataSource[indexPath.row];
        int tag = [m_dic[@"tag"] intValue];
        switch (tag) {
            case 0:{
                //驳回
                QKWEAKSELF;
                BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"确定驳回吗" message:nil cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        UITextField *textField = [view textFieldAtIndex:0];
                        [weakself doCancelLoanApplyWaybillByIdFunction:item.waybill_id cause:textField.text];
                    }
                }otherButtonTitles:@"确定", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField *alertTextField = [alert textFieldAtIndex:0];
                alertTextField.clearButtonMode = UITextFieldViewModeAlways;
                alertTextField.returnKeyType = UIReturnKeyDone;
                alertTextField.delegate = self;
                alertTextField.placeholder = @"驳回原因";
                [alertTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [alert show];

            }
                break;
                
            case 1:{
            }
                break;
                
            default:
                break;
        }
    }
}

@end
