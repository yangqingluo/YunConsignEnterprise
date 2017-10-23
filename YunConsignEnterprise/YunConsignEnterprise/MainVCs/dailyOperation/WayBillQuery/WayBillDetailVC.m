//
//  WayBillDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillDetailVC.h"
#import "WaybillChangeListVC.h"
#import "WaybillEditVC.h"
#import "WaybillLogVC.h"

#import "MJRefresh.h"
#import "PublicMutableButtonView.h"
#import "WayBillDetailHeaderView.h"


@interface WayBillDetailVC ()

@property (strong, nonatomic) WayBillDetailHeaderView *headerView;
@property (strong, nonatomic) PublicMutableButtonView *footerView;

@property (copy, nonatomic) AppWayBillDetailInfo *detailData;

@end

@implementation WayBillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.feeShowArray = @[@{@"title":@"回单",@"subTitle":@"未知",@"key":@"receipt_sign_type"},
                          @{@"title":@"代收款",@"subTitle":@"未知",@"key":@"cash_on_delivery_type"},
                          @{@"title":@"代收款金额",@"subTitle":@"0",@"key":@"cash_on_delivery_amount"},
                          @{@"title":@"运费代扣",@"subTitle":@"未知",@"key":@"is_deduction_freight"},
                          @{@"title":@"叉车费",@"subTitle":@"0",@"key":@"forklift_fee"},
                          @[@{@"title":@"保价",@"subTitle":@"0",@"key":@"insurance_amount"},
                            @{@"title":@"保价费",@"subTitle":@"0",@"key":@"insurance_fee"}],
                          @[@{@"title":@"接货费",@"subTitle":@"0",@"key":@"take_goods_fee"},
                            @{@"title":@"送货费",@"subTitle":@"0",@"key":@"deliver_goods_fee"}],
                          @[@{@"title":@"回扣费",@"subTitle":@"0",@"key":@"rebate_fee"},
                            @{@"title":@"垫付费",@"subTitle":@"0",@"key":@"pay_for_sb_fee"}],
                          @{@"title":@"原返费",@"subTitle":@"0",@"key":@"return_fee"},
                          @{@"title":@"原返运单",@"subTitle":@"无",@"key":@"return_waybill_number"},];
    self.footerView.bottom = self.view.height;
    self.footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.footerView];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.height -= self.footerView.height;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"运单详情" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewRightButton([UIImage imageNamed:@"navbar_icon_edit"], nil);
            [btn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editBtnAction {
    WaybillEditVC *vc = [WaybillEditVC new];
    if (self.detailData) {
        vc.detailData = self.detailData;
    }
    else {
        vc.detailData = [AppWayBillDetailInfo mj_objectWithKeyValues:[self.data mj_keyValues]];
    }
    QKWEAKSELF;
    vc.doneBlock = ^(NSObject *object){
        if ([object isKindOfClass:[AppWayBillDetailInfo class]]) {
            weakself.detailData = (AppWayBillDetailInfo *)object;
            [weakself updateSubviews];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pullWaybillDetailData {
    NSDictionary *m_dic = @{@"waybill_id" : self.data.waybill_id};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_queryWaybillByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = (ResponseItem *)responseBody;
            if (item.items.count) {
                weakself.detailData = [AppWayBillDetailInfo mj_objectWithKeyValues:item.items[0]];
            }
            [weakself updateSubviews];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)updateTableViewHeader {
    QKWEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself pullWaybillDetailData];
    }];
}

- (void)endRefreshing {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)updateSubviews {
    [self.tableView reloadData];
    self.headerView.data = [self.detailData copy];
}

#pragma mark - getter
- (WayBillDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [WayBillDetailHeaderView new];
    }
    return _headerView;
}

- (PublicMutableButtonView *)footerView {
    if (!_footerView) {
        _footerView = [[PublicMutableButtonView alloc] initWithFrame:CGRectMake(0, 0, screen_width, DEFAULT_BAR_HEIGHT)];
        _footerView.defaultWidthScale = 1.0 / 4;
        [_footerView updateDataSourceWithArray:@[@"作废", @"打印", @"修改记录", @"物流跟踪"]];
        for (UIButton *btn in _footerView.showViews) {
            btn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
            if ([_footerView.showViews indexOfObject:btn] == 0) {
                btn.backgroundColor = EmphasizedColor;
                [btn setTitleColor:WarningColor forState:UIControlStateNormal];
            }
            else {
                btn.backgroundColor = MainColor;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    return _footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView wayBillTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    UITableViewCell *cell = [super tableView:tableView wayBillTitleCellForRowAtIndexPath:indexPath showObject:showObject reuseIdentifier:reuseIdentifier];
    if (indexPath.section == 2) {
        self.totalAmountLabel.text = [NSString stringWithFormat:@"总运费：%@", self.detailData.total_amount];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView singleInputCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    SingleInputCell *cell = (SingleInputCell *)[super tableView:tableView singleInputCellForRowAtIndexPath:indexPath showObject:showObject reuseIdentifier:reuseIdentifier];
    cell.baseView.textField.enabled = NO;
    NSString *key = showObject[@"key"];
    if ([self.selectorSet containsObject:key]) {
        cell.baseView.textField.text = [UserPublic stringForType:[[self.detailData valueForKey:key] integerValue] key:key];
    }
    else if ([self.switchorSet containsObject:key]) {
        cell.baseView.textField.text = isTrue([self.detailData valueForKey:key]) ? @"是" : @"否";
    }
    else {
        NSString *value = [self.detailData valueForKey:key];
        if (value) {
            cell.baseView.textField.text = value;
        }
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView doubleInputCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    NSArray *m_array = showObject;
    DoubleInputCell *cell = (DoubleInputCell *)[super tableView:tableView doubleInputCellForRowAtIndexPath:indexPath showObject:showObject reuseIdentifier:reuseIdentifier];
    cell.baseView.textField.enabled = NO;
    cell.anotherBaseView.textField.enabled = NO;
    NSDictionary *m_dic1 = m_array[0];
    NSDictionary *m_dic2 = m_array[1];
    NSString *key1 = m_dic1[@"key"];
    NSString *value1 = [self.detailData valueForKey:key1];
    if (value1) {
        cell.baseView.textField.text = value1;
    }
    NSString *key2 = m_dic2[@"key"];
    NSString *value2 = [self.detailData valueForKey:key2];
    if (value2) {
        cell.anotherBaseView.textField.text = value2;
    }
    
    return cell;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rows = 0;
    switch (section) {
        case 0:{
            rows = 1 + 1 + self.detailData.waybill_items.count;
        }
            break;
            
        case 1:{
            rows = 1 + self.feeShowArray.count;
        }
            break;
            
        case 2:{
            rows = 1 + self.payStyleShowArray.count;
        }
            break;
            
        default:
            break;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = kCellHeightFilter;
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                
            }
            else if (self.detailData.waybill_items.count == 0) {
                rowHeight = 114.0;
            }
            else if (indexPath.row == self.detailData.waybill_items.count + 1) {
                rowHeight = [GoodsSummaryCell tableView:tableView heightForRowAtIndexPath:indexPath];
            }
            else {
                rowHeight = [FourItemsDoubleListCell tableView:tableView heightForRowAtIndexPath:indexPath];
            }
        }
            break;
            
        case 1:{
            if (indexPath.row == 0) {
                
            }
            else if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
                rowHeight += kEdge;
            }
            else {
                
            }
        }
            break;
            
        case 2:{
            if (indexPath.row == 0) {
                
            }
            else if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
                rowHeight += kEdge;
            }
            else {
                
            }
        }
            break;
            
        default:
            break;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"goods_title_cell";
                return [self tableView:tableView wayBillTitleCellForRowAtIndexPath:indexPath showObject:@"货物信息" reuseIdentifier:CellIdentifier];
            }
            else if (self.detailData.waybill_items.count == 0) {
                static NSString *CellIdentifier = @"no_goods_cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.textColor = secondaryTextColor;
                    cell.textLabel.font = [AppPublic appFontOfSize:appLabelFontSize];
                }
                
                cell.textLabel.text = @"没有货物";
                
                return cell;
            }
            else if (indexPath.row == self.detailData.waybill_items.count + 1) {
                static NSString *CellIdentifier = @"goods_summary_cell";
                GoodsSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell) {
                    cell = [[GoodsSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
                    
                    self.summaryFreightTextField = (IndexPathTextField *)cell.showArray[1];
                    self.summaryFreightTextField.enabled = NO;
                }
                
                [cell addShowContents:@[@"运费：",
                                        [NSString stringWithFormat:@"%@", self.detailData.freight],
                                        @"总数：",
                                        [NSString stringWithFormat:@"%@/%@/%@", self.detailData.goods_total_count, self.detailData.goods_total_weight, self.detailData.goods_total_volume]]];
                
                return cell;
            }
            else {
                static NSString *CellIdentifier = @"goods_item_cell";
                FourItemsDoubleListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell) {
                    cell = [[FourItemsDoubleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
                    cell.backgroundColor = [UIColor whiteColor];
                }
                
                AppWaybillItemInfo *item = self.detailData.waybill_items[indexPath.row - 1];
                [cell addShowContents:@[[NSString stringWithFormat:@"品名%@", indexChineseString(indexPath.row)],
                                        notNilString(item.waybill_item_name),
                                        @"包装",
                                        notNilString(item.packge),
                                        @"件/吨/方",
                                        [NSString stringWithFormat:@"%@/%@/%@", item.number, item.weight, item.volume],
                                        @"运费",
                                        [NSString stringWithFormat:@"%@", item.freight]]];
                
                return cell;
            }
        }
            break;
            
        case 1:{
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"fee_title_cell";
                return [self tableView:tableView wayBillTitleCellForRowAtIndexPath:indexPath showObject:@"费用信息" reuseIdentifier:CellIdentifier];
            }
            else {
                id object = self.feeShowArray[indexPath.row - 1];
                if ([object isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *m_dic = object;
                    static NSString *CellIdentifier = @"fee_edit_cell";
                    return [self tableView:tableView singleInputCellForRowAtIndexPath:indexPath showObject:m_dic reuseIdentifier:CellIdentifier];
                }
                else if ([object isKindOfClass:[NSArray class]]){
                    NSArray *m_array = (NSArray *)object;
                    if (m_array.count == 2) {
                        static NSString *CellIdentifier = @"double_cell";
                        return [self tableView:tableView doubleInputCellForRowAtIndexPath:indexPath showObject:m_array reuseIdentifier:CellIdentifier];
                    }
                }
            }
        }
            break;

        case 2:{
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"pay_sytle_title_cell";
                return [self tableView:tableView wayBillTitleCellForRowAtIndexPath:indexPath showObject:@"结算方式" reuseIdentifier:CellIdentifier];
            }
            else {
                id object = self.payStyleShowArray[indexPath.row - 1];
                if ([object isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *m_dic = object;
                    static NSString *CellIdentifier = @"pay_style_edit_cell";
                    return [self tableView:tableView singleInputCellForRowAtIndexPath:indexPath showObject:m_dic reuseIdentifier:CellIdentifier];
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    return [UITableViewCell new];
}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicMutableButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        int tag = [m_dic[@"tag"] intValue];
        switch (tag) {
            case 0:{
                
            }
                break;
                
            case 1:{
                
            }
                break;
                
            case 2:{
                WaybillChangeListVC *vc = [WaybillChangeListVC new];
                vc.detailData = [self.detailData copy];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case 3:{
                WaybillLogVC *vc = [WaybillLogVC new];
                vc.detailData = [self.detailData copy];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
