//
//  TTPayCostVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/24.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "TTPayCostVC.h"
#import "TTLoadListVC.h"

#import "SingleInputCell.h"
#import "PublicDatePickerView.h"

@interface TTPayCostVC ()<UITextFieldDelegate>

@property (strong, nonatomic) AppTransportTruckDetailInfo *detailData;
@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) NSSet *defaultKeyBoardTypeSet;

@end

@implementation TTPayCostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self pullTransportTruckDetailData];
}

- (void)setupNav {
    [self createNavWithTitle:@"发放运费" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"保存", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonAction {
    [self dismissKeyboard];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"transport_truck_id" : self.truckData.transport_truck_id}];
    NSArray *m_array = self.showArray[3];
    for (NSDictionary *dic in m_array) {
        NSString *key = dic[@"key"];
        NSString *value = [self.detailData valueForKey:key];
        if (!value.length) {
            [self showHint:[NSString stringWithFormat:@"请补全%@", dic[@"title"]]];
            return;
        }
        [m_dic setObject:value forKey:key];
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_payTransportTruckCostByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself payTransportTruckCostSuccess];
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

- (void)pullTransportTruckDetailData {
    NSDictionary *m_dic = @{@"transport_truck_id" : self.truckData.transport_truck_id};
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_queryTransportTruckDetailByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = (ResponseItem *)responseBody;
            if (item.items.count) {
                weakself.detailData = [AppTransportTruckDetailInfo mj_objectWithKeyValues:item.items[0]];
            }
            [weakself updateSubviews];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)endRefreshing {
    [self doHideHudFunction];
}

- (void)updateSubviews {
    if (!self.detailData.check_time.length) {
        self.detailData.check_time = stringFromDate([NSDate date], defaultDateFormat);
    }
    [self.tableView reloadData];
}

- (void)editAtIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag andContent:(NSString *)content {
    if (indexPath.section == 3) {
        NSArray *m_array = self.showArray[indexPath.section];
        if (indexPath.row < m_array.count) {
            NSDictionary *m_dic = m_array[indexPath.row];
            NSString *key = m_dic[@"key"];
            [self.detailData setValue:content forKey:key];
        }
    }
}

- (void)payTransportTruckCostSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TransportTruckSaveRefresh object:nil];
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"运费发放完成" message:nil cancelButtonTitle:@"确定" clickButton:^(NSInteger buttonIndex) {
        [weakself goBack];
    } otherButtonTitles:nil];
    [alert show];
}

#pragma mark - getter
- (NSArray *)showArray {
    if (!_showArray) {
        _showArray = @[@[@{@"title":@"始发站",@"subTitle":@"",@"key":@"start_station_city_name"},
                         @{@"title":@"终点站",@"subTitle":@"",@"key":@"end_station_city_name"}],
                       @[@{@"title":@"车辆",@"subTitle":@"",@"key":@"truck_number_plate"},
                         @{@"title":@"司机",@"subTitle":@"",@"key":@"truck_driver_name"},
                         @{@"title":@"电话",@"subTitle":@"",@"key":@"truck_driver_phone"},
                         @{@"title":@"登记运费",@"subTitle":@"",@"key":@"cost_register"},
                         @{@"title":@"预付费",@"subTitle":@"",@"key":@"cost_before"}],
                       @[@{@"title":@"装车货量",@"subTitle":@"",@"key":@"load_quantity"}],
                       @[@{@"title":@"结算运费",@"subTitle":@"请输入",@"key":@"cost_check"},
                         @{@"title":@"结算日期",@"subTitle":@"请选择",@"key":@"check_time"},
                         @{@"title":@"打款账户",@"subTitle":@"请输入",@"key":@"driver_account"},
                         @{@"title":@"户主",@"subTitle":@"请输入",@"key":@"driver_account_name"},
                         @{@"title":@"开户行",@"subTitle":@"请输入",@"key":@"driver_account_bank"}]];
    }
    return _showArray;
}

- (NSSet *)defaultKeyBoardTypeSet {
    if (!_defaultKeyBoardTypeSet) {
        _defaultKeyBoardTypeSet = [NSSet setWithObjects:@"note", @"truck_driver_name", @"truck_number_plate", @"driver_account_name", @"driver_account_bank", nil];
    }
    
    return _defaultKeyBoardTypeSet;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.detailData ? self.showArray.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1 + MAX(1, self.detailData.end_station.count);
    }
    NSArray *m_array = self.showArray[section];
    return m_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return kEdge;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = kCellHeightFilter;
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TTPayCost_cell";
    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.baseView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        cell.baseView.textField.delegate = self;
        cell.baseView.lineView.hidden = YES;
    }
    NSArray *m_array = self.showArray[indexPath.section];
    NSDictionary *m_dic = nil;
    if (indexPath.row < m_array.count) {
        m_dic = m_array[indexPath.row];
        cell.baseView.textLabel.text = m_dic[@"title"];
        cell.baseView.textField.placeholder = m_dic[@"subTitle"];
        cell.baseView.textField.text = @"";
        cell.baseView.textField.indexPath = [indexPath copy];
    }
    else {
         cell.baseView.textLabel.text = @"";
    }
    cell.baseView.textField.enabled = NO;
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                cell.baseView.textField.text = self.detailData.start_station_city_name;
            }
            else {
                NSUInteger index = indexPath.row - 1;
                if (index < self.detailData.end_station.count) {
                    AppEndStationInfo *station = self.detailData.end_station[index];
                    cell.baseView.textField.text = [NSString stringWithFormat:@"%@-%@", station.end_station_city_name, station.end_station_service_name];
                }
                else {
                    cell.baseView.textField.text = @"";
                }
            }
        }
            break;
            
        case 1:
        case 2:
        case 3:{
            NSString *key = m_dic[@"key"];
            if ([key isEqualToString:@"cost_register"] || [key isEqualToString:@"cost_before"]) {
                cell.baseView.textField.text = notShowFooterZeroString([self.detailData valueForKey:key], @"");
            }
            else {
                cell.baseView.textField.text = [self.detailData valueForKey:key];
            }
            BOOL isKeybordDefault = [self.defaultKeyBoardTypeSet containsObject:key];
            cell.baseView.textField.keyboardType = isKeybordDefault ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
            if (indexPath.section == 2) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else if (indexPath.section == 3) {
                if ([key isEqualToString:@"check_time"]) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                else {
                    cell.baseView.textField.enabled = YES;
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 2) {
        TTLoadListVC *vc = [TTLoadListVC new];
        vc.data = self.truckData;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 3) {
        NSArray *m_array = self.showArray[indexPath.section];
        NSDictionary *m_dic = m_array[indexPath.row];
        NSString *key = m_dic[@"key"];
        if ([key isEqualToString:@"check_time"]) {
            [self dismissKeyboard];
            QKWEAKSELF;
            PublicDatePickerView *view = [[PublicDatePickerView alloc] initWithStyle:PublicDatePicker_Date andTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] callBlock:^(PublicDatePickerView *pickerView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [weakself.detailData setValue:stringFromDate(pickerView.datePicker.date, defaultDateFormat) forKey:key];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            view.datePicker.maximumDate = [NSDate date];
            [view show];
        }
    }
}

@end
