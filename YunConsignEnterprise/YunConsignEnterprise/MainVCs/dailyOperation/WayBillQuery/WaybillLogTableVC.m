//
//  WaybillLogTableVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/23.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillLogTableVC.h"

#import "MJRefresh.h"
#import "SingleInputCell.h"
#import "WaybillLogCell.h"

@interface WaybillLogTableVC ()

@property (assign, nonatomic) NSInteger indextag;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSString *dateKey;

@end

@implementation WaybillLogTableVC

- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (instancetype)initWithStyle:(UITableViewStyle)style andIndexTag:(NSInteger)index{
    self = [super initWithStyle:style];
    if (self) {
        self.indextag = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
}

- (void)becomeListed{
    NSDate *lastRefreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
    if (!self.dataSource.count || !lastRefreshTime || [lastRefreshTime timeIntervalSinceNow] < -appRefreshTime) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)becomeUnListed{
    
}

- (void)loadFirstPageData{
    [self queryWaybillListByConditionFunction:YES];
}

- (void)loadMoreData{
    [self queryWaybillListByConditionFunction:NO];
}

- (void)queryWaybillListByConditionFunction:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_id" : self.detailData.waybill_id, @"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_queryWaybillLogByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            if (item.items.count) {
                NSDictionary *m_dic = item.items[0];
                self.detailData.join_short_name = m_dic[@"join_name"];
                switch (self.indextag) {
                    case 0:{
                        [self.dataSource addObjectsFromArray:[self sortArrayByTime:[AppWaybillLogInfo mj_objectArrayWithKeyValuesArray:m_dic[@"transport_log"]]]];
                    }
                        break;
                        
                    case 1:{
                        [self.dataSource addObjectsFromArray:[self sortArrayByTime:[AppWaybillLogInfo mj_objectArrayWithKeyValuesArray:m_dic[@"cash_on_delivery_log"]]]];
                    }
                        break;
                        
                    case 2:{
                        [self.dataSource addObjectsFromArray:[self sortArrayByTime:[AppWaybillLogInfo mj_objectArrayWithKeyValuesArray:m_dic[@"receipt_log"]]]];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
//            [weakself.dataSource addObjectsFromArray:[AppTransportTrunkInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
//            if (item.total <= weakself.dataSource.count) {
//                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//            else {
//                [weakself updateTableViewFooter];
//            }
            [weakself.tableView reloadData];
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
    //记录刷新时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.dateKey];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (NSArray *)sortArrayByTime:(NSArray *)array {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"follow_time" ascending:NO];
    return [array sortedArrayUsingDescriptors:@[sortDescriptor]];
}

#pragma mark - getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}


- (NSString *)dateKey{
    if (!_dateKey) {
        _dateKey = [NSString stringWithFormat:@"WaybillLog_dateKey_%d",(int)self.indextag];
    }
    return _dateKey;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return self.dataSource.count;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return [WaybillLogCell tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return kEdge;
    }
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"way_bill_log_introduce_cell";
        SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.baseView.textField.enabled = NO;
            cell.baseView.textLabel.textColor = secondaryTextColor;
            cell.baseView.textLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
            cell.baseView.textField.textColor = secondaryTextColor;
            cell.baseView.textField.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
            [cell.baseView.lineView removeFromSuperview];
//            [cell.contentView addSubview:NewSeparatorLine(CGRectMake(0, 0, screen_width, appSeparaterLineSize))];
//            [cell.contentView addSubview:NewSeparatorLine(CGRectMake(0, [self tableView:tableView heightForRowAtIndexPath:indexPath] - appSeparaterLineSize, screen_width, appSeparaterLineSize))];
        }
        
        if (indexPath.row == 0) {
            cell.baseView.textLabel.text = [NSString stringWithFormat:@"运单号：%@", self.detailData.waybill_number];
            cell.baseView.textField.text = [NSString stringWithFormat:@"货号：%@", self.detailData.goods_number];
        }
        else {
            cell.baseView.textLabel.text = [NSString stringWithFormat:@"%@ %@->%@ %@", self.detailData.start_station_city_name, self.detailData.shipper_name, self.detailData.end_station_city_name, self.detailData.consignee_name];
            cell.baseView.textField.text = [NSString stringWithFormat:@"%@", self.detailData.join_short_name.length ? self.detailData.join_short_name : @""];
        }
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"way_bill_log_cell";
         WaybillLogCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[ WaybillLogCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
        }
        cell.data = self.dataSource[indexPath.row];
        cell.isShowTopEdge = indexPath.row == 0;
        cell.isShowBottomEdge = indexPath.row == self.dataSource.count - 1;
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
}

@end
