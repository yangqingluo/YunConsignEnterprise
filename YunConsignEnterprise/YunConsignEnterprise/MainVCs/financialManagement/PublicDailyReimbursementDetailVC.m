//
//  PublicDailyReimbursementDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/8.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicDailyReimbursementDetailVC.h"
#import "LLImagePickerView.h"

@interface PublicDailyReimbursementDetailVC ()

@property (strong, nonatomic) LLImagePickerView *imagePickerView;

@end

@implementation PublicDailyReimbursementDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.showData = [AppDailyReimbursementApplyInfo mj_objectWithKeyValues:self.applyData.mj_keyValues];
    if ([self.applyData.daily_apply_state integerValue] == 1) {
        self.showArray = @[@[@{@"title":@"报销科目",@"subTitle":@"无",@"key":@"daily_name"},
                             @{@"title":@"报销金额",@"subTitle":@"0",@"key":@"daily_fee"},
                             @{@"title":@"报销门店",@"subTitle":@"无",@"key":@"service_name"},
                             @{@"title":@"关联运单",@"subTitle":@"无",@"key":@"waybill_info"},
                             @{@"title":@"报销备注",@"subTitle":@"无",@"key":@"note"},
                             @{@"title":@"报销凭证",@"subTitle":@"无",@"key":@"voucher"}]];
    }
    else {
        self.showArray = @[@[@{@"title":@"报销科目",@"subTitle":@"",@"key":@"daily_name"},
                             @{@"title":@"报销金额",@"subTitle":@"0",@"key":@"daily_fee"},
                             @{@"title":@"报销门店",@"subTitle":@"",@"key":@"service_name"},
                             @{@"title":@"关联运单",@"subTitle":@"",@"key":@"waybill_info"},
                             @{@"title":@"报销备注",@"subTitle":@"无",@"key":@"note"},
                             @{@"title":@"报销凭证",@"subTitle":@"无",@"key":@"voucher"}],
                           @[@{@"title":@"审核结果",@"subTitle":@"",@"key":@"daily_apply_state_text"},
                             @{@"title":@"审核人",@"subTitle":@"",@"key":@"check_name"},
                             @{@"title":@"审核时间",@"subTitle":@"无",@"key":@"check_time"},
                             @{@"title":@"原因",@"subTitle":@"无",@"key":@"check_note"}]];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"报销申请详情" createMenuItem:^UIView *(int nIndex){
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
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"daily_apply_id" : self.applyData.daily_apply_id}];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_reimburse_queryDailyReimburseByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = (ResponseItem *)responseBody;
            if (item.items.count) {
                weakself.showData = [AppDailyReimbursementApplyInfo mj_objectWithKeyValues:item.items[0]];
            }
            [weakself updateSubviews];
        }
        else {
            [weakself doShowHintFunction:error.userInfo[@"message"]];
        }
    }];
}

#pragma mark - getter
- (LLImagePickerView *)imagePickerView {
    if (!_imagePickerView) {
        _imagePickerView = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(0, 0, kCellHeightBig * 3, 0) CountOfRow:3];
        _imagePickerView.backgroundColor = [UIColor clearColor];
        _imagePickerView.showDelete = NO;
        _imagePickerView.showAddButton = NO;
    }
    return _imagePickerView;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.showArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = kCellHeightFilter;
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        if (indexPath.section == 0) {
            rowHeight = kCellHeightBig;
        }
        rowHeight += kEdge;
    }
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *m_array = self.showArray[indexPath.section];
    NSDictionary *m_dic = m_array[indexPath.row];
    NSString *key = m_dic[@"key"];
    
    if ([key isEqualToString:@"voucher"]) {
        NSString *CellIdentifier = @"voucher_cell";
        SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
            cell.baseView.textField.enabled = NO;
            self.imagePickerView.right = cell.baseView.width;
            [cell.baseView addSubview:self.imagePickerView];
        }
        cell.baseView.textLabel.text = m_dic[@"title"];
        cell.baseView.textField.placeholder = m_dic[@"subTitle"];
        cell.baseView.textField.text = @"";
        cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
        self.imagePickerView.preShowMedias = [[self.showData valueForKey:key] componentsSeparatedByString:@","];
        return cell;
    }
    
    NSString *CellIdentifier = @"PublicDailyReimbursementDetail_cell";
    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
        cell.baseView.textField.enabled = NO;
    }
    cell.baseView.textLabel.text = m_dic[@"title"];
    cell.baseView.textField.placeholder = m_dic[@"subTitle"];
    cell.baseView.textField.text = @"";
    cell.baseView.textField.indexPath = [indexPath copy];
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    if ([[self.showData valueForKey:key] isKindOfClass:[AppDataDictionary class]]) {
        cell.baseView.textField.text = [[self.showData valueForKey:key] valueForKey:@"item_name"];
    }
    else if ([key isEqualToString:@"start_service"] || [key isEqualToString:@"end_service"] || [key isEqualToString:@"power_service"] || [key isEqualToString:@"load_service"]) {
        cell.baseView.textField.text = [[self.showData valueForKey:key] valueForKey:@"showCityAndServiceName"];
    }
    else if ([key isEqualToString:@"start_station_city"] || [key isEqualToString:@"end_station_city"]) {
        cell.baseView.textField.text = [[self.showData valueForKey:key] valueForKey:@"open_city_name"];
    }
    else {
        id value = [self.showData valueForKey:key];
        cell.baseView.textField.text = value;
    }
    
    return cell;
}

@end
