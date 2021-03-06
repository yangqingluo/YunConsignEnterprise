//
//  SearchQuantityResultTableVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SearchQuantityResultTableVC.h"
#import "ServiceGoodsDetailVC.h"
#import "PublicSaveTransportTruckVC.h"
#import "ServiceTownGoodsQuantityVC.h"

#import "PublicMutableLabelView.h"
#import "SearchQuantityResultCell.h"
#import "PublicFooterSummaryView.h"

@interface SearchQuantityResultTableVC ()

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;

@end

@implementation SearchQuantityResultTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.footerView.bottom = self.view.height;
    [self.view addSubview:self.footerView];
    self.footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    self.tableView.top = 0;
    self.tableView.height = self.footerView.top - self.tableView.top;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.tableHeaderView = self.headerView;
    [self updateTableViewHeader];
}

- (void)pullBaseListData:(BOOL)isReset {
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

//- (void)cellActionBtnAction:(UIButton *)button {
//    if (self.indextag == 0) {
//        PublicSaveTransportTruckVC *vc = [PublicSaveTransportTruckVC new];
//        [[UserPublic getInstance].mainTabNav pushViewController:vc animated:YES];
//    }
//    else if (self.indextag == 1) {
//        ServiceGoodsDetailVC *vc = [ServiceGoodsDetailVC new];
//        vc.condition = [self.condition copy];
//        vc.serviceQuantityData = self.dataSource[button.tag];
//        [[UserPublic getInstance].mainTabNav pushViewController:vc animated:YES];
//    }
//}

- (void)cellSecondLabelAction:(UIGestureRecognizer *)gesture {
    UILabel *label = (UILabel *)gesture.view;
    if (self.indextag == 1) {
        ServiceGoodsDetailVC *vc = [ServiceGoodsDetailVC new];
        vc.condition = [self.condition copy];
        vc.serviceQuantityData = self.dataSource[label.tag];
        vc.title = [NSString stringWithFormat:@"%@-货量明细", vc.serviceQuantityData.service_name];
        [self doPushViewController:vc animated:YES];
    }
}

- (void)cellThirdLabelAction:(UIGestureRecognizer *)gesture {
    UILabel *label = (UILabel *)gesture.view;
    if (self.indextag == 1) {
        ServiceGoodsDetailVC *vc = [ServiceGoodsDetailVC new];
        vc.condition = [self.condition copy];
        vc.serviceQuantityData = self.dataSource[label.tag];
        vc.title = [NSString stringWithFormat:@"%@-剩货明细", vc.serviceQuantityData.service_name];
        vc.searchType = @"2";
        [self doPushViewController:vc animated:YES];
    }
}

- (void)updateSubviews {
    int quantity = 0;
    int remain = 0;
    for (AppGoodsQuantityInfo *item in self.dataSource) {
        quantity += [item.quantity intValue];
        remain += [item.remain intValue];
    }
    ((PublicFooterSummaryView *)self.footerView).textLabel.text = [NSString stringWithFormat:@"总货量：%d，总剩货：%d", quantity, remain];
    self.tableView.tableHeaderView = self.dataSource.count ? self.headerView : nil;
    [self.tableView reloadData];
}

#pragma mark - getter
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

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[PublicFooterSummaryView alloc] initWithFrame:CGRectMake(0, 0, screen_width, DEFAULT_BAR_HEIGHT)];
        _footerView.backgroundColor = [UIColor clearColor];

    }
    return _footerView;
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
            [m_view updateDataSourceWithArray:@[self.indextag == 0 ? @"线路" : @"门店", @"货量", @"剩货"]];
            [cell.contentView addSubview:m_view];
        }
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"goods_list_cell";
        SearchQuantityResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[SearchQuantityResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            if (self.indextag == 1) {
                cell.secondLabel.textColor = MainColor;
                cell.thirdLabel.textColor = MainColor;
                
                UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSecondLabelAction:)];
                [cell.secondLabel addGestureRecognizer:tap2];
                cell.secondLabel.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellThirdLabelAction:)];
                [cell.thirdLabel addGestureRecognizer:tap3];
                cell.thirdLabel.userInteractionEnabled = YES;
            }
//            [cell.actionBtn addTarget:self action:@selector(cellActionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.data = self.dataSource[indexPath.row - 1];
        cell.secondLabel.tag = indexPath.row - 1;
        cell.thirdLabel.tag = indexPath.row - 1;
//        cell.actionBtn.tag = indexPath.row - 1;
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.indextag == 0) {
        if (indexPath.row > 0) {
            ServiceTownGoodsQuantityVC *vc = [ServiceTownGoodsQuantityVC new];
            vc.routeGoodsData = self.dataSource[indexPath.row - 1];
            vc.condition = self.condition;
            [self doPushViewController:vc animated:YES];
        }
    }
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
