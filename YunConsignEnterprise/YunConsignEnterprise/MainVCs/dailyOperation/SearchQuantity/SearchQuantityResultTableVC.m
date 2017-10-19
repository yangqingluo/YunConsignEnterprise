//
//  SearchQuantityResultTableVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SearchQuantityResultTableVC.h"
#import "ServiceGoodsDetailVC.h"

#import "MJRefresh.h"
#import "PublicMutableLabelView.h"
#import "SearchQuantityResultCell.h"

@interface SearchQuantityResultTableVC ()

@property (assign, nonatomic) NSInteger indextag;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSString *dateKey;

@property (strong, nonatomic) UIView *headerView;

@end

@implementation SearchQuantityResultTableVC

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
    self.tableView.tableHeaderView = self.headerView;
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
    [self pullDataFunction:YES];
}

- (void)loadMoreData{
    [self pullDataFunction:NO];
}

- (void)pullDataFunction:(BOOL)isReset {
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
    }
    
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:self.indextag == 0 ? @"hex_dispatch_queryRouteGoodsQuantityByConditionFunction" : @"hex_dispatch_queryServiceGoodsQuantityByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            
            if (self.indextag == 0) {
                [weakself.dataSource addObjectsFromArray:[AppRouteGoodsQuantityInfo mj_objectArrayWithKeyValuesArray:item.items]];
            }
            else {
                [weakself.dataSource addObjectsFromArray:[AppServiceGoodsQuantityInfo mj_objectArrayWithKeyValuesArray:item.items]];
            }
            
            
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
    //记录刷新时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.dateKey];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)cellActionBtnAction:(UIButton *)button {
    if (self.indextag == 0) {
        AppRouteGoodsQuantityInfo *m_data = self.dataSource[button.tag];
        
    }
    else if (self.indextag == 1) {
        ServiceGoodsDetailVC *vc = [ServiceGoodsDetailVC new];
        vc.condition = [self.condition copy];
        vc.serviceQuantityData = self.dataSource[button.tag];
        [[UserPublic getInstance].mainTabNav pushViewController:vc animated:YES];
    }
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
        _dateKey = [NSString stringWithFormat:@"SearchQuantityResult_dateKey_%d",(int)self.indextag];
    }
    return _dateKey;
}

- (UIView *)headerView {
    if (!_headerView) {
        CGFloat m_edge = kEdge;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeight + 2 * m_edge)];
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, m_edge, _headerView.width, _headerView.height - 2 * m_edge)];
        baseView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:baseView];
        
        UILabel *timeLabel = NewLabel(CGRectMake(kEdgeMiddle, 0, baseView.width - 2 * kEdgeMiddle, baseView.height), nil, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
        timeLabel.text = [NSString stringWithFormat:@"%@~%@", self.condition.showStartTimeString, self.condition.showEndTimeString];
        [baseView addSubview:timeLabel];
        
        UILabel *stationLabel = NewLabel(timeLabel.frame, timeLabel.textColor, timeLabel.font, NSTextAlignmentRight);
        stationLabel.text = [NSString stringWithFormat:@"%@->%@", self.condition.showStartStationString, self.condition.showEndStationString];
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
        return [SearchQuantityResultCell tableView:tableView heightForRowAtIndexPath:indexPath];
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
            [m_view updateDataSourceWithArray:@[self.indextag == 0 ? @"线路" : @"门店", @"货量", @"操作"]];
            [cell.contentView addSubview:m_view];
        }
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"goods_list_cell";
        SearchQuantityResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[SearchQuantityResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            [cell.actionBtn addTarget:self action:@selector(cellActionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.data = self.dataSource[indexPath.row - 1];
        cell.actionBtn.tag = indexPath.row - 1;
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
