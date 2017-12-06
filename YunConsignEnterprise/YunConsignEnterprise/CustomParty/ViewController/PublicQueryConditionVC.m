//
//  PublicQueryConditionVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicQueryConditionVC.h"
#import "PublicSelectionVC.h"

@interface PublicQueryConditionVC ()<UITextFieldDelegate>

@end

@implementation PublicQueryConditionVC

//- (void)showFromVC:(AppBasicViewController *)fromVC {
//    [fromVC.navigationController pushViewController:self animated:YES];
//    //    MainTabNavController *nav = [[MainTabNavController alloc] initWithRootViewController:self];
//    //    [fromVC presentViewController:nav animated:NO completion:^{
//    //
//    //    }];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.tableView.tableFooterView = self.footerView;
    
    [self initializeData];
}

- (void)setupNav {
    [self createNavWithTitle:self.title ? self.title : @"查询" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
}

//初始化数据
- (void)initializeData {
    switch (self.type) {
        case QueryConditionType_WaybillQuery:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                           @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"},
                           @{@"title":@"显示作废",@"subTitle":@"请选择",@"key":@"is_cancel"}];
//            self.condition.start_time = [self.condition.end_time dateByAddingTimeInterval:-2 * defaultDayTimeInterval];
            [self additionalDataDictionaryForCode:@"query_column"];
        }
            break;
            
        case QueryConditionType_TransportTruck:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"起点城市",@"subTitle":@"请选择",@"key":@"start_station_city"},
                           @{@"title":@"终点网点",@"subTitle":@"请选择",@"key":@"end_service"},
                           @{@"title":@"车辆牌照",@"subTitle":@"请输入",@"key":@"truck_number_plate"}];
        }
            break;
            
        case QueryConditionType_WaybillLoad:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"终点城市",@"subTitle":@"请选择",@"key":@"end_station_city"},
                           @{@"title":@"车辆状态",@"subTitle":@"请选择",@"key":@"transport_truck_state"},
                           @{@"title":@"车辆牌照",@"subTitle":@"请输入",@"key":@"truck_number_plate"}];
        }
            break;
            
        case QueryConditionType_WaybillLoadTT:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                           @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
            [self additionalDataDictionaryForCode:@"query_column"];
        }
            break;
            
        case QueryConditionType_WaybillLoaded:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"终点城市",@"subTitle":@"请选择",@"key":@"end_station_city"},
                           @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                           @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
            [self additionalDataDictionaryForCode:@"query_column"];
        }
            break;
            
        case QueryConditionType_WaybillArrival:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"始发城市",@"subTitle":@"请选择",@"key":@"start_station_city"},
                           @{@"title":@"车辆状态",@"subTitle":@"请选择",@"key":@"transport_truck_state"},
                           @{@"title":@"车辆牌照",@"subTitle":@"请输入",@"key":@"truck_number_plate"}];
        }
            break;
            
        case QueryConditionType_WaybillArrivalDetail:{
            self.showArray = @[@{@"title":@"装车网点",@"subTitle":@"必填，请选择",@"key":@"load_service"},
                           @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                           @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
            [self additionalDataDictionaryForCode:@"query_column"];
        }
            break;
            
        case QueryConditionType_WaybillReceive:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"开单网点",@"subTitle":@"请选择",@"key":@"start_service"},
                           @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                           @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
//            self.condition.start_time = [self.condition.end_time dateByAddingTimeInterval:-2 * defaultDayTimeInterval];
            [self additionalDataDictionaryForCode:@"query_column"];
        }
            break;
            
        case QueryConditionType_PayOnReceipt:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                           @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
//            self.condition.start_time = [self.condition.end_time dateByAddingTimeInterval:-2 * defaultDayTimeInterval];
            [self additionalDataDictionaryForCode:@"query_column"];
        }
            break;
            
        case QueryConditionType_CustomerManage:{
            self.showArray = @[@{@"title":@"客户姓名",@"subTitle":@"请输入",@"key":@"freight_cust_name"},
                           @{@"title":@"客户电话",@"subTitle":@"请输入",@"key":@"phone"}];
        }
            break;
            
        case QueryConditionType_CodLoanApply:{
            self.title = @"放款申请查询";
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"客户姓名",@"subTitle":@"请输入",@"key":@"bank_card_owner"},
                           @{@"title":@"客户电话",@"subTitle":@"请输入",@"key":@"contact_phone"},
                           @{@"title":@"审核状态",@"subTitle":@"请选择",@"key":@"loan_apply_state"}];
//            self.condition.start_time = [self.condition.end_time dateByAddingTimeInterval:-3 * defaultDayTimeInterval];
            [self additionalDataDictionaryForCode:@"loan_apply_state"];
        }
            break;
            
        case QueryConditionType_CodLoanCheck:{
            self.title = @"放款审核查询";
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"客户姓名",@"subTitle":@"请输入",@"key":@"bank_card_owner"},
                           @{@"title":@"客户电话",@"subTitle":@"请输入",@"key":@"contact_phone"}];
        }
            break;
            
        case QueryConditionType_CodRemit:{
            self.title = @"放款查询";
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                               @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                               @{@"title":@"客户姓名",@"subTitle":@"请输入",@"key":@"bank_card_owner"},
                               @{@"title":@"客户电话",@"subTitle":@"请输入",@"key":@"contact_phone"}];
//            self.condition.start_time = [self.condition.end_time dateByAddingTimeInterval:-2 * defaultDayTimeInterval];
        }
            break;
            
        case QueryConditionType_DailyReimbursementApply:{
            self.title = @"报销查询";
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"报销科目",@"subTitle":@"请选择",@"key":@"daily_name"}];
        }
            break;
            
        case QueryConditionType_DailyReimbursementCheck:{
            self.title = @"报销查询";
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"报销科目",@"subTitle":@"请选择",@"key":@"daily_name"},
                           @{@"title":@"报销网点",@"subTitle":@"请选择",@"key":@"reimbursement_service"}];
        }
            break;
            
        case QueryConditionType_Service:{
            self.showArray = @[@{@"title":@"所属城市",@"subTitle":@"请选择",@"key":@"open_city"},
                               @{@"title":@"门店状态",@"subTitle":@"请选择",@"key":@"service_state"},
                               @{@"title":@"门店名称",@"subTitle":@"请输入",@"key":@"service_name"},
                               @{@"title":@"门店代码",@"subTitle":@"请输入",@"key":@"service_code"}];
        }
            break;
            
        case QueryConditionType_JsonUser:{
            self.showArray = @[@{@"title":@"姓名",@"subTitle":@"请输入",@"key":@"user_name"},
                               @{@"title":@"电话",@"subTitle":@"请输入",@"key":@"telphone"},
                               @{@"title":@"岗位编号",@"subTitle":@"请选择",@"key":@"user_role"}];
            [self.inputValidSet addObjectsFromArray:@[@"user_name", @"telphone"]];
        }
            break;
            
        case QueryConditionType_TruckManage:{
            self.showArray = @[@{@"title":@"车牌号",@"subTitle":@"请输入",@"key":@"truck_number_plate"},
                               @{@"title":@"司机姓名",@"subTitle":@"请输入",@"key":@"truck_driver_name"},
                               @{@"title":@"司机电话",@"subTitle":@"请输入",@"key":@"truck_driver_phone"}];
            [self.inputValidSet addObjectsFromArray:@[@"truck_number_plate", @"truck_driver_name", @"truck_driver_phone"]];
        }
            break;
            
        default:
            break;
    }
}

- (void)checkDataMapExistedForCode:(NSString *)key {
    NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
    if (dataArray.count) {
        if (![self.condition valueForKey:key] && [self.toCheckDataMapSet containsObject:key]) {
            [self.condition setValue:dataArray[0] forKey:key];
            [self.tableView reloadData];
        }
    }
    else {
        [self pullDataDictionaryFunctionForCode:key selectionInIndexPath:nil];
    }
}

- (void)searchButtonAction {
    [self goBackWithDone:YES];
}

- (void)doDoneAction {
    if (self.doneBlock) {
        self.doneBlock(self.condition);
    }
}

- (void)editAtIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag andContent:(NSString *)content {
    NSDictionary *m_dic = self.showArray[indexPath.row];
    [self.condition setValue:content forKey:m_dic[@"key"]];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    Class varClass = [AppPublic getVariableClassWithClass:self.condition.class varName:key];
    if ([varClass isSubclassOfClass:[NSDate class]]) {
        QKWEAKSELF;
        PublicDatePickerView *view = [[PublicDatePickerView alloc] initWithStyle:PublicDatePicker_Date andTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] callBlock:^(PublicDatePickerView *pickerView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakself.condition setValue:pickerView.datePicker.date forKey:key];
                [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
        view.datePicker.maximumDate = [NSDate date];
        id value = [self.condition valueForKey:key];
        if (value) {
            view.datePicker.date = value;
        }
        if ([key isEqualToString:@"start_time"]) {
            id end_time = [self.condition valueForKey:@"end_time"];
            if (end_time) {
                view.datePicker.maximumDate = end_time;
            }
        }
        [view show];
    }
    else if ([varClass isSubclassOfClass:[AppDataDictionary class]]) {
        NSString *m_key = nil;
        if ([key isEqualToString:@"cash_on_delivery_type"]) {
            m_key = @"cash_on_delivery_state_show";
        }
        NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:m_key.length ? m_key : key];
        if (dicArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dicArray.count];
            for (AppDataDictionary *m_data in dicArray) {
                [m_array addObject:m_data.item_name];
            }
            QKWEAKSELF;
            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                if (buttonIndex > 0 && (buttonIndex - 1) < dicArray.count) {
                    [weakself.condition setValue:dicArray[buttonIndex - 1] forKey:key];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            } otherButtonTitlesArray:m_array];
            [sheet showInView:self.view];
        }
        else {
            [self pullDataDictionaryFunctionForCode:m_key.length ? m_key : key selectionInIndexPath:indexPath];
        }
    }
    else if ([varClass isSubclassOfClass:[NSArray class]]) {
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
        if (dataArray.count) {
            NSMutableArray *source_array = [NSMutableArray new];
            NSMutableArray *selected_array = [NSMutableArray new];
            for (NSUInteger i = 0; i < dataArray.count; i++) {
                AppDataDictionary *item = dataArray[i];
                [source_array addObject:item.item_name];
                if ([[self.condition valueForKey:key] containsObject:item]) {
                    [selected_array addObject:@(i)];
                }
            }
            QKWEAKSELF;
            PublicSelectionVC *vc = [[PublicSelectionVC alloc] initWithDataSource:source_array selectedArray:selected_array maxSelectCount:dataArray.count back:^(NSObject *object){
                if ([object isKindOfClass:[NSArray class]]) {
                    NSMutableArray *m_array = [NSMutableArray new];
                    for (NSNumber *number in (NSArray *)object) {
                        NSInteger index = [number integerValue];
                        if (index < dataArray.count && index >= 0) {
                            [m_array addObject:dataArray[index]];
                        }
                    }
                    [weakself.condition setValue:[NSArray arrayWithArray:m_array] forKey:key];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            vc.title = [NSString stringWithFormat:@"选择%@", m_dic[@"title"]];
            [self doPushViewController:vc animated:YES];
        }
        else {
            [self pullDataDictionaryFunctionForCode:key selectionInIndexPath:indexPath];
        }
    }
    else if ([varClass isSubclassOfClass:[AppServiceInfo class]]) {
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:[key isEqualToString:@"load_service"] ? serviceDataMapKeyForTruck(self.condition.transport_truck_id) : key];
        if (dataArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dataArray.count];
            for (AppServiceInfo *m_data in dataArray) {
                [m_array addObject:m_data.showCityAndServiceName];
            }
            QKWEAKSELF;
            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                if (buttonIndex > 0 && (buttonIndex - 1) < dataArray.count) {
                    [weakself.condition setValue:dataArray[buttonIndex - 1] forKey:key];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            } otherButtonTitlesArray:m_array];
            [sheet showInView:self.view];
        }
        else {
            if ([key isEqualToString:@"load_service"]) {
                [self pullLoadServiceArrayFunctionForTransportTruckID:self.condition.transport_truck_id selectionInIndexPath:indexPath];
            }
            else {
                [self pullServiceArrayFunctionForCode:key selectionInIndexPath:indexPath];
            }
        }
    }
    else if ([varClass isSubclassOfClass:[AppCityInfo class]]) {
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
        if (dataArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dataArray.count];
            for (AppCityInfo *m_data in dataArray) {
                [m_array addObject:m_data.open_city_name];
            }
            QKWEAKSELF;
            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                if (buttonIndex > 0 && (buttonIndex - 1) < dataArray.count) {
                    [weakself.condition setValue:dataArray[buttonIndex - 1] forKey:key];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            } otherButtonTitlesArray:m_array];
            [sheet showInView:self.view];
        }
        else {
            [self pullCityArrayFunctionForCode:key selectionInIndexPath:indexPath];
        }
    }
    else if ([self.boolValidSet containsObject:key]) {
        NSArray *m_array = @[@"是", @"否"];
        QKWEAKSELF;
        BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
            if (buttonIndex > 0) {
                [weakself.condition setValue:buttonIndex == 1 ? @"1" : @"2" forKey:key];
                [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        } otherButtonTitlesArray:m_array];
        [sheet showInView:self.view];
    }
}

#pragma mark - getter
- (AppQueryConditionInfo *)condition {
    if (!_condition) {
        _condition = [AppQueryConditionInfo new];
    }
    return _condition;
}

- (NSMutableSet *)inputValidSet {
    if (!_inputValidSet) {
        _inputValidSet = [NSMutableSet setWithObjects:@"query_val", @"truck_number_plate", @"bank_card_owner", @"contact_phone", @"daily_fee", @"note", @"freight_cust_name", @"phone", @"service_name", @"service_code", nil];
    }
    return _inputValidSet;
}

- (NSSet *)numberInputSet {
    if (!_numberInputSet) {
        _numberInputSet = [NSSet setWithObjects:@"daily_fee", @"phone", nil];
    }
    return _numberInputSet;
}

- (NSSet *)boolValidSet {
    if (!_boolValidSet) {
        _boolValidSet = [NSSet setWithObjects:@"is_cancel", @"waybill_receive_state", nil];
    }
    return _boolValidSet;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 48 + 2 * kEdgeMiddle)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kEdge, kEdgeMiddle, _footerView.width - 2 * kEdge, _footerView.height - 2 * kEdgeMiddle)];
        btn.backgroundColor = MainColor;
        btn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
        [btn setTitle:@"立即查询" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        
        [AppPublic roundCornerRadius:btn cornerRadius:kButtonCornerRadius];
    }
    return _footerView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = kCellHeightFilter;
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
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
    NSDictionary *dic = self.showArray[indexPath.row];
    NSString *key = dic[@"key"];
    
    static NSString *CellIdentifier = @"select_cell";
    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
        cell.baseView.textField.delegate = self;
    }
    cell.baseView.textLabel.text = dic[@"title"];
    cell.baseView.textField.placeholder = dic[@"subTitle"];
    cell.baseView.textField.text = @"";
    cell.baseView.textField.indexPath = [indexPath copy];
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    cell.accessoryType = [self.inputValidSet containsObject:key] ? UITableViewCellAccessoryNone:
    UITableViewCellAccessoryDisclosureIndicator;
    cell.baseView.textField.enabled = [self.inputValidSet containsObject:key];
    cell.baseView.textField.keyboardType = [self.numberInputSet containsObject:key] ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
    if ([[self.condition valueForKey:key] isKindOfClass:[AppDataDictionary class]]) {
        cell.baseView.textField.text = [[self.condition valueForKey:key] valueForKey:@"item_name"];
    }
    else if ([[self.condition valueForKey:key] isKindOfClass:[NSArray class]]) {
        cell.baseView.textField.text = [self.condition showArrayNameStringWithKey:key];
    }
    else if ([[self.condition valueForKey:key] isKindOfClass:[AppServiceInfo class]]) {
        cell.baseView.textField.text = [[self.condition valueForKey:key] valueForKey:@"service_name"];
    }
    else if ([[self.condition valueForKey:key] isKindOfClass:[AppCityInfo class]]) {
        cell.baseView.textField.text = [[self.condition valueForKey:key] valueForKey:@"open_city_name"];
    }
    else if ([[self.condition valueForKey:key] isKindOfClass:[AppWayBillDetailInfo class]]) {
        cell.baseView.textField.text = [[self.condition valueForKey:key] valueForKey:@"goods_number"];
    }
    else {
        if ([AppPublic getVariableWithClass:self.condition.class varName:key]) {
            id value = [self.condition valueForKey:key];
            if (value) {
                if ([self.boolValidSet containsObject:key]) {
                    cell.baseView.textField.text = isTrue(value) ? @"是" : @"否";
                }
                else if ([key isEqualToString:@"start_time"] || [key isEqualToString:@"end_time"]) {
                    cell.baseView.textField.text = stringFromDate(value, @"yyyy-MM-dd");
                }
                else {
                    cell.baseView.textField.text = value;
                }
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self selectRowAtIndexPath:indexPath];
}

@end
