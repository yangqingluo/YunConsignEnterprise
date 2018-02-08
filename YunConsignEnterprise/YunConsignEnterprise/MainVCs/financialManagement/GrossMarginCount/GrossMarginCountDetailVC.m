//
//  GrossMarginCountDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/2/8.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "GrossMarginCountDetailVC.h"

#import "PublicMutableLabelView.h"
#import "GrossMarginCountCell.h"
#import "PublicMutableButtonView.h"

@interface GrossMarginCountDetailVC ()

@property (strong, nonatomic) PublicMutableLabelView *footerView;

@end

@implementation GrossMarginCountDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.footerView.width = self.scrollView.contentSize.width;
    self.footerView.bottom = self.scrollView.height;
    [self.scrollView addSubview:self.footerView];
    self.tableView.height = self.footerView.top - self.tableView.top;
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"毛利统计" createMenuItem:^UIView *(int nIndex){
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

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
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
        if (self.condition.order_by.length) {
            [m_dic setObject:self.condition.order_by forKey:@"order_by"];
        }
    }
    [self doShowHudFunction];
    [self pullBaseTotalData:isReset parm:m_dic];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_finance_queryGrossMarginAmountFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppDailyGrossMarginInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
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
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_finance_queryGrossMarginAmountCountFunction" Parm:parm completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                weakself.totalData = [NSDictionary dictionaryWithDictionary:item.items[0]];
                [weakself updateSubviews];
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)updateSubviews {
    if (self.dataSource.count) {
        self.footerView.hidden = NO;
        
        NSMutableArray *m_array = [NSMutableArray new];
        [m_array addObject:@"总计"];
        [m_array addObject:[NSString stringWithFormat:@"%d", [self.totalData[@"gross_margin_count"] intValue]]];
        for (AppDataDictionary *map_item in self.condition.show_column) {
            if ([map_item.item_val isEqualToString:@"count_date"]) {
                continue;
            }
            [m_array addObject:notNilString([NSString stringWithFormat:@"%@", [self.totalData valueForKey:map_item.item_val]], @"0")];
        }
        [self.footerView updateDataSourceWithArray:m_array];
        [self.tableView reloadData];
    }
    else {
        self.footerView.hidden = YES;
    }
}

#pragma mark - getter
- (PublicMutableLabelView *)footerView {
    if (!_footerView) {
        _footerView = [[PublicMutableLabelView alloc] initWithFrame:CGRectMake(0, 0, screen_width, DEFAULT_BAR_HEIGHT)];
        _footerView.backgroundColor = baseFooterBarColor;
        [_footerView updateEdgeSourceWithArray:self.edgeArray];
        
        [_footerView addSubview:NewSeparatorLine(CGRectMake(0, 0, _footerView.width, appSeparaterLineSize))];
    }
    return _footerView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [GrossMarginCountCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.dataSource.count ? [GrossMarginCountCell tableView:tableView heightForRowAtIndexPath:nil] : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataSource.count) {
        CGFloat m_height = [GrossMarginCountCell tableView:tableView heightForRowAtIndexPath:nil];
        PublicMutableButtonView *m_view = [[PublicMutableButtonView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, m_height)];
        m_view.backgroundColor = CellHeaderLightBlueColor;
        [m_view updateEdgeSourceWithArray:self.edgeArray];
        NSMutableArray *m_array = [NSMutableArray arrayWithObjects:@"序号", nil];
        [m_array addObjectsFromArray:self.nameArray];
        [m_view updateDataSourceWithArray:m_array];
        [m_view addSubview:NewSeparatorLine(CGRectMake(0, 0, m_view.width, appSeparaterLineSize))];
        return m_view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"GrossMarginCountCell";
    GrossMarginCountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[GrossMarginCountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier showWidth:self.scrollView.contentSize.width showValueArray:self.valArray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.baseView updateEdgeSourceWithArray:self.edgeArray];
        [cell.contentView addSubview:NewSeparatorLine(CGRectMake(0, [self tableView:tableView heightForRowAtIndexPath:indexPath] - appSeparaterLineSize, self.scrollView.contentSize.width, appSeparaterLineSize))];
        //添加长按手势
        //        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        //        [cell addGestureRecognizer:longPressGesture];
    }
    cell.indexPath = [indexPath copy];
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
}


@end
