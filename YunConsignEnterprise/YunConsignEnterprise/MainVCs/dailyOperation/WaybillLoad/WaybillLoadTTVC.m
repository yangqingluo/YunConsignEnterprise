//
//  WaybillLoadTTVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillLoadTTVC.h"
#import "PublicQueryConditionVC.h"

#import "MJRefresh.h"
#import "PublicTTLoadFooterView.h"
#import "WaybillLoadSelectCell.h"

@interface WaybillLoadTTVC ()

@property (strong, nonatomic) NSMutableSet *selectSet;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) AppQueryConditionInfo *condition;

@property (strong, nonatomic) PublicTTLoadFooterView *footerView;

@end

@implementation WaybillLoadTTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.footerView.bottom = self.view.height;
    [self.view addSubview:self.footerView];
    self.tableView.height -= self.footerView.height;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"运单配载" createMenuItem:^UIView *(int nIndex){
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
    vc.type = QueryConditionType_WaybillLoadTT;
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
        [self showHint:@"请选择配载的运单"];
        return;
    }
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定配载吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakself loadWaybillToTransportTruckFunction];
        }
    } otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)loadFirstPageData {
    [self queryWaybillListByConditionFunction:YES];
}

- (void)loadMoreData {
    [self queryWaybillListByConditionFunction:NO];
}

- (void)queryWaybillListByConditionFunction:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"transport_truck_id" : self.truckData.transport_truck_id, @"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
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
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_load_queryCanLoadWaybillByTransportTruckIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.selectSet removeAllObjects];
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppCanLoadWayBillInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
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

- (void)loadWaybillToTransportTruckFunction{
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"transport_truck_id" : self.truckData.transport_truck_id}];
    NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:self.selectSet.count];
    for (AppCanLoadWayBillInfo *item in self.selectSet) {
        [m_array addObject:item.waybill_id];
    }
    [m_dic setObject:[m_array componentsJoinedByString:@","] forKey:@"waybill_ids"];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_load_loadWaybillToTransportTruckFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself loadWayBillSuccess];
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

- (void)updateTableViewHeader {
    QKWEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstPageData];
    }];
}

- (void)updateTableViewFooter {
    QKWEAKSELF;
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakself loadMoreData];
        }];
    }
}

- (void)endRefreshing{
    [self doHideHudFunction];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
    [self updateFooterSummary];
    [self.tableView reloadData];
}

- (void)updateFooterSummary {
    int count = 0;
    int goods_total_count = 0;
    int total_amount = 0;
    for (AppCanLoadWayBillInfo *item in self.selectSet) {
        count++;
        goods_total_count += [item.goods_total_count intValue];
        total_amount += [item.total_amount intValue];
    }
    self.footerView.summaryView.textLabel.text = [NSString stringWithFormat:@"合计：%d票/%d件/货量%d", count, goods_total_count, total_amount];
}

- (void)loadWayBillSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_WaybillLoadRefresh object:nil];
    [self showHint:@"配载成功"];
    [self goBack];
}

#pragma mark - getter
- (PublicTTLoadFooterView *)footerView {
    if (!_footerView) {
        _footerView = [PublicTTLoadFooterView new];
        [_footerView.actionBtn setTitle:@"确定配载" forState:UIControlStateNormal];
        [_footerView.selectBtn addTarget:self action:@selector(footerSelectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.actionBtn addTarget:self action:@selector(footerActionBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

- (AppQueryConditionInfo *)condition {
    if (!_condition) {
        _condition = [AppQueryConditionInfo new];
        _condition.start_time = [_condition.end_time dateByAddingTimeInterval:-3 * defaultDayTimeInterval];
    }
    return _condition;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (NSMutableSet *)selectSet {
    if (!_selectSet) {
        _selectSet = [NSMutableSet new];
    }
    return _selectSet;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppCanLoadWayBillInfo *item = self.dataSource[indexPath.row];
    return [WaybillLoadSelectCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:[item.cash_on_delivery_amount integerValue] > 0 ? 3 : 2];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"way_bill_load_cell";
    WaybillLoadSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[WaybillLoadSelectCell alloc] initWithHeaderStyle:PublicHeaderCellStyleSelection reuseIdentifier:CellIdentifier];
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
        if (self.selectSet.count == 0) {
            self.footerView.selectBtn.selected = NO;
        }
        [self updateFooterSummary];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
