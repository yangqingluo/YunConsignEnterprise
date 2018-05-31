//
//  CodCheckDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/1.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodCheckDetailVC.h"

#import "CodCheckCell.h"
#import "PublicMutableButtonView.h"

@interface CodCheckDetailVC ()

@property (strong, nonatomic) PublicMutableLabelView *footerView;

@end

@implementation CodCheckDetailVC

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
    [self createNavWithTitle:@"代收款对账" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
//        else if (nIndex == 1){
//            UIButton *btn = NewTextButton(@"对比", [UIColor whiteColor]);
//            [btn addTarget:self action:@selector(compareButtonAction) forControlEvents:UIControlEventTouchUpInside];
//            return btn;
//        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)compareButtonAction {
//    
//}

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
        if (self.condition.query_column_s && self.condition.query_val) {
            [m_dic setObject:self.condition.query_column_s.item_val forKey:@"query_column"];
            [m_dic setObject:self.condition.query_val forKey:@"query_val"];
        }
        if (self.condition.power_service_array.count) {
            NSArray *power_array = self.condition.IDArrayForPowerServiceArray;
            [m_dic setObject:[power_array componentsJoinedByString:@","] forKey:@"power_service_id"];
        }
        if (self.condition.cash_on_delivery_type) {
            [m_dic setObject:self.condition.cash_on_delivery_type.item_val forKey:@"cash_on_delivery_type"];
        }
        if (self.condition.order_by.length) {
            [m_dic setObject:self.condition.order_by forKey:@"order_by"];
        }
    }
    [self doShowHudFunction];
    [self pullBaseTotalData:isReset parm:m_dic];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_finance_queryCheckCashOnDeliveryListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
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
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_finance_queryCheckCashOnDeliveryCountByConditionFunction" Parm:parm completion:^(id responseBody, NSError *error){
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

- (void)doCancelWaybillCashOnDeliveryPaymentByIdFunctionAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.dataSource.count - 1) {
        return;
    }
    
    AppWayBillDetailInfo *item = self.dataSource[indexPath.row];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_id" : item.waybill_id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_finance_cancelWaybillCashOnDeliveryPaymentByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
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
    if (self.dataSource.count) {
        self.footerView.hidden = NO;
        
        NSMutableArray *m_array = [NSMutableArray new];
        [m_array addObject:@"总计"];
        [m_array addObject:[NSString stringWithFormat:@"%d", [self.totalData[@"waybill_count"] intValue]]];
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

#pragma mark - 长按手势事件
- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        
        AppWayBillDetailInfo *item = self.dataSource[indexPath.row];
        //取消收款
        QKWEAKSELF;
        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"确定取消收款吗" message:[NSString stringWithFormat:@"货号：%@\n运单号：%@", item.goods_number, item.waybill_number] cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakself doCancelWaybillCashOnDeliveryPaymentByIdFunctionAtIndexPath:indexPath];
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
    return [CodCheckCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.dataSource.count ? [CodCheckCell tableView:tableView heightForRowAtIndexPath:nil] : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataSource.count) {
        CGFloat m_height = [CodCheckCell tableView:tableView heightForRowAtIndexPath:nil];
        PublicMutableButtonView *m_view = [[PublicMutableButtonView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, m_height)];
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
    static NSString *CellIdentifier = @"CodCheckCell";
    CodCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[CodCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier showWidth:self.scrollView.contentSize.width showValueArray:self.valArray];
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
    
    AppWayBillDetailInfo *item = self.dataSource[indexPath.row];
    //取消收款
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"确定取消收款吗" message:[NSString stringWithFormat:@"货号：%@\n运单号：%@", item.goods_number, item.waybill_number] cancelButtonTitle:@"取消" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakself doCancelWaybillCashOnDeliveryPaymentByIdFunctionAtIndexPath:indexPath];
        }
    } otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicMutableButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        int tag = [m_dic[@"tag"] intValue] - 2;
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
