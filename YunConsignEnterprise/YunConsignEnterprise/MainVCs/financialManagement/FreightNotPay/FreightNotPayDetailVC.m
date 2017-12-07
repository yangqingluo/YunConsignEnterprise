//
//  FreightNotPayDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/12/5.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "FreightNotPayDetailVC.h"

#import "FreightNotPayCell.h"
#import "PublicMutableButtonView.h"

@interface FreightNotPayDetailVC ()

@property (strong, nonatomic) PublicMutableLabelView *footerView;

@end

@implementation FreightNotPayDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.footerView.width = self.scrollView.contentSize.width;
    self.footerView.bottom = self.scrollView.height;
    [self.scrollView addSubview:self.footerView];
    self.tableView.height = self.footerView.top - self.tableView.top;
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"未收运输款对账" createMenuItem:^UIView *(int nIndex){
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
        if (self.condition.query_column && self.condition.query_val) {
            [m_dic setObject:self.condition.query_column.item_val forKey:@"query_column"];
            [m_dic setObject:self.condition.query_val forKey:@"query_val"];
        }
        if (self.condition.show_column.count) {
            [m_dic setObject:[self.condition showArrayValStringWithKey:@"show_column"] forKey:@"show_column"];
        }
        if (self.condition.order_by.length) {
            [m_dic setObject:self.condition.order_by forKey:@"order_by"];
        }
    }
    [self pullBaseTotalData:isReset parm:m_dic];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_finance_queryNotPayFreightListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
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

- (void)pullBaseTotalData:(BOOL)isReset parm:(NSDictionary *)parm {
    if (!isReset) {
        return;
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_finance_queryNotPayFreightTotalByConditionFunction" Parm:parm completion:^(id responseBody, NSError *error){
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

- (void)doCancelReceiveWaybillFunctionAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row > self.dataSource.count - 1) {
//        return;
//    }
//    
//    AppWayBillDetailInfo *item = self.dataSource[indexPath.row];
//    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_id" : item.waybill_id}];
//    [self doShowHudFunction];
//    QKWEAKSELF;
//    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_receive_cancelReceiveWaybillByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
//        [weakself endRefreshing];
//        if (!error) {
//            ResponseItem *item = responseBody;
//            if (item.flag == 1) {
//                [weakself.dataSource removeObjectAtIndex:indexPath.row];
//                [weakself updateSubviews];
//            }
//            else {
//                [weakself showHint:item.message.length ? item.message : @"数据出错"];
//            }
//        }
//        else {
//            [weakself showHint:error.userInfo[@"message"]];
//        }
//    }];
}

- (void)updateSubviews {
    if (self.dataSource.count) {
        self.footerView.hidden = NO;
        
        NSMutableArray *m_array = [NSMutableArray new];
        [m_array addObject:@"总计"];
        [m_array addObject:notNilString([self.totalData valueForKey:@"waybill_count"], @"0")];
        [m_array addObject:notNilString([self.totalData valueForKey:@"consignee_name"], @"")];
        for (AppDataDictionary *map_item in self.condition.show_column) {
            [m_array addObject:notNilString([self.totalData valueForKey:map_item.item_val], @"0")];
        }
        [self.footerView updateDataSourceWithArray:m_array];
        [self.tableView reloadData];
    }
    else {
        self.footerView.hidden = YES;
    }
}

//- (void)updateTableViewHeader {
//    [super updateTableViewHeader];
//    self.tableView.mj_header.autoresizingMask = UIViewAutoresizingNone;
//    self.tableView.mj_header.width = screen_width;
//}
//
//- (void)updateTableViewFooter {
//    [super updateTableViewFooter];
//    self.tableView.mj_footer.autoresizingMask = UIViewAutoresizingNone;
//    self.tableView.mj_footer.width = screen_width;
//}

#pragma mark - 长按手势事件
- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        CGPoint location = [recognizer locationInView:self.tableView];
//        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
//        
//        AppWayBillDetailInfo *item = self.dataSource[indexPath.row];
//        //取消自提
//        QKWEAKSELF;
//        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"确定取消自提吗" message:[NSString stringWithFormat:@"货号：%@\n运单号：%@", item.goods_number, item.waybill_number] cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                [weakself doCancelReceiveWaybillFunctionAtIndexPath:indexPath];
//            }
//        } otherButtonTitles:@"确定", nil];
//        [alert show];
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
    return [FreightNotPayCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.dataSource.count ? [FreightNotPayCell tableView:tableView heightForRowAtIndexPath:nil] : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataSource.count) {
        CGFloat m_height = [FreightNotPayCell tableView:tableView heightForRowAtIndexPath:nil];
        PublicMutableButtonView *m_view = [[PublicMutableButtonView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, m_height)];
        m_view.backgroundColor = CellHeaderLightBlueColor;
        [m_view updateEdgeSourceWithArray:self.edgeArray];
        NSMutableArray *m_array = [NSMutableArray arrayWithObjects:@"序号", @"货号", @"姓名", nil];
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
    static NSString *CellIdentifier = @"FreightNotPayCell";
    FreightNotPayCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[FreightNotPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier showWidth:self.scrollView.contentSize.width showValueArray:self.valArray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.baseView updateEdgeSourceWithArray:self.edgeArray];
        [cell.contentView addSubview:NewSeparatorLine(CGRectMake(0, [self tableView:tableView heightForRowAtIndexPath:indexPath] - appSeparaterLineSize, self.scrollView.contentSize.width, appSeparaterLineSize))];
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

//#pragma mark - UIScrollViewDelegate
///*滚动停止时，触发该函数*/
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//
//}
///* 触摸屏幕来滚动画面还是其他的方法使得画面滚动，皆触发该函数*/
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    self.tableView.mj_header.left = scrollView.contentOffset.x;
//    UIView *m_view = self.tableView.mj_header;
//    self.tableView.mj_footer.left = scrollView.contentOffset.x;
//}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicMutableButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        int tag = [m_dic[@"tag"] intValue] - 3;
        if (tag >= 0 && tag < self.valArray.count) {
            NSString *val = self.valArray[tag];
            if ([self.condition.order_by hasSuffix:@"desc"]) {
                self.condition.order_by = [NSString stringWithFormat:@"%@ asc", val];
            }
            else {
                self.condition.order_by = [NSString stringWithFormat:@"%@ desc", val];
            }
            [self loadFirstPageData];
        }
    }
}

@end
