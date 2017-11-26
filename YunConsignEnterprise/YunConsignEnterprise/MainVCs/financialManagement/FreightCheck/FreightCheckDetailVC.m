//
//  FreightCheckDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/31.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "FreightCheckDetailVC.h"

#import "FreightCheckCell.h"

@interface FreightCheckDetailVC ()

@property (strong, nonatomic) PublicMutableLabelView *footerView;
@property (strong, nonatomic) NSMutableArray *valArray;
@property (strong, nonatomic) NSMutableArray *nameArray;
@property (strong, nonatomic) NSMutableArray *edgeArray;

@end

@implementation FreightCheckDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    _valArray = [NSMutableArray new];
    _nameArray = [NSMutableArray new];
    _edgeArray = [NSMutableArray new];
    CGFloat scale = 4.0f + 2.0 * self.condition.show_column.count;
    [_edgeArray addObject:@(1.0 / scale)];
    [_edgeArray addObject:@(3.0 / scale)];
    for (AppDataDictionary *item in self.condition.show_column) {
        [_valArray addObject:item.item_val];
        [_nameArray addObject:item.item_name];
        [_edgeArray addObject:@(2.0 / scale)];
    }
    
    [self.scrollView addSubview:self.tableView];
    
    self.footerView.bottom = self.view.height;
    [self.scrollView addSubview:self.footerView];
    self.tableView.height = self.footerView.top - self.tableView.top;
    
    CGFloat contentWidth = MAX(screen_width, 37.5 * scale);
    self.footerView.width = contentWidth;
    self.tableView.width = contentWidth;
//        self.tableView.clipsToBounds = NO;
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.scrollView.height);
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"运输款对账" createMenuItem:^UIView *(int nIndex){
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
        if (self.condition.search_time_type) {
            [m_dic setObject:self.condition.search_time_type.item_val forKey:@"time_type"];
        }
        if (self.condition.power_service) {
            [m_dic setObject:self.condition.power_service.service_id forKey:@"power_service_id"];
        }
        if (self.condition.query_column && self.condition.query_val) {
            [m_dic setObject:self.condition.query_column.item_val forKey:@"query_column"];
            [m_dic setObject:self.condition.query_val forKey:@"query_val"];
        }
        if (self.condition.show_column.count) {
            [m_dic setObject:[self.condition showArrayValStringWithKey:@"show_column"] forKey:@"show_column"];
        }
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_finance_queryCheckFreightListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppWayBillDetailInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
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

- (void)doCancelReceiveWaybillFunctionAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.dataSource.count - 1) {
        return;
    }
    
    AppWayBillDetailInfo *item = self.dataSource[indexPath.row];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_id" : item.waybill_id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_receive_cancelReceiveWaybillByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself.dataSource removeObjectAtIndex:indexPath.row];
                [weakself updateSubviews];
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

- (void)updateSubviews {
    NSMutableArray *m_array = [NSMutableArray new];
    [m_array addObject:@"总"];
    [m_array addObject:[NSString stringWithFormat:@"%d", (int)self.dataSource.count]];
    for (AppDataDictionary *map_item in self.condition.show_column) {
        int amount = 0;
        for (AppWayBillDetailInfo *item in self.dataSource) {
            if ([AppPublic getVariableWithClass:item.class varName:map_item.item_val] || [AppPublic getVariableWithClass:item.superclass varName:map_item.item_val]) {
                amount += [[item valueForKey:map_item.item_val] intValue];
            }
        }
        [m_array addObject:[NSString stringWithFormat:@"%d", amount]];
    }
    [self.footerView updateDataSourceWithArray:m_array];
    [self.tableView reloadData];
}

#pragma mark - 长按手势事件
- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        
        AppWayBillDetailInfo *item = self.dataSource[indexPath.row];
        //取消自提
        QKWEAKSELF;
        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"确定取消自提吗" message:[NSString stringWithFormat:@"货号：%@\n运单号：%@", item.goods_number, item.waybill_number] cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakself doCancelReceiveWaybillFunctionAtIndexPath:indexPath];
            }
        } otherButtonTitles:@"确定", nil];
        [alert show];
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
    return [FreightCheckCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.dataSource.count ? [FreightCheckCell tableView:tableView heightForRowAtIndexPath:nil] : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataSource.count) {
        CGFloat m_height = [FreightCheckCell tableView:tableView heightForRowAtIndexPath:nil];
        PublicMutableLabelView *m_view = [[PublicMutableLabelView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, m_height)];
        m_view.backgroundColor = CellHeaderLightBlueColor;
        [m_view updateEdgeSourceWithArray:self.edgeArray];
        NSMutableArray *m_array = [NSMutableArray arrayWithObjects:@"序号", @"货号", nil];
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
    static NSString *CellIdentifier = @"FreightCheckCell";
    FreightCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[FreightCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier showWidth:self.scrollView.contentSize.width showValueArray:self.valArray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.baseView updateEdgeSourceWithArray:self.edgeArray];
        
        //添加长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        [cell addGestureRecognizer:longPressGesture];
    }
    cell.indexPath = [indexPath copy];
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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
