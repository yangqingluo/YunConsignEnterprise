//
//  CodQueryDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/31.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodQueryDetailVC.h"
#import "PublicWaybillDetailVC.h"

#import "CodQueryCell.h"

@interface CodQueryDetailVC ()


@end

@implementation CodQueryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"代收款查询" createMenuItem:^UIView *(int nIndex){
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
        if (self.condition.query_column && self.condition.query_val) {
            [m_dic setObject:self.condition.query_column.item_val forKey:@"query_column"];
            [m_dic setObject:self.condition.query_val forKey:@"query_val"];
        }
        if (self.condition.start_service) {
            [m_dic setObject:self.condition.start_service.service_id forKey:@"start_service_id"];
        }
        if (self.condition.end_service) {
            [m_dic setObject:self.condition.end_service.service_id forKey:@"end_service_id"];
        }
        if (self.condition.cash_on_delivery_type) {
            [m_dic setObject:self.condition.cash_on_delivery_type.item_val forKey:@"cash_on_delivery_type"];
        }
        if (self.condition.cod_payment_state) {
            [m_dic setObject:self.condition.cod_payment_state.item_val forKey:@"cod_payment_state"];
        }
        if (self.condition.cod_loan_state) {
            [m_dic setObject:self.condition.cod_loan_state.item_val forKey:@"cod_loan_state"];
        }
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_finance_queryCashOnDeliveryListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            [weakself.dataSource addObjectsFromArray:[AppCashOnDeliveryWayBillInfo  mj_objectArrayWithKeyValuesArray:item.items]];
            
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

#pragma mark - getter


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger lines = 3;
    AppCashOnDeliveryWayBillInfo *item = self.dataSource[indexPath.row];
    if ([item.cash_on_delivery_causes_amount intValue] > 0) {
        lines++;
    }
    if (item.remitter_name.length) {
        lines++;
    }
    return [CodQueryCell tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:lines];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeSmall;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CodQueryCell";
    CodQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[CodQueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = [indexPath copy];
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PublicWaybillDetailVC *vc = [PublicWaybillDetailVC new];
    vc.type = WaybillDetailType_CodQuery;
    vc.data = self.dataSource[indexPath.row];
    [self doPushViewController:vc animated:YES];
}

@end
