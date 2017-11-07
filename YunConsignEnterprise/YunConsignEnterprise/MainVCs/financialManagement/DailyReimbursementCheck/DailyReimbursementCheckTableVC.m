//
//  DailyReimbursementCheckTableVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DailyReimbursementCheckTableVC.h"

#import "DailyReimbursementCheckCell.h"
#import "PublicFooterSummaryView.h"
#import "PublicTTLoadFooterView.h"

@interface DailyReimbursementCheckTableVC ()<UITextFieldDelegate>

@property (strong, nonatomic) UIView *footerView;

@end

@implementation DailyReimbursementCheckTableVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewStyle)style parentVC:(AppBasicViewController *)pVC andIndexTag:(NSInteger)index {
    self = [super initWithStyle:style parentVC:pVC andIndexTag:index];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefreshNotification:) name:kNotification_DailyReimbursementCheckRefresh object:nil];
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
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"daily_apply_state" : [NSString stringWithFormat:@"%d", (int)self.indextag + 1], @"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    if (self.condition) {
        if (self.condition.start_time) {
            [m_dic setObject:stringFromDate(self.condition.start_time, nil) forKey:@"start_time"];
        }
        if (self.condition.end_time) {
            [m_dic setObject:stringFromDate(self.condition.end_time, nil) forKey:@"end_time"];
        }
        if (self.condition.daily_name) {
            [m_dic setObject:self.condition.daily_name.item_val forKey:@"daily_name"];
        }
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_reimburse_queryNeedCheckDailyReimburseListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.selectSet removeAllObjects];
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppDailyReimbursementCheckInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
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

- (void)doReimburseCheckDailyReimburseFunction:(NSString *)daily_apply_id {
    if (!daily_apply_id) {
        return;
    }
    [self doShowHudFunction];
    NSDictionary *m_dic = @{@"daily_apply_id" : daily_apply_id};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_reimburse_checkDailyReimburseFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself dailyReimbursementCheckSuccess];
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

- (void)doReimburseCancelDailyReimburseFunction:(NSString *)daily_apply_id cause:(NSString *)causeString{
    if (!daily_apply_id) {
        return;
    }
    [self doShowHudFunction];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"daily_apply_id" : daily_apply_id}];
    if (causeString) {
        [m_dic setObject:causeString forKey:@"check_note"];
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_reimburse_cancelDailyReimburseFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself dailyReimbursementCheckSuccess];
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
        [self doShowHintFunction:@"请选择报销申请"];
        return;
    }
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定批量审核吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:self.selectSet.count];
            for (AppDailyReimbursementApplyInfo *item in self.selectSet) {
                [m_array addObject:item.daily_apply_id];
            }
            [weakself doReimburseCheckDailyReimburseFunction:[m_array componentsJoinedByString:@","]];
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
        int daily_fee = 0;
        for (AppDailyReimbursementApplyInfo *item in self.selectSet) {
            daily_fee += [item.daily_fee intValue];
        }
        ((PublicTTLoadFooterView *)self.footerView).summaryView.textLabel.text = [NSString stringWithFormat:@"总金额：%d", daily_fee];
    }
    else if (self.indextag == 1) {
        int daily_fee = 0;
        for (AppDailyReimbursementApplyInfo *item in self.dataSource) {
            daily_fee += [item.daily_fee intValue];
        }
        ((PublicFooterSummaryView *)self.footerView).textLabel.text = [NSString stringWithFormat:@"总金额：%d", daily_fee];
    }
}

- (void)updateSubviews {
    [self updateFooterSummary];
    [self.tableView reloadData];
}

- (void)dailyReimbursementCheckSuccess {
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
                [[(PublicTTLoadFooterView *)_footerView actionBtn] setTitle:@"批量审核" forState:UIControlStateNormal];
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
    return [DailyReimbursementCheckCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DailyReimbursementCheck_cell";
    DailyReimbursementCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[DailyReimbursementCheckCell alloc] initWithHeaderStyle:(self.indextag == 0) ? PublicHeaderCellStyleSelection : PublicHeaderCellStyleDefault reuseIdentifier:CellIdentifier];
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
        AppDailyReimbursementCheckInfo *item = self.dataSource[indexPath.row];
        int tag = [m_dic[@"tag"] intValue];
        switch (tag) {
            case 0:{
                //查看凭证
                
            }
                break;
                
            case 1:{
                //报销历史
                
            }
                break;
                
            case 2:{
                //审核通过
                QKWEAKSELF;
                BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定通过审核吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [weakself doReimburseCheckDailyReimburseFunction:item.daily_apply_id];
                    }
                } otherButtonTitles:@"确定", nil];
                [alert show];
            }
                break;
                
            case 3:{
                //驳回
                QKWEAKSELF;
                BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"确定驳回申请吗" message:nil cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        UITextField *textField = [view textFieldAtIndex:0];
                        [weakself doReimburseCancelDailyReimburseFunction:item.daily_apply_id cause:textField.text];
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
