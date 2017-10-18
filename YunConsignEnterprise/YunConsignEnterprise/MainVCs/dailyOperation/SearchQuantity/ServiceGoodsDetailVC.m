//
//  ServiceGoodsDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "ServiceGoodsDetailVC.h"

#import "MJRefresh.h"
#import "PublicMutableLabelView.h"
#import "ServiceGoodsDetailCell.h"

@interface ServiceGoodsDetailVC ()

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIView *headerView;

@end

@implementation ServiceGoodsDetailVC

- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.tableHeaderView = self.headerView;
    [self updateTableViewHeader];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:[NSString stringWithFormat:@"%@-货量明细", self.serviceQuantityData.service_name] createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadFirstPageData{
    [self pullDataFunction:YES];
}

- (void)loadMoreData{
    [self pullDataFunction:NO];
}

- (void)pullDataFunction:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"start_time" : stringFromDate(self.searchData.start_time, @"yyyy-MM-dd"), @"end_time" : stringFromDate(self.searchData.end_time, @"yyyy-MM-dd"), @"service_id" : self.serviceQuantityData.service_id, @"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    if (self.searchData.start_station_city) {
        [m_dic setObject:self.searchData.start_station_city.open_city_id forKey:@"start_station_city_id"];
    }
    if (self.searchData.end_station_city) {
        [m_dic setObject:self.searchData.end_station_city.open_city_id forKey:@"end_station_city_id"];
    }
    
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_queryServiceGoodsDetailByCondition" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppServiceGoodsDetailInfo mj_objectArrayWithKeyValuesArray:item.items]];
            if (item.total < appPageSize) {
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
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (UIView *)headerView {
    if (!_headerView) {
        CGFloat m_edge = kEdge;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeight + 2 * m_edge)];
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, m_edge, _headerView.width, _headerView.height - 2 * m_edge)];
        baseView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:baseView];
        
        UILabel *timeLabel = NewLabel(CGRectMake(kEdgeMiddle, 0, baseView.width - 2 * kEdgeMiddle, baseView.height), nil, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
        timeLabel.text = [NSString stringWithFormat:@"%@~%@", self.searchData.showStartTimeString, self.searchData.showEndTimeString];
        [baseView addSubview:timeLabel];
        
        UILabel *stationLabel = NewLabel(timeLabel.frame, timeLabel.textColor, timeLabel.font, NSTextAlignmentRight);
        stationLabel.text = [NSString stringWithFormat:@"%@->%@", self.searchData.showStartStationString, self.searchData.showEndStationString];
        [baseView addSubview:stationLabel];
        
        [baseView addSubview:NewSeparatorLine(CGRectMake(0, 0, baseView.width, appSeparaterLineSize))];
        [baseView addSubview:NewSeparatorLine(CGRectMake(0, baseView.height - appSeparaterLineSize, baseView.width, appSeparaterLineSize))];
    }
    return _headerView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count ? self.dataSource.count + 1 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        return [ServiceGoodsDetailCell tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"goods_header_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            PublicMutableLabelView *m_view = [[PublicMutableLabelView alloc] initWithFrame:CGRectMake(0, 0, screen_width, [self tableView:tableView heightForRowAtIndexPath:indexPath])];
            [m_view updateEdgeSourceWithArray:@[@0.4, @0.2, @0.2, @0.2]];
            [m_view updateDataSourceWithArray:@[@"货物编号", @"货物", @"运费", @"装车"]];
            [cell.contentView addSubview:m_view];
        }
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"goods_list_cell";
        ServiceGoodsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[ServiceGoodsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.data = self.dataSource[indexPath.row - 1];
        return cell;
    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

@end