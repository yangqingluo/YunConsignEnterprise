//
//  TransportTruckLoadListVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/24.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "TTLoadListVC.h"

#import "TransportTruckLoadListCell.h"
#import "PublicFooterSummaryView.h"

@interface TTLoadListVC ()

@property (strong, nonatomic) PublicFooterSummaryView *footerView;
@property (strong, nonatomic) AppTransportTruckLoadInfo *summaryInfo;

@end

@implementation TTLoadListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.footerView.bottom = self.view.height;
    [self.view addSubview:self.footerView];
    self.tableView.height = self.footerView.top - self.tableView.top;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"装车货量" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"transport_truck_id" : self.data.transport_truck_id, @"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_queryTransportTruckLoadListByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppTransportTruckLoadInfo  mj_objectArrayWithKeyValuesArray:item.items]];
            
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

- (void)updateSubviews {
    int load_quantity = 0;
    int load_count_first = 0;
    int load_count_second = 0;
    for (AppTransportTruckLoadInfo *item in self.dataSource) {
        load_quantity += [item.load_quantity intValue];
        NSArray *m_array = [item.load_count componentsSeparatedByString:@"/"];
        if (m_array.count == 2) {
            load_count_first += [m_array[0] intValue];
            load_count_second += [m_array[1] intValue];
        }
    }
    self.summaryInfo.load_quantity = [NSString stringWithFormat:@"%d", load_quantity];
    self.summaryInfo.load_count = [NSString stringWithFormat:@"%d/%d", load_count_first, load_count_second];
    
    self.footerView.textLabel.text = [NSString stringWithFormat:@"%@：%@/%@", self.summaryInfo.load_service_name, self.summaryInfo.load_quantity, self.summaryInfo.load_count];
    [self.tableView reloadData];
}

#pragma mark - getter
- (PublicFooterSummaryView *)footerView {
    if (!_footerView) {
        _footerView = [[PublicFooterSummaryView alloc] initWithFrame:CGRectMake(0, 0, screen_width, DEFAULT_BAR_HEIGHT)];
        _footerView.textLabel.text = @"总计：";
    }
    return _footerView;
}

- (AppTransportTruckLoadInfo *)summaryInfo {
    if (!_summaryInfo) {
        _summaryInfo = [AppTransportTruckLoadInfo new];
        _summaryInfo.load_service_name = @"总计";
        _summaryInfo.load_quantity = @"0";
        _summaryInfo.load_count = @"0/0";
    }
    return _summaryInfo;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TransportTruckLoadListCell tableView:tableView heightForRowAtIndexPath:indexPath dataArray:self.dataSource];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TransportTruckLoadListCell";
    TransportTruckLoadListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TransportTruckLoadListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.dataArray = self.dataSource;
    return cell;
}

@end
