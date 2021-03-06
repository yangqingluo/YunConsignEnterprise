//
//  WaybillArrivalDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillArrivalDetailVC.h"
#import "PublicQueryConditionVC.h"

#import "MJRefresh.h"
#import "PublicWaybillArrivalFooterView.h"
#import "WaybillArrivalDetailCell.h"

@interface WaybillArrivalDetailVC ()

@property (strong, nonatomic) NSMutableArray *originalDataSource;

@property (strong, nonatomic) PublicWaybillArrivalFooterView *footerView;

@end

@implementation WaybillArrivalDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.title = [NSString stringWithFormat:@"%@/%@", self.truckData.truck_number_plate, self.truckData.route];
    self.condition.transport_truck_id = [self.truckData.transport_truck_id copy];
    
//    //忽略已打印功能不对查询生效，只对打印有效，去掉显示
//    self.footerView.ignoreBtn.hidden = YES;
    self.footerView.bottom = self.view.height;
    [self.view addSubview:self.footerView];
    self.tableView.height -= self.footerView.height;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"到货交接" createMenuItem:^UIView *(int nIndex){
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
    vc.type = QueryConditionType_WaybillArrivalDetail;
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

- (void)footerIgnoreBtnAction:(UIButton *)button {
    button.selected = !button.selected;
    [self updateSubviewsWithDataReset:YES];
}

- (void)footerSelectBtnAction:(UIButton *)button {
    button.selected = !button.selected;
    [self updateSubviewsWithDataReset:YES];
}

- (void)footerArriveBtnAction {
    if (!self.selectSet.count) {
        [self showHint:@"请选择交接的运单"];
        return;
    }
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定到货交接吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakself arrivalWaybillToTransportTruckFunction];
        }
    } otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)footerPrintBtn1Action {
    [self doShowHintFunction:defaultNoticeNotComplete];
}

- (void)footerPrintBtn2Action {
    [self doShowHintFunction:defaultNoticeNotComplete];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"transport_truck_id" : self.truckData.transport_truck_id, @"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    if (self.condition) {
        if (self.condition.load_service) {
            [m_dic setObject:self.condition.load_service.service_id forKey:@"load_service_id"];
        }
        if (self.condition.query_column && self.condition.query_val) {
            [m_dic setObject:self.condition.query_column.item_val forKey:@"query_column"];
            [m_dic setObject:self.condition.query_val forKey:@"query_val"];
        }
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_arrival_queryCanArrivalWaybillByTransportTruckIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.originalDataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.originalDataSource addObjectsFromArray:[AppCanArrivalWayBillInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
            if (item.total <= weakself.originalDataSource.count) {
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

- (void)arrivalWaybillToTransportTruckFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"transport_truck_id" : self.truckData.transport_truck_id}];
    NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:self.selectSet.count];
    for (AppCanLoadWayBillInfo *item in self.selectSet) {
        [m_array addObject:item.waybill_id];
    }
    [m_dic setObject:[m_array componentsJoinedByString:@","] forKey:@"waybill_ids"];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_arrival_arrivalWaybillInTransportTruckFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself arrivalWayBillSuccess];
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
    [self.dataSource removeAllObjects];
    [self.selectSet removeAllObjects];
    for (AppCanArrivalWayBillInfo *item in self.originalDataSource) {
//        if (self.footerView.ignoreBtn.selected && isTrue(item.print_state)) {
//            continue;
//        }
        [self.dataSource addObject:item];
    }
    
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
    int goods_total_count = 0;
    int total_amount = 0;
    for (AppCanArrivalWayBillInfo *item in self.selectSet) {
        goods_total_count += [item.goods_total_count intValue];
        total_amount += [item.total_amount intValue];
    }
    self.footerView.subTextLabel.text = [NSString stringWithFormat:@"总计：%d票/%d件/货量%d", (int)self.selectSet.count, goods_total_count, total_amount];
}

- (void)arrivalWayBillSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_WaybillArrivalRefresh object:nil];
    [self showHint:@"到货交接完成"];
    [self beginRefreshing];
}

#pragma mark - getter
- (PublicWaybillArrivalFooterView *)footerView {
    if (!_footerView) {
        _footerView = [PublicWaybillArrivalFooterView new];
        [_footerView.selectBtn addTarget:self action:@selector(footerSelectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.ignoreBtn addTarget:self action:@selector(footerIgnoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.arriveBtn addTarget:self action:@selector(footerArriveBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.printBtn1 addTarget:self action:@selector(footerPrintBtn1Action) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.printBtn2 addTarget:self action:@selector(footerPrintBtn2Action) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

- (NSMutableArray *)originalDataSource {
    if (!_originalDataSource) {
        _originalDataSource = [NSMutableArray new];
    }
    return _originalDataSource;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WaybillArrivalDetailCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"way_bill_arrival_cell";
    WaybillArrivalDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[WaybillArrivalDetailCell alloc] initWithHeaderStyle:PublicHeaderCellStyleSelection reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        cell.titleLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
//        cell.bodyLabel1.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
//        cell.bodyLabel2.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
//        cell.bodyLabel3.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
    }
    id item = self.dataSource[indexPath.row];
    cell.indexPath = [indexPath copy];
    cell.data = item;
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
        [self updateFooterSummary];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


@end
