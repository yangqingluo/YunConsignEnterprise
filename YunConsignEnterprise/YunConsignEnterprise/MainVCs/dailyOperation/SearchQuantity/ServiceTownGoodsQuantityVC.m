//
//  ServiceTownGoodsQuantityVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/5/7.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "ServiceTownGoodsQuantityVC.h"

#import "PublicMutableLabelView.h"
#import "SearchQuantityResultCell.h"
#import "PublicFooterSummaryView.h"

@interface ServiceTownGoodsQuantityVC ()

@property (strong, nonatomic) PublicFooterSummaryView *footerView;
@property (strong, nonatomic) NSMutableArray *totalDataSource;

@end

@implementation ServiceTownGoodsQuantityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.footerView.bottom = self.view.height;
    [self.view addSubview:self.footerView];
    
    self.tableView.height -= self.footerView.height;
    
    [self updateTableViewHeader];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"中转站货量" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    [m_dic setObject:self.routeGoodsData.start_station_city_id forKey:@"start_station_city_id"];
    [m_dic setObject:self.routeGoodsData.end_station_city_id forKey:@"end_station_city_id"];
    if (self.condition) {
        if (self.condition.start_time) {
            [m_dic setObject:stringFromDate(self.condition.start_time, nil) forKey:@"start_time"];
        }
        if (self.condition.end_time) {
            [m_dic setObject:stringFromDate(self.condition.end_time, nil) forKey:@"end_time"];
        }
    }
    [self pullBaseTotalData:isReset parm:m_dic];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_queryTownGoodsQuantityByRouteFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppRouteGoodsQuantityInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
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

- (void)pullBaseTotalData:(BOOL)isReset parm:(NSDictionary *)parm {
    if (!isReset) {
        return;
    }
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:parm];
    [m_dic setObject:@"0" forKey:@"start"];
    [m_dic setObject:@"1000" forKey:@"limit"];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_queryTownGoodsQuantityByRouteFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            [weakself.totalDataSource removeAllObjects];
            ResponseItem *item = responseBody;
            [weakself.totalDataSource addObjectsFromArray:[AppRouteGoodsQuantityInfo mj_objectArrayWithKeyValuesArray:item.items]];
            [weakself updateSubviews];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)updateFooterSummary {
    int quantity = 0;
    int remain = 0;
    for (AppGoodsQuantityInfo *item in self.totalDataSource) {
        quantity += [item.quantity intValue];
        remain += [item.remain intValue];
    }
    self.footerView.textLabel.text = [NSString stringWithFormat:@"总货量：%d，总剩货：%d", quantity, remain];
}

- (void)updateSubviews {
    [self updateFooterSummary];
    [self.tableView reloadData];
}

#pragma mark - getter
- (PublicFooterSummaryView *)footerView {
    if (!_footerView) {
        _footerView = [[PublicFooterSummaryView alloc] initWithFrame:CGRectMake(0, 0, screen_width, DEFAULT_BAR_HEIGHT)];
        _footerView.backgroundColor = [UIColor clearColor];
    }
    return _footerView;
}

- (NSMutableArray *)totalDataSource {
    if (!_totalDataSource) {
        _totalDataSource = [NSMutableArray new];
    }
    return _totalDataSource;
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
            [m_view updateDataSourceWithArray:@[@"线路", @"货量", @"剩货"]];
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
        }
        cell.data = self.dataSource[indexPath.row - 1];
        cell.secondLabel.tag = indexPath.row - 1;
        cell.thirdLabel.tag = indexPath.row - 1;
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
