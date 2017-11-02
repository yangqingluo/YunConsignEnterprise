//
//  TransportTruckTableVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/27.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "TransportTruckTableVC.h"
#import "TTLoadListVC.h"
#import "TTPayCostVC.h"
#import "PublicSaveTransportTruckVC.h"

#import "TransportTruckCell.h"
#import "PublicFooterSummaryView.h"

@interface TransportTruckTableVC ()

@property (strong, nonatomic) UIView *footerView;

@end

@implementation TransportTruckTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.top = 0;
    if (self.indextag != 1) {
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
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"transport_truck_state" : [NSString stringWithFormat:@"%d", (int)self.indextag + 1], @"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    if (self.condition) {
        if (self.condition.start_time) {
            [m_dic setObject:stringFromDate(self.condition.start_time, nil) forKey:@"start_time"];
        }
        if (self.condition.end_time) {
            [m_dic setObject:stringFromDate(self.condition.end_time, nil) forKey:@"end_time"];
        }
        if (self.condition.start_station_city) {
            [m_dic setObject:self.condition.start_station_city.open_city_id forKey:@"start_station_city_id"];
        }
        if (self.condition.end_station_city) {
            [m_dic setObject:self.condition.end_station_city.open_city_id forKey:@"end_station_city_id"];
        }
        if (self.condition.truck_number_plate) {
            [m_dic setObject:self.condition.truck_number_plate forKey:@"truck_number_plate"];
        }
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_queryTransportTruckByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppTransportTruckInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
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

- (void)doCancelTransportTruck:(AppTransportTruckInfo *)item {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"transport_truck_id" : item.transport_truck_id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_cancelTransportTruckByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself showHint:@"取消派车成功"];
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

- (void)doStartTransportTruck:(AppTransportTruckInfo *)item {
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

- (void)saveButtonAction {
    PublicSaveTransportTruckVC *vc = [PublicSaveTransportTruckVC new];
    [self doPushViewController:vc animated:YES];
}

- (void)updateSubviews {
    if (self.indextag == 2) {
        int cost_register = 0;
        int cost_check = 0;
        for (AppTransportTruckInfo *item in self.dataSource) {
            cost_register += [item.cost_register intValue];
            cost_check += [item.cost_check intValue];
        }
        ((PublicFooterSummaryView *)self.footerView).textLabel.text = [NSString stringWithFormat:@"总登记费用：%d", cost_register];
        ((PublicFooterSummaryView *)self.footerView).subTextLabel.text = [NSString stringWithFormat:@"总发放运费：%d", cost_check];
    }
    [self.tableView reloadData];
}

#pragma mark - getter
- (UIView *)footerView {
    if (!_footerView) {
        switch (self.indextag) {
            case 0:{
                _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeightFilter)];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:_footerView.bounds];
                btn.backgroundColor = MainColor;
                btn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
                [btn setTitle:@"派车" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
                [_footerView addSubview:btn];
            }
                break;
                
            case 2:{
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
    return [TransportTruckCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TransportTruck_cell";
    TransportTruckCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[TransportTruckCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indextag = self.indextag;
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
        AppTransportTruckInfo *item = self.dataSource[indexPath.row];
        int tag = [m_dic[@"tag"] intValue];
        switch (tag) {
            case 0:{
                TTLoadListVC *vc = [TTLoadListVC new];
                vc.data = item;
                [self doPushViewController:vc animated:YES];
            }
                break;
                
            case 1:{
                if (self.indextag == 0) {
                    //取消派车
                    QKWEAKSELF;
                    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"确定取消派车吗" message:nil cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [weakself doCancelTransportTruck:item];
                        }
                    } otherButtonTitles:@"确定", nil];
                    [alert show];
                }
                else if (self.indextag == 2) {
                    //发放运费
                    TTPayCostVC *vc = [TTPayCostVC new];
                    vc.truckData = item;
                    [[UserPublic getInstance].mainTabNav pushViewController:vc animated:YES];
                }
            }
                break;
                
            case 2:{
                if (self.indextag == 0) {
                    //发车
                    QKWEAKSELF;
                    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"确定发车吗" message:nil cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [weakself doStartTransportTruck:item];
                        }
                    } otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

@end
