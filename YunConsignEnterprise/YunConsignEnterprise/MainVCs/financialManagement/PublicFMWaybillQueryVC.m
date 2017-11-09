//
//  PublicFMWaybillQueryVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicFMWaybillQueryVC.h"

#import "PublicInputHeaderView.h"
#import "PublicFMWaybillQueryCell.h"

@interface PublicFMWaybillQueryVC ()

@property (strong, nonatomic) PublicInputHeaderView *headerView;
@property (strong, nonatomic) AppWayBillDetailInfo *selectedData;

@end

@implementation PublicFMWaybillQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self.view addSubview:self.headerView];
    self.tableView.top = self.headerView.bottom;
    self.tableView.height = self.view.height - self.headerView.bottom;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupNav {
    [self createNavWithTitle:self.title ? self.title : @"查询运单" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)cancelButtonAction {
    [self goBackWithDone:NO];
}

- (void)searchButtonAction {
    [self dismissKeyboard];
    if (!self.headerView.baseView.textField.text.length) {
        [self doShowHintFunction:@"请输入运单号或货号"];
        return;
    }
    [self doQueryWaybillFunction:self.headerView.baseView.textField.text];
}

- (void)goBackWithDone:(BOOL)done {
    if (done) {
        [self doDoneAction];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doDoneAction {
    if (self.doneBlock) {
        self.doneBlock(self.selectedData);
    }
}

- (void)doQueryWaybillFunction:(NSString *)waybill_info {
    if (!waybill_info) {
        return;
    }
    
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    NSString *m_code = nil;
    switch (self.type) {
        case FMWaybillQueryType_DailyReimburse:{
            [m_dic setObject:waybill_info forKey:@"waybill_info"];
            m_code = @"hex_reimburse_queryWaybillInDailyReimburseFunction";
        }
            break;
            
        case FMWaybillQueryType_CodLoanApply:{
            [m_dic setObject:waybill_info forKey:@"number"];
            m_code = @"hex_loan_queryWaybillListByNumberFunction";
        }
            break;
            
        default:
            break;
    }
    if (!m_code) {
        return;
    }
    
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:m_code Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself.dataSource removeAllObjects];
                [weakself.dataSource addObjectsFromArray:[AppWayBillDetailInfo mj_objectArrayWithKeyValuesArray:item.items]];
                [weakself.tableView reloadData];
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

#pragma mark - getter
- (PublicInputHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[PublicInputHeaderView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom + kEdge, screen_width, kCellHeightFilter)];
        _headerView.baseView.textLabel.text = @"运单号/货号";
        _headerView.baseView.textField.placeholder = @"请输入运单号或货号";
        _headerView.baseView.textField.keyboardType = UIKeyboardTypeURL;
        [_headerView.searchBtn addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.baseView adjustSubviews];
    }
    return _headerView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PublicFMWaybillQueryCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PublicFMWaybillQuery_cell";
    PublicFMWaybillQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PublicFMWaybillQueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = [indexPath copy];
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedData = self.dataSource[indexPath.row];
    [self goBackWithDone:YES];
}

@end
