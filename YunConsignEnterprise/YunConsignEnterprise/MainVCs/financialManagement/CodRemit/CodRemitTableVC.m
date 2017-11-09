//
//  CodRemitTableVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodRemitTableVC.h"
#import "CodRemitWaybillDetailVC.h"
#import "CodRemitLoanApplyListVC.h"

#import "CodRemitCell.h"
#import "PublicFooterSummaryView.h"
#import "PublicTTLoadFooterView.h"

@interface CodRemitTableVC ()<UITextFieldDelegate>

@property (strong, nonatomic) UIView *footerView;

@end

@implementation CodRemitTableVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewStyle)style parentVC:(AppBasicViewController *)pVC andIndexTag:(NSInteger)index {
    self = [super initWithStyle:style parentVC:pVC andIndexTag:index];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefreshNotification:) name:kNotification_CodRemitRefresh object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.top = 0;
    if (self.indextag != 2) {
        self.footerView.bottom = self.view.height;
        [self.view addSubview:self.footerView];
        self.footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.tableView.height = self.footerView.top - self.tableView.top;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    else {
        self.tableView.height = self.view.height;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"remittance_state" : [NSString stringWithFormat:@"%d", (int)self.indextag + 1], @"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    if (self.condition) {
        if (self.condition.start_time) {
            [m_dic setObject:stringFromDate(self.condition.start_time, nil) forKey:@"start_time"];
        }
        if (self.condition.end_time) {
            [m_dic setObject:stringFromDate(self.condition.end_time, nil) forKey:@"end_time"];
        }
        if (self.condition.bank_card_owner) {
            [m_dic setObject:self.condition.bank_card_owner forKey:@"bank_card_owner"];
        }
        if (self.condition.contact_phone) {
            [m_dic setObject:self.condition.contact_phone forKey:@"contact_phone"];
        }
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_loan_queryLoanApplyWaitLoanListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.selectSet removeAllObjects];
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppCodLoanApplyWaitLoanInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
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

- (void)doRemittanceLoanApplyByIdsFunction:(NSString *)loan_apply_ids {
    if (!loan_apply_ids) {
        return;
    }
    [self doShowHudFunction];
    NSDictionary *m_dic = @{@"loan_apply_ids" : loan_apply_ids};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_loan_remittanceLoanApplyByIdsFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself remittanceLoanApplySuccess];
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

- (void)footerSelectBtnAction:(UIButton *)button {
    button.selected = !button.selected;
    [self updateSubviewsWithDataReset:YES];
}

- (void)footerActionBtnAction {
    if (!self.selectSet.count) {
        [self doShowHintFunction:@"请选择放款申请"];
        return;
    }
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定批量放款吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:self.selectSet.count];
            for (AppCodLoanApplyWaitLoanInfo *item in self.selectSet) {
                [m_array addObject:item.loan_apply_ids];
            }
            [weakself doRemittanceLoanApplyByIdsFunction:[m_array componentsJoinedByString:@";"]];
        }
    } otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)updateSubviewsWithDataReset:(BOOL)isReset {
    if (isReset) {
        if (((PublicTTLoadFooterView *)self.footerView).selectBtn.selected) {
            [self.selectSet addObjectsFromArray:self.dataSource];
        }
        else {
            [self.selectSet removeAllObjects];
        }
    }
    [self updateSubviews];
}

- (void)updateFooterSummary {
    if (self.indextag == 0) {
        double remit_amount = 0;
        for (AppCodLoanApplyWaitLoanInfo *item in self.selectSet) {
            remit_amount += [item.remit_amount doubleValue];
        }
        ((PublicTTLoadFooterView *)self.footerView).summaryView.textLabel.text = [NSString stringWithFormat:@"放款总金额：%.2f元", remit_amount];
    }
    else if (self.indextag == 1) {
        double remit_amount = 0;
        for (AppCodLoanApplyWaitLoanInfo *item in self.dataSource) {
            remit_amount += [item.remit_amount doubleValue];
        }
        ((PublicFooterSummaryView *)self.footerView).textLabel.text = [NSString stringWithFormat:@"放款总金额：%.2f元", remit_amount];
    }
}

- (void)updateSubviews {
    [self updateFooterSummary];
    [self.tableView reloadData];
}

- (void)remittanceLoanApplySuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_DailyReimbursementCheckRefresh object:nil];
    [self doShowHintFunction:@"操作成功"];
    [self beginRefreshing];
}

#pragma mark - getter
- (UIView *)footerView {
    if (!_footerView) {
        switch (self.indextag) {
            case 0:{
                _footerView = [PublicTTLoadFooterView new];
                [[(PublicTTLoadFooterView *)_footerView actionBtn] setTitle:@"批量放款" forState:UIControlStateNormal];
                [[(PublicTTLoadFooterView *)_footerView selectBtn] addTarget:self action:@selector(footerSelectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [[(PublicTTLoadFooterView *)_footerView actionBtn] addTarget:self action:@selector(footerActionBtnAction) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case 1:{
                _footerView = [[PublicFooterSummaryView alloc] initWithFrame:CGRectMake(0, 0, screen_width, DEFAULT_BAR_HEIGHT)];
                _footerView.backgroundColor = [UIColor clearColor];
            }
                break;
                
            default:
                break;
        }
    }
    return _footerView;
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CodRemitCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:(self.indextag == 0) ? 2 : 3];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CodRemit_cell";
    CodRemitCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CodRemitCell alloc] initWithHeaderStyle:(self.indextag == 0) ? PublicHeaderCellStyleSelection : PublicHeaderCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indextag = self.indextag;
    }
    id item = self.dataSource[indexPath.row];
    cell.indexPath = [indexPath copy];
    cell.data = item;
    if (self.indextag == 0) {
        cell.headerSelectBtn.selected = [self.selectSet containsObject:item];
    }
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
        AppCodLoanApplyWaitLoanInfo *item = self.dataSource[indexPath.row];
        int tag = (self.indextag == 0 ? 2 : 1) - [m_dic[@"tag"] intValue];
        switch (tag) {
            case 2:{
                //发放完成
                QKWEAKSELF;
                BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定发放吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [weakself doRemittanceLoanApplyByIdsFunction:item.loan_apply_ids];
                    }
                } otherButtonTitles:@"确定", nil];
                [alert show];
            }
                break;
                
            case 1:{
                //申请单
                CodRemitLoanApplyListVC *vc = [CodRemitLoanApplyListVC new];
                vc.codApplyData = item;
                [self doPushViewController:vc animated:YES];
            }
                break;
                
            case 0:{
                //运单明细
                CodRemitWaybillDetailVC *vc = [CodRemitWaybillDetailVC new];
                vc.codApplyData = item;
                [self doPushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    else if ([eventName isEqualToString:Event_PublicHeaderCellSelectButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        NSIndexPath *indexPath = m_dic[@"indexPath"];
        id item = self.dataSource[indexPath.row];
        if ([self.selectSet containsObject:item]) {
            [self.selectSet removeObject:item];
        }
        else {
            [self.selectSet addObject:item];
        }
        if (self.selectSet.count == self.dataSource.count) {
            ((PublicTTLoadFooterView *)self.footerView).selectBtn.selected = YES;
        }
        if (self.selectSet.count == 0) {
            ((PublicTTLoadFooterView *)self.footerView).selectBtn.selected = NO;
        }
        [self updateFooterSummary];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
