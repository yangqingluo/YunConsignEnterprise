//
//  SaveCodLoanApplySecondVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/9.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SaveCodLoanApplySecondVC.h"

#import "SaveCodLoanApplySecondCell.h"

@interface SaveCodLoanApplySecondVC ()<UITextFieldDelegate>

@property (strong, nonatomic) NSArray *remitBankInfoList;

@end

@implementation SaveCodLoanApplySecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initializeData];
    [self doSetRemitBankInfoFunction];
}

- (void)setupNav {
    [self createNavWithTitle:@"申请步骤2：打款账户" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"保存", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)saveButtonAction {
    [self dismissKeyboard];
    
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    for (NSDictionary *dic in self.showArray) {
        NSString *key = dic[@"key"];
        NSString *value = [self.showData valueForKey:key];
        if ([key isEqualToString:@"apply_note"]) {
            
        }
        else {
            BOOL valid = YES;
            valid = value.length > 0;
            if (!valid) {
                [self showHint:[NSString stringWithFormat:@"请补全%@", dic[@"title"]]];
                return;
            }
        }
        if (value) {
            [m_dic setObject:value forKey:key];
        }
    }
    [self doSaveLoanApplyFunction:m_dic];
}

//初始化数据
- (void)initializeData {
    self.showData = [AppCodLoanApplyInfo new];
    self.showArray = @[@{@"title":@"银行账户",@"subTitle":@"请输入银行账户",@"key":@"bank_card_account"},
                       @{@"title":@"银行名称",@"subTitle":@"请输入银行名称",@"key":@"bank_name"},
                       @{@"title":@"户主",@"subTitle":@"请输入户主姓名",@"key":@"bank_card_owner"},
                       @{@"title":@"联系电话",@"subTitle":@"请输入户主电话",@"key":@"contact_phone"},
                       @{@"title":@"申请备注",@"subTitle":@"请输入申请备注",@"key":@"apply_note"}];
}

- (void)editAtIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag andContent:(NSString *)content {
    if (indexPath.section == 1 && indexPath.row < self.showArray.count) {
        NSDictionary *m_dic = self.showArray[indexPath.row];
        NSString *key = m_dic[@"key"];
        [self.showData setValue:content forKey:key];
    }
}

- (void)doSetRemitBankInfoFunction {
    if (!self.dataSource.count) {
        [self showHint:@"运单数据出错"];
        return;
    }
    NSMutableArray *idArray = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    for (AppWayBillDetailInfo *item in self.dataSource) {
        [idArray addObject:item.waybill_id];
    }
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_ids" : [idArray componentsJoinedByString:@","]}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_loan_setRemitBankInfoFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                weakself.remitBankInfoList = item.items;
                [weakself updateBankInfoView];
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

- (void)doSaveLoanApplyFunction:(NSDictionary *)dic {
    if (!self.dataSource.count) {
        [self showHint:@"运单数据出错"];
        return;
    }
    NSMutableArray *idArray = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    for (AppWayBillDetailInfo *item in self.dataSource) {
        [idArray addObject:item.waybill_id];
    }
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_ids" : [idArray componentsJoinedByString:@","]}];
    if (dic) {
        [m_dic addEntriesFromDictionary:dic];
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_loan_saveLoanApplyFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself saveLoanApplySuccess];
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

- (void)saveLoanApplySuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_CodLoanApplyRefresh object:nil];
    [self doShowHintFunction:@"保存申请放款单成功"];
    [self doPopToLastViewControllerSkip:2 animated:YES];
//    QKWEAKSELF;
//    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"保存申请放款单成功" message:nil cancelButtonTitle:@"确定" clickButton:^(NSInteger buttonIndex) {
//        [weakself doPopToLastViewControllerSkip:2 animated:YES];
//    } otherButtonTitles:nil];
//    [alert show];
}

- (void)updateBankInfoView {
    if (self.remitBankInfoList.count) {
        NSDictionary *item = self.remitBankInfoList[0];
        self.showData = [AppCodLoanApplyInfo mj_objectWithKeyValues:item];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.showArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = kCellHeightFilter;
    if (indexPath.section == 0) {
        rowHeight = [SaveCodLoanApplySecondCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:2];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
            rowHeight += kEdge;
        }
    }
    
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kEdgeSmall;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section != 0) {
        return kEdge;
    }
    return kEdgeSmall;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"SaveCodLoanApplySecond_title_cell";
        SaveCodLoanApplySecondCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[SaveCodLoanApplySecondCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
        }
        
        int count = 0;
        double cash_on_delivery_amount = 0;
        double cash_on_delivery_real_amount = 0;
        double agent_money_fee = 0;
        for (AppWayBillDetailInfo *m_data in self.dataSource) {
            count++;
            cash_on_delivery_amount += [m_data.cash_on_delivery_amount doubleValue];
            cash_on_delivery_real_amount += [m_data.cash_on_delivery_real_amount doubleValue];
            agent_money_fee += [m_data.agent_money_fee doubleValue];
        }
        
        cell.titleLabel.text = [NSString stringWithFormat:@"运单数量（%d单）", count];
        cell.bodyLabel1.text = [NSString stringWithFormat:@"开单金额：%.0f", cash_on_delivery_amount];
        cell.bodyLabelRight1.text = [NSString stringWithFormat:@"实收金额：%.0f", cash_on_delivery_real_amount];
        cell.bodyLabel2.text = [NSString stringWithFormat:@"手续费：%.0f", agent_money_fee];
        cell.bodyLabelRight2.text = [NSString stringWithFormat:@"应放款：%.0f", cash_on_delivery_real_amount - agent_money_fee];
        
        return cell;
    }
    
    NSString *CellIdentifier = @"PublicDailyReimbursementDetail_cell";
    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
        cell.baseView.textField.delegate = self;
    }
    cell.baseView.textLabel.text = m_dic[@"title"];
    cell.baseView.textField.placeholder = m_dic[@"subTitle"];
    cell.baseView.textField.text = @"";
    cell.baseView.textField.indexPath = [indexPath copy];
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    cell.baseView.textField.text = [self.showData valueForKey:key];
    if (indexPath.row == 0 || indexPath.row == 3) {
        cell.baseView.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else {
        cell.baseView.textField.keyboardType = UIKeyboardTypeDefault;
    }
    
    return cell;
}

@end
