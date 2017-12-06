//
//  PayOnReceiptVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PayOnReceiptVC.h"
#import "PublicQueryConditionVC.h"
#import "PublicWaybillDetailVC.h"

#import "PayOnReceiptCell.h"
#import "MJRefresh.h"

@interface PayOnReceiptVC ()

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) AppQueryConditionInfo *condition;

@end

@implementation PayOnReceiptVC

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
    vc.type = QueryConditionType_PayOnReceipt;
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
        if (self.condition.query_column && self.condition.query_val) {
            [m_dic setObject:self.condition.query_column.item_val forKey:@"query_column"];
            [m_dic setObject:self.condition.query_val forKey:@"query_val"];
        }
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_receipt_queryNeedReceiptWaybillListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppNeedReceiptWayBillInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
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
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - getter
- (AppQueryConditionInfo *)condition {
    if (!_condition) {
        _condition = [AppQueryConditionInfo new];
        _condition.start_time = [_condition.end_time dateByAddingTimeInterval:-2 * defaultDayTimeInterval];
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
    return [PayOnReceiptCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PayOnReceiptCell";
    PayOnReceiptCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[PayOnReceiptCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.data = self.dataSource[indexPath.row];
    cell.indexPath = [indexPath copy];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PublicWaybillDetailVC *vc = [PublicWaybillDetailVC new];
    vc.type = WaybillDetailType_WayBillQuery;
    vc.data = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicMutableButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        //        NSIndexPath *indexPath = m_dic[@"indexPath"];
        int tag = [m_dic[@"tag"] intValue];
        switch (tag) {
            case 0:{
                
            }
                break;
                
            case 1:{
                
            }
                break;
                
            default:
                break;
        }
    }
}

@end
