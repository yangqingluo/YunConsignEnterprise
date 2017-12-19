//
//  TransportTruckDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/12/20.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "TransportTruckDetailVC.h"
#import "TTLoadListVC.h"

#import "SingleInputCell.h"

@interface TransportTruckDetailVC ()

@property (strong, nonatomic) AppTransportTruckDetailInfo *detailData;

@end

@implementation TransportTruckDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self initializeData];
    [self updateTableViewHeader];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"派车详情" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@[@{@"title":@"始发站",@"subTitle":@"",@"key":@"start_station_city_name"},
                     @{@"title":@"终点站",@"subTitle":@"",@"key":@"end_station_city_name"}],
                   @[@{@"title":@"车辆",@"subTitle":@"",@"key":@"truck_number_plate"},
                     @{@"title":@"司机",@"subTitle":@"",@"key":@"truck_driver_name"},
                     @{@"title":@"电话",@"subTitle":@"",@"key":@"truck_driver_phone"},
                     @{@"title":@"登记时间",@"subTitle":@"",@"key":@"register_time"},
                     @{@"title":@"登记运费",@"subTitle":@"",@"key":@"cost_register"},
                     @{@"title":@"装车费",@"subTitle":@"",@"key":@"cost_load"},
                     @{@"title":@"登记人",@"subTitle":@"",@"key":@"operator_name"},],
                   @[@{@"title":@"装车货量",@"subTitle":@"",@"key":@"load_quantity"}],
                   @[@{@"title":@"结算运费",@"subTitle":@"",@"key":@"cost_check"},
                     @{@"title":@"结算日期",@"subTitle":@"",@"key":@"check_time"},
                     @{@"title":@"打款账户",@"subTitle":@"无",@"key":@"driver_account"},
                     @{@"title":@"户主",@"subTitle":@"无",@"key":@"driver_account_name"},
                     @{@"title":@"开户行",@"subTitle":@"无",@"key":@"driver_account_bank"}]];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSDictionary *m_dic = @{@"transport_truck_id" : self.truckData.transport_truck_id};
//    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_queryTransportTruckDetailByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = (ResponseItem *)responseBody;
            if (item.items.count) {
                weakself.detailData = [AppTransportTruckDetailInfo mj_objectWithKeyValues:item.items[0]];
            }
            [weakself updateSubviews];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

//- (void)endRefreshing {
//    [self doHideHudFunction];
//}

- (void)updateSubviews {
    if (!self.detailData.check_time.length) {
        self.detailData.check_time = stringFromDate([NSDate date], defaultDateFormat);
    }
    [self.tableView reloadData];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.detailData ? self.showArray.count - (self.detailData.cost_check.length == 0) : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1 + MAX(1, self.detailData.end_station.count);
    }
    NSArray *m_array = self.showArray[section];
    return m_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return kEdge;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = kCellHeightFilter;
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TTPayCost_cell";
    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.baseView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        cell.baseView.textField.enabled = NO;
        cell.baseView.lineView.hidden = YES;
        //        UIButton *btn = [[IndexPathButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        //        [btn setImage:[UIImage imageNamed:@"list_icon_common"] forState:UIControlStateNormal];
        //        [cell.baseView addRightView:btn];
    }
    NSArray *m_array = self.showArray[indexPath.section];
    NSDictionary *m_dic = nil;
    if (indexPath.row < m_array.count) {
        m_dic = m_array[indexPath.row];
        cell.baseView.textLabel.text = m_dic[@"title"];
        cell.baseView.textField.placeholder = m_dic[@"subTitle"];
        cell.baseView.textField.text = @"";
        cell.baseView.textField.indexPath = [indexPath copy];
    }
    else {
        cell.baseView.textLabel.text = @"";
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                cell.baseView.textField.text = self.detailData.start_station_city_name;
            }
            else {
                NSUInteger index = indexPath.row - 1;
                if (index < self.detailData.end_station.count) {
                    AppEndStationInfo *station = self.detailData.end_station[index];
                    cell.baseView.textField.text = [NSString stringWithFormat:@"%@-%@", station.end_station_city_name, station.end_station_service_name];
                }
                else {
                    cell.baseView.textField.text = @"";
                }
            }
        }
            break;
            
        case 1:
        case 2:
        case 3:{
            NSString *key = m_dic[@"key"];
            if ([key isEqualToString:@"cost_load"] || [key isEqualToString:@"cost_register"] || [key isEqualToString:@"cost_check"]) {
                cell.baseView.textField.text = notShowFooterZeroString([self.detailData valueForKey:key], @"0");
            }
            else {
                cell.baseView.textField.text = [self.detailData valueForKey:key];
            }
            
            if (indexPath.section == 2) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 2) {
        TTLoadListVC *vc = [TTLoadListVC new];
        vc.data = self.truckData;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
