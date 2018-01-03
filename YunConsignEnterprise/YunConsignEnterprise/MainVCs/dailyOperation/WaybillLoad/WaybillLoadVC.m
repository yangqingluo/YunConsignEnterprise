//
//  WaybillLoadVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillLoadVC.h"
#import "PublicQueryConditionVC.h"
#import "WaybillLoadTTVC.h"
#import "WaybillLoadedVC.h"

#import "MJRefresh.h"
#import "WaybillLoadCell.h"

@interface WaybillLoadVC ()

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) AppQueryConditionInfo *condition;

@end

@implementation WaybillLoadVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefreshNotification:) name:kNotification_WaybillLoadRefresh object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.needRefresh) {
        self.needRefresh = NO;
        [self.tableView.mj_header beginRefreshing];
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
    vc.type = QueryConditionType_WaybillLoad;
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

- (void)loadFirstPageData{
    [self queryWaybillListByConditionFunction:YES];
}

- (void)loadMoreData{
    [self queryWaybillListByConditionFunction:NO];
}

- (void)queryWaybillListByConditionFunction:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    if (self.condition) {
        if (self.condition.start_time) {
            [m_dic setObject:stringFromDate(self.condition.start_time, nil) forKey:@"start_time"];
        }
        if (self.condition.end_time) {
            [m_dic setObject:stringFromDate(self.condition.end_time, nil) forKey:@"end_time"];
        }
        if (self.condition.end_service) {
            [m_dic setObject:self.condition.end_service.service_id forKey:@"end_station_service_id"];
        }
        if (self.condition.truck_number_plate) {
            [m_dic setObject:self.condition.truck_number_plate forKey:@"truck_number_plate"];
        }
        if (self.condition.transport_truck_state) {
            [m_dic setObject:self.condition.transport_truck_state.item_val forKey:@"transport_truck_state"];
        }
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_load_queryCanLoadTransportTruckByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppCanLoadTransportTruckInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
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

- (void)doStartTransportTruck:(AppCanLoadTransportTruckInfo *)item {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"transport_truck_id" : item.transport_truck_id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_startTransportTruckByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself showHint:@"发车成功"];
                [weakself.tableView.mj_header beginRefreshing];
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

- (void)updateTableViewFooter{
    QKWEAKSELF;
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakself loadMoreData];
        }];
    }
}

- (void)endRefreshing {
    [self doHideHudFunction];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - getter
- (AppQueryConditionInfo *)condition {
    if (!_condition) {
        _condition = [AppQueryConditionInfo new];
    }
    return _condition;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WaybillLoadCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"way_bill_load_cell";
    WaybillLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[WaybillLoadCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.data = self.dataSource[indexPath.row];
    cell.indexPath = [indexPath copy];
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
        int tag = [m_dic[@"tag"] intValue];
        switch (tag) {
            case 0:{
                //配载
                WaybillLoadTTVC *vc = [WaybillLoadTTVC new];
                vc.truckData = self.dataSource[indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case 1:{
                //装车详情
                WaybillLoadedVC *vc = [WaybillLoadedVC new];
                vc.truckData = self.dataSource[indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case 2:{
                //打印清单
                [self doShowHintFunction:defaultNoticeNotComplete];
            }
                break;
                
            case 3:{
                //发车
                QKWEAKSELF;
                BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"确定发车吗" message:nil cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [weakself doStartTransportTruck:weakself.dataSource[indexPath.row]];
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
