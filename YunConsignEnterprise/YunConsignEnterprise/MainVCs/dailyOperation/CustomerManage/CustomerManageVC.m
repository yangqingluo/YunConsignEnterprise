//
//  CustomerManageVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CustomerManageVC.h"
#import "PublicQueryConditionVC.h"
#import "CustomerEditVC.h"

#import "CustomerManageCell.h"
#import "PublicSelectorFooterView.h"

@interface CustomerManageVC ()

@property (strong, nonatomic) PublicSelectorFooterView *footerView;

@end

@implementation CustomerManageVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefreshNotification:) name:kNotification_CustomerManageRefresh object:nil];
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
    
    self.footerView.bottom = self.view.height;
    [self.view addSubview:self.footerView];
    self.tableView.height -= self.footerView.height;
    
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
//        else if (nIndex == 1){
//            UIButton *btn = NewRightButton([UIImage imageNamed:@"navbar_icon_search"], nil);
//            [btn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
//            return btn;
//        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBtnAction {
    PublicQueryConditionVC *vc = [PublicQueryConditionVC new];
    vc.type = QueryConditionType_CustomerManage;
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

- (void)footerSelectBtnAction:(UIButton *)button {
    button.selected = !button.selected;
    [self updateSubviewsWithDataReset:YES];
}

- (void)footerActionBtnAction {
    if (!self.selectSet.count) {
        [self showHint:@"请选择批量删除的客户"];
        return;
    }
    
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"确定删除该客户吗" message:nil cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self doDeleteCustomerFunctionByGroups];
        }
    } otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    if (self.condition.freight_cust_name) {
        [m_dic setObject:self.condition.freight_cust_name forKey:@"freight_cust_name"];
    }
    if (self.condition.phone) {
        [m_dic setObject:self.condition.phone forKey:@"phone"];
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_cust_queryCustListByCondition" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.selectSet removeAllObjects];
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppCustomerInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
            if (item.total <= weakself.dataSource.count) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [weakself updateTableViewFooter];
            }
            [weakself updateSubviewsWithDataReset:YES];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)doDeleteCustomerFunction:(NSIndexPath *)indexPath {
    if (indexPath.row > self.dataSource.count - 1) {
        return;
    }
    [self doShowHudFunction];
    AppCustomerInfo *m_data = self.dataSource[indexPath.row];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"freight_cust_id" : m_data.freight_cust_id}];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_cust_deleteCustByIds" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself doShowHintFunction:@"删除成功"];
                [weakself beginRefreshing];
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

- (void)doDeleteCustomerFunctionByGroups {
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:self.selectSet.count];
    for (AppCustomerInfo *item in self.selectSet) {
        [m_array addObject:item.freight_cust_id];
    }
    [m_dic setObject:[m_array componentsJoinedByString:@","] forKey:@"freight_cust_id"];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_cust_deleteCustByIds" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself doShowHintFunction:@"删除成功"];
                [weakself beginRefreshing];
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

- (void)updateSubviewsWithDataReset:(BOOL)isReset {
    if (isReset) {
        if (self.footerView.selectBtn.selected) {
            [self.selectSet addObjectsFromArray:self.dataSource];
        }
        else {
            [self.selectSet removeAllObjects];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - getter
- (PublicSelectorFooterView *)footerView {
    if (!_footerView) {
        _footerView = [PublicSelectorFooterView new];
        [_footerView.actionBtn setTitle:@"批量删除" forState:UIControlStateNormal];
        [_footerView.selectBtn addTarget:self action:@selector(footerSelectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.actionBtn addTarget:self action:@selector(footerActionBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppCustomerInfo *item = self.dataSource[indexPath.row];
    return [CustomerManageCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:2 + (item.note.length > 0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomerManageCell";
    CustomerManageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[CustomerManageCell alloc] initWithHeaderStyle:PublicHeaderCellStyleSelection reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    id item = self.dataSource[indexPath.row];
    cell.data = item;
    cell.indexPath = [indexPath copy];
    cell.headerSelectBtn.selected = [self.selectSet containsObject:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicHeaderCellSelectButtonClicked]) {
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
            self.footerView.selectBtn.selected = YES;
        }
        else {
            self.footerView.selectBtn.selected = NO;
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([eventName isEqualToString:Event_PublicMutableButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        NSIndexPath *indexPath = m_dic[@"indexPath"];
        AppCustomerInfo *item = self.dataSource[indexPath.row];
        int tag = [m_dic[@"tag"] intValue];
        switch (tag) {
            case 0:{
                CustomerEditVC *vc = [CustomerEditVC new];
                vc.customerData = item;
                [self doPushViewController:vc animated:YES];
            }
                break;
                
            case 1:{
                QKWEAKSELF;
                BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"确定删除吗" message:nil cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [weakself doDeleteCustomerFunction:indexPath];
                    }
                } otherButtonTitles:@"确定", nil];
                [alert show];
            }
                break;
                
            default:
                break;
        }
    }
}


@end
