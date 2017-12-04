//
//  WaybillLogTableVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/23.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillLogTableVC.h"

#import "MJRefresh.h"
#import "SingleInputCell.h"
#import "WaybillLogCell.h"
#import "LLImagePickerView.h"

@interface WaybillLogTableVC (){
    BOOL hasPulledData;
}

@property (assign, nonatomic) NSInteger indextag;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSString *dateKey;
@property (strong, nonatomic) UIView *pickerFooter;
@property (strong, nonatomic) LLImagePickerView *imagePickerView;

@end

@implementation WaybillLogTableVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewStyle)style andIndexTag:(NSInteger)index{
    self = [super initWithStyle:style];
    if (self) {
        self.indextag = index;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waybillLogNotification:) name:kNotification_WaybillLogRefresh object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
}

- (void)becomeListed{
    NSDate *lastRefreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
    if (!self.dataSource.count || !lastRefreshTime || [lastRefreshTime timeIntervalSinceNow] < -appRefreshTime) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)becomeUnListed{
    
}

- (void)loadFirstPageData{
    [self queryWaybillListByConditionFunction:YES];
}

- (void)loadMoreData{
    [self queryWaybillListByConditionFunction:NO];
}

- (void)queryWaybillListByConditionFunction:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_id" : self.detailData.waybill_id, @"start" : [NSString stringWithFormat:@"%d", isReset ? 0 : (int)self.dataSource.count], @"limit" : [NSString stringWithFormat:@"%d", appPageSize]}];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_queryWaybillLogByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            ResponseItem *item = responseBody;
            if (item.items.count) {
                NSDictionary *m_dic = item.items[0];
                [weakself pulledLogData:m_dic];
                hasPulledData = YES;
                [weakself postNotificationName:kNotification_WaybillLogRefresh object:m_dic];
            }
//            [weakself.dataSource addObjectsFromArray:[AppTransportTruckInfo mj_objectArrayWithKeyValuesArray:item.items]];
            
//            if (item.total <= weakself.dataSource.count) {
//                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//            else {
//                [weakself updateTableViewFooter];
//            }
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

- (void)updateTableViewFooter {
    QKWEAKSELF;
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakself loadMoreData];
        }];
    }
}

- (void)endRefreshing{
    //记录刷新时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.dateKey];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)pulledLogData:(NSDictionary *)dic {
    self.detailData.join_short_name = dic[@"join_name"];
    [self.dataSource removeAllObjects];
    switch (self.indextag) {
        case 0:{
            [self.dataSource addObjectsFromArray:[self sortArrayByTime:[AppWaybillLogInfo mj_objectArrayWithKeyValuesArray:dic[@"transport_log"]]]];
        }
            break;
            
        case 1:{
            [self.dataSource addObjectsFromArray:[self sortArrayByTime:[AppWaybillLogInfo mj_objectArrayWithKeyValuesArray:dic[@"cash_on_delivery_log"]]]];
        }
            break;
            
        case 2:{
            [self.dataSource addObjectsFromArray:[self sortArrayByTime:[AppWaybillLogInfo mj_objectArrayWithKeyValuesArray:dic[@"receipt_log"]]]];
        }
            break;
            
        case 3:{
//            [self.dataSource addObjectsFromArray:[self sortArrayByTime:[AppVoucherInfo mj_objectArrayWithKeyValuesArray:dic[@"voucher"]]]];
            self.tableView.tableFooterView = nil;
            [self.dataSource addObjectsFromArray:[AppVoucherInfo mj_objectArrayWithKeyValuesArray:dic[@"voucher"]]];
            if (self.dataSource.count) {
                NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:self.dataSource.count];
                for (AppVoucherInfo *item in self.dataSource) {
                    [m_array addObject:item.voucher];
                }
                self.imagePickerView.preShowMedias = [NSArray arrayWithArray:m_array];
                self.tableView.tableFooterView = self.pickerFooter;
            }
        }
            break;
            
        default:
            break;
    }
}

- (NSArray *)sortArrayByTime:(NSArray *)array {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"follow_time" ascending:NO];
    return [array sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (void)postNotificationName:(NSString *)name object:(id)anObject{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:anObject];
    });
}

#pragma mark - getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}


- (NSString *)dateKey{
    if (!_dateKey) {
        _dateKey = [NSString stringWithFormat:@"WaybillLog_dateKey_%d",(int)self.indextag];
    }
    return _dateKey;
}

- (UIView *)pickerFooter {
    if (!_pickerFooter) {
        _pickerFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, self.imagePickerView.height + 2 * kEdgeMiddle)];
        [_pickerFooter addSubview:self.imagePickerView];
    }
    return _pickerFooter;
}

- (LLImagePickerView *)imagePickerView {
    if (!_imagePickerView) {
        _imagePickerView = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(kEdgeMiddle, kEdgeMiddle, screen_width - 2 * kEdgeMiddle, 0) CountOfRow:3];
        _imagePickerView.backgroundColor = [UIColor clearColor];
        _imagePickerView.showDelete = NO;
        _imagePickerView.showAddButton = NO;
        _imagePickerView.maxImageSelected = 3;
    }
    return _imagePickerView;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indextag == 3 ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return self.dataSource.count;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return [WaybillLogCell tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return kEdge;
    }
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"way_bill_log_introduce_cell";
        SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.baseView.textField.enabled = NO;
            cell.baseView.textLabel.textColor = secondaryTextColor;
            cell.baseView.textLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
            cell.baseView.textField.textColor = secondaryTextColor;
            cell.baseView.textField.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
            [cell.baseView.lineView removeFromSuperview];
//            [cell.contentView addSubview:NewSeparatorLine(CGRectMake(0, 0, screen_width, appSeparaterLineSize))];
//            [cell.contentView addSubview:NewSeparatorLine(CGRectMake(0, [self tableView:tableView heightForRowAtIndexPath:indexPath] - appSeparaterLineSize, screen_width, appSeparaterLineSize))];
        }
        
        if (indexPath.row == 0) {
            cell.baseView.textLabel.text = [NSString stringWithFormat:@"运单号/货号：%@/%@", self.detailData.waybill_number, self.detailData.goods_number];
        }
        else {
            cell.baseView.textLabel.text = [NSString stringWithFormat:@"%@ %@->%@ %@", self.detailData.start_station_city_name, self.detailData.shipper_name, self.detailData.end_station_city_name, self.detailData.consignee_name];
            cell.baseView.textField.text = [NSString stringWithFormat:@"%@", self.detailData.join_short_name.length ? self.detailData.join_short_name : @""];
        }
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"way_bill_log_cell";
         WaybillLogCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[ WaybillLogCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
        }
        cell.data = self.dataSource[indexPath.row];
        cell.isShowTopEdge = indexPath.row == 0;
        cell.isShowBottomEdge = indexPath.row == self.dataSource.count - 1;
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
}

#pragma mark - notification
- (void)waybillLogNotification:(NSNotification *)notification {
    if (!hasPulledData) {
        [self pulledLogData:notification.object];
        //记录刷新时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.dateKey];
        hasPulledData = YES;
        [self.tableView reloadData];
    }
}

@end
