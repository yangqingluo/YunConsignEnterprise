//
//  PublicDailyReimbursementDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/8.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicDailyReimbursementDetailVC.h"
#import "PublicWaybillDetailVC.h"

#import "LLImagePickerView.h"

@interface PublicDailyReimbursementDetailVC ()

@property (strong, nonatomic) LLImagePickerView *imagePickerView;

@end

@implementation PublicDailyReimbursementDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];

    self.showData = [AppDailyReimbursementApplyInfo mj_objectWithKeyValues:self.applyData.mj_keyValues];
    if ([self.applyData.daily_apply_state integerValue] == LOAN_APPLY_STATE_1) {
        self.showArray = @[@[@{@"title":@"报销科目",@"subTitle":@"无",@"key":@"daily_name"},
                             @{@"title":@"报销金额",@"subTitle":@"请输入",@"key":@"daily_fee"},
                             @{@"title":@"报销门店",@"subTitle":@"无",@"key":@"service_name"},
                             @{@"title":@"关联运单",@"subTitle":@"无",@"key":@"waybill_info"},
                             @{@"title":@"报销备注",@"subTitle":@"无",@"key":@"note"},
                             @{@"title":@"报销凭证",@"subTitle":@"无",@"key":@"voucher"}]];
    }
    else {
        self.showArray = @[@[@{@"title":@"报销科目",@"subTitle":@"",@"key":@"daily_name"},
                             @{@"title":@"报销金额",@"subTitle":@"请输入",@"key":@"daily_fee"},
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
            CGFloat width  = cell.baseView.width - cell.baseView.textLabel.left - [AppPublic textSizeWithString:m_dic[@"title"] font:cell.baseView.textLabel.font constantHeight:cell.baseView.textLabel.height].width - 2 * kEdgeSmall;
            if (self.imagePickerView.width > width) {
                self.imagePickerView.width = width;
            }
            self.imagePickerView.right = cell.baseView.width;
            [cell.baseView addSubview:self.imagePickerView];
        }
        cell.baseView.textLabel.text = m_dic[@"title"];
        cell.baseView.textField.placeholder = m_dic[@"subTitle"];
        cell.baseView.textField.text = @"";
        cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
        NSString *voucher = [self.showData valueForKey:key];
        if (voucher.length) {
            self.imagePickerView.preShowMedias = [[self.showData valueForKey:key] componentsSeparatedByString:@","];
        }
        else {
            self.imagePickerView.preShowMedias = nil;
        }
        if (self.imagePickerView.preShowMedias.count) {
            cell.baseView.textField.placeholder = @"";
        }
        
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
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([[self.showData valueForKey:key] isKindOfClass:[AppDataDictionary class]]) {
        cell.baseView.textField.text = [[self.showData valueForKey:key] valueForKey:@"item_name"];
    }
    else if ([key isEqualToString:@"start_service"] || [key isEqualToString:@"end_service"] || [key isEqualToString:@"power_service"] || [key isEqualToString:@"load_service"]) {
        cell.baseView.textField.text = [[self.showData valueForKey:key] valueForKey:@"service_name"];
    }
    else if ([key isEqualToString:@"start_station_city"] || [key isEqualToString:@"end_station_city"]) {
        cell.baseView.textField.text = [[self.showData valueForKey:key] valueForKey:@"open_city_name"];
    }
    else if ([key isEqualToString:@"waybill_info"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.baseView.textField.text = [self.showData showWaybillInfoString];
    }
    else {
        id value = [self.showData valueForKey:key];
        cell.baseView.textField.text = value;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSArray *m_array = self.showArray[indexPath.section];
    NSDictionary *m_dic = m_array[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"waybill_info"]) {
        
        if (self.applyData.judgeWaybillInfoValidity) {
//            QueryWaybillReimburseListVC *vc = [QueryWaybillReimburseListVC new];
//            vc.applyData = self.applyData;
            PublicWaybillDetailVC *vc = [PublicWaybillDetailVC new];
            vc.type = WaybillDetailType_DailyReimbursementApply;
            
            AppWayBillInfo *m_data = [AppWayBillInfo new];
            m_data.waybill_id = [self.applyData.waybill_id copy];
//            NSArray *m_array = [self.applyData.waybill_info componentsSeparatedByString:@"/"];
//            if (m_array.count == 2) {
//                m_data.goods_number = m_array[0];
//                m_data.waybill_number = m_array[1];
//            }
            vc.data = m_data;
            [self doPushViewController:vc animated:YES];
        }
        else {
            [self doShowHintFunction:@"无关联运单"];
        }
    }
}

@end
