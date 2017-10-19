//
//  PublicQueryConditionVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicQueryConditionVC.h"

#import "BlockActionSheet.h"
#import "SingleInputCell.h"
#import "PublicDatePickerView.h"

@interface PublicQueryConditionVC ()<UITextFieldDelegate>

@property (strong, nonatomic) NSMutableDictionary *dataDic;
@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) NSSet *inputValidSet;
@property (strong, nonatomic) NSSet *boolValidSet;

@property (strong, nonatomic) UIView *footerView;

@end

@implementation PublicQueryConditionVC

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
- (void)initializeData{
    switch (self.type) {
        case QueryConditionType_WaybillQuery:{
            _showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                           @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"},
                           @{@"title":@"开单网点",@"subTitle":@"请选择",@"key":@"start_service"},
                           @{@"title":@"目的网点",@"subTitle":@"请选择",@"key":@"end_service"},
                           @{@"title":@"作废状态",@"subTitle":@"请选择",@"key":@"is_cancel"}];
            [self pullDataDictionaryFunctionForCode:@"query_column" selectionInIndexPath:nil];
        }
            break;
            
        case QueryConditionType_TransportTruck:{
            _showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                           @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                           @{@"title":@"起点城市",@"subTitle":@"请选择",@"key":@"start_station_city"},
                           @{@"title":@"终点城市",@"subTitle":@"请选择",@"key":@"end_station_city"},
                           @{@"title":@"车辆牌照",@"subTitle":@"请输入",@"key":@"truck_number_plate"}];
        }
            break;
            
        default:
            break;
    }
}

- (void)pullDataDictionaryFunctionForCode:(NSString *)dict_code selectionInIndexPath:(NSIndexPath *)indexPath {
    NSString *m_code = [dict_code uppercaseString];
    
    [self showHudInView:self.view hint:nil];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Get:@{@"dict_code" : m_code} HeadParm:nil URLFooter:@"/common/get_dict_by_code.do" completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            NSArray *m_array = [AppDataDictionary mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            [weakself.dataDic setObject:m_array forKey:dict_code];
            if (m_array.count) {
                if (![self.condition valueForKey:dict_code]) {
                    if ([dict_code isEqualToString:@"query_column"]) {
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
    [self showHudInView:self.view hint:nil];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:[dict_code isEqualToString:@"start_service"] ? @"hex_waybill_getCurrentService" : @"hex_waybill_getEndService" Parm:nil completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            NSArray *m_array = [AppServiceInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            [weakself.dataDic setObject:m_array forKey:dict_code];
            if (m_array.count) {
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
    [self showHudInView:self.view hint:nil];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_queryOpenCityList" Parm:nil completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            NSArray *m_array = [AppCityInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            [weakself.dataDic setObject:m_array forKey:dict_code];
            if (m_array.count) {
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

- (void)cancelButtonAction{
    [self goBackWithDone:NO];
}

- (void)searchButtonAction {
    [self goBackWithDone:YES];
}

- (void)goBackWithDone:(BOOL)done{
    QKWEAKSELF;
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        if (done) {
            [weakself doDoneAction];
        }
    }];
}

- (void)doDoneAction{
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
    else if ([key isEqualToString:@"query_column"]) {
        NSArray *dicArray = [self.dataDic objectForKey:key];
        if (dicArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dicArray.count];
            for (AppDataDictionary *m_data in dicArray) {
                [m_array addObject:m_data.item_name];
            }
            NSDictionary *m_dic = self.showArray[indexPath.row];
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
    else if ([key isEqualToString:@"start_service"] || [key isEqualToString:@"end_service"]) {
        NSArray *dataArray = [self.dataDic objectForKey:key];
        if (dataArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dataArray.count];
            for (AppServiceInfo *m_data in dataArray) {
                [m_array addObject:m_data.service_name];
            }
            NSDictionary *m_dic = self.showArray[indexPath.row];
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
        NSArray *dataArray = [self.dataDic objectForKey:key];
        if (dataArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dataArray.count];
            for (AppCityInfo *m_data in dataArray) {
                [m_array addObject:m_data.open_city_name];
            }
            NSDictionary *m_dic = self.showArray[indexPath.row];
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
        NSDictionary *m_dic = self.showArray[indexPath.row];
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

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary new];
    }
    return _dataDic;
}

- (NSSet *)inputValidSet {
    if (!_inputValidSet) {
        _inputValidSet = [NSSet setWithObjects:@"query_val", @"truck_number_plate", nil];
    }
    return _inputValidSet;
}

- (NSSet *)boolValidSet {
    if (!_boolValidSet) {
        _boolValidSet = [NSSet setWithObjects:@"is_cancel", nil];
    }
    return _boolValidSet;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 60)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kEdge, kEdgeMiddle, _footerView.width - 2 * kEdge, _footerView.height - kEdgeMiddle)];
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
    if ([key isEqualToString:@"query_column"]) {
        cell.baseView.textField.text = self.condition.query_column.item_name;
    }
    else if ([key isEqualToString:@"start_service"] || [key isEqualToString:@"end_service"]) {
        cell.baseView.textField.text = [[self.condition valueForKey:key] valueForKey:@"service_name"];
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

#pragma  mark - TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return (range.location < kInputLengthMax);
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[IndexPathTextField class]]) {
        NSIndexPath *indexPath = [(IndexPathTextField *)textField indexPath];
        [self editAtIndex:indexPath.row andContent:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
