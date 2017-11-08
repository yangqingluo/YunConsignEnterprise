//
//  PublicQueryConditionVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicQueryConditionVC.h"

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
                           @{@"title":@"开单网点",@"subTitle":@"请选择",@"key":@"start_service"},
                           @{@"title":@"目的网点",@"subTitle":@"请选择",@"key":@"end_service"},
                           @{@"title":@"作废状态",@"subTitle":@"请选择",@"key":@"is_cancel"}];
            [self checkDataMapExistedFor:@"query_column"];
        }
            break;
            
        case QueryConditionType_TransportTruck:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"起点城市",@"subTitle":@"请选择",@"key":@"start_station_city"},
                           @{@"title":@"终点城市",@"subTitle":@"请选择",@"key":@"end_station_city"},
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
            [self checkDataMapExistedFor:@"query_column"];
        }
            break;
            
        case QueryConditionType_WaybillLoaded:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"终点城市",@"subTitle":@"请选择",@"key":@"end_station_city"},
                           @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                           @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
            [self checkDataMapExistedFor:@"query_column"];
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
            [self checkDataMapExistedFor:@"query_column"];
        }
            break;
            
        case QueryConditionType_WaybillReceive:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"开单网点",@"subTitle":@"请选择",@"key":@"start_service"},
                           @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                           @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
            [self checkDataMapExistedFor:@"query_column"];
        }
            break;
            
        case QueryConditionType_PayOnReceipt:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                           @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
            [self checkDataMapExistedFor:@"query_column"];
        }
            break;
            
        case QueryConditionType_CustomerManage:{
            self.showArray = @[@{@"title":@"客户姓名",@"subTitle":@"请输入",@"key":@"freight_cust_name"},
                           @{@"title":@"客户电话",@"subTitle":@"请输入",@"key":@"phone"}];
            [self checkDataMapExistedFor:@"query_column"];
        }
            break;
            
        case QueryConditionType_CodLoanApply:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"客户姓名",@"subTitle":@"请输入",@"key":@"bank_card_owner"},
                           @{@"title":@"客户电话",@"subTitle":@"请输入",@"key":@"contact_phone"},
                           @{@"title":@"审核状态",@"subTitle":@"请选择",@"key":@"loan_apply_state"}];
        }
            break;
            
        case QueryConditionType_CodLoanCheck:
        case QueryConditionType_CodRemit:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"客户姓名",@"subTitle":@"请输入",@"key":@"bank_card_owner"},
                           @{@"title":@"客户电话",@"subTitle":@"请输入",@"key":@"contact_phone"}];
        }
            break;
            
        case QueryConditionType_DailyReimbursementApply:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"报销科目",@"subTitle":@"请选择",@"key":@"daily_name"}];
        }
            break;
            
        case QueryConditionType_DailyReimbursementCheck:{
            self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"报销科目",@"subTitle":@"请选择",@"key":@"daily_name"}];
        }
            break;
            
        default:
            break;
    }
}

- (void)checkDataMapExistedFor:(NSString *)key {
    NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
    if (dataArray.count) {
        if (![self.condition valueForKey:key]) {
            [self.condition setValue:dataArray[0] forKey:key];
        }
    }
    else {
        [self pullDataDictionaryFunctionForCode:key selectionInIndexPath:nil];
    }
}

- (void)pullDataDictionaryFunctionForCode:(NSString *)dict_code selectionInIndexPath:(NSIndexPath *)indexPath {
    NSString *m_code = [dict_code uppercaseString];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Get:@{@"dict_code" : m_code} HeadParm:nil URLFooter:@"/common/get_dict_by_code.do" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            NSArray *m_array = [AppDataDictionary mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            if (m_array.count) {
                [[UserPublic getInstance].dataMapDic setObject:m_array forKey:dict_code];
                if (![self.condition valueForKey:dict_code]) {
                    if ([dict_code isEqualToString:@"query_column"] || [dict_code isEqualToString:@"search_time_type"]) {
                        [self.condition setValue:m_array[0] forKey:dict_code];
                        [weakself.tableView reloadData];
                    }
                }
                if (indexPath) {
                    [self selectRowAtIndexPath:indexPath];
                }
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)pullServiceArrayFunctionForCode:(NSString *)dict_code selectionInIndexPath:(NSIndexPath *)indexPath {
    NSString *functionCode = nil;
    if ([dict_code isEqualToString:@"start_service"]) {
        functionCode = @"hex_waybill_getCurrentService";
    }
    else if ([dict_code isEqualToString:@"end_service"]) {
        functionCode = @"hex_waybill_getEndService";
    }
    else if ([dict_code isEqualToString:@"power_service"]) {
        functionCode = @"hex_waybill_getPowerService";
    }
    
    if (!functionCode) {
        return;
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:functionCode Parm:nil completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            NSArray *m_array = [AppServiceInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            if (m_array.count) {
                [[UserPublic getInstance].dataMapDic setObject:m_array forKey:dict_code];
                if (indexPath) {
                    [self selectRowAtIndexPath:indexPath];
                }
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)pullCityArrayFunctionForCode:(NSString *)dict_code selectionInIndexPath:(NSIndexPath *)indexPath {
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_queryOpenCityList" Parm:nil completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            NSArray *m_array = [AppCityInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            if (m_array.count) {
                [[UserPublic getInstance].dataMapDic setObject:m_array forKey:dict_code];
                if (indexPath) {
                    [self selectRowAtIndexPath:indexPath];
                }
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)pullLoadServiceArrayFunctionForTransportTruckID:(NSString *)transport_truck_id selectionInIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *m_dic = @{@"transport_truck_id" : transport_truck_id};
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_arrival_queryServiceListByTransportTruckId" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            NSArray *m_array = [AppServiceInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            if (m_array.count) {
                [[UserPublic getInstance].dataMapDic setObject:m_array forKey:serviceDataMapKeyForTruck(transport_truck_id)];
                if (indexPath) {
                    [self selectRowAtIndexPath:indexPath];
                }
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}



- (void)searchButtonAction {
    [self goBackWithDone:YES];
}



- (void)doDoneAction {
    if (self.doneBlock) {
        self.doneBlock(self.condition);
    }
}

- (void)editAtIndex:(NSUInteger )row andContent:(NSString *)content {
    NSDictionary *m_dic = self.showArray[row];
    [self.condition setValue:content forKey:m_dic[@"key"]];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"start_time"] || [key isEqualToString:@"end_time"]) {
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
    else if ([AppPublic getVariableWithClass:self.condition.class subClass:[AppDataDictionary class] varName:key]) {
        NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
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
            [self pullDataDictionaryFunctionForCode:key selectionInIndexPath:indexPath];
        }
    }
    else if ([key isEqualToString:@"start_service"] || [key isEqualToString:@"end_service"] || [key isEqualToString:@"power_service"]) {
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
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
            [self pullServiceArrayFunctionForCode:key selectionInIndexPath:indexPath];
        }
    }
    else if ([key isEqualToString:@"start_station_city"] || [key isEqualToString:@"end_station_city"]) {
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
    else if ([key isEqualToString:@"load_service"]) {
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:serviceDataMapKeyForTruck(self.condition.transport_truck_id)];
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
            [self pullLoadServiceArrayFunctionForTransportTruckID:self.condition.transport_truck_id selectionInIndexPath:indexPath];
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

//- (NSSet *)dataDicSet {
//    if (!_dataDicSet) {
//        _dataDicSet = [NSSet setWithObjects:@"query_column", @"transport_truck_state", @"search_time_type", @"show_column", @"cash_on_delivery_type", @"cod_payment_state", @"cod_loan_state", @"waybill_receive_state", @"loan_apply_state", @"daily_name", @"daily_apply_state", nil];
//    }
//    return _dataDicSet;
//}

- (NSSet *)inputValidSet {
    if (!_inputValidSet) {
        _inputValidSet = [NSSet setWithObjects:@"query_val", @"truck_number_plate", @"bank_card_owner", @"contact_phone", @"daily_fee", @"note", @"freight_cust_name", @"phone", nil];
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
        _boolValidSet = [NSSet setWithObjects:@"is_cancel", nil];
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
    else if ([key isEqualToString:@"start_service"] || [key isEqualToString:@"end_service"] || [key isEqualToString:@"power_service"] || [key isEqualToString:@"load_service"]) {
        cell.baseView.textField.text = [[self.condition valueForKey:key] valueForKey:@"showCityAndServiceName"];
    }
    else if ([key isEqualToString:@"start_station_city"] || [key isEqualToString:@"end_station_city"]) {
        cell.baseView.textField.text = [[self.condition valueForKey:key] valueForKey:@"open_city_name"];
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
