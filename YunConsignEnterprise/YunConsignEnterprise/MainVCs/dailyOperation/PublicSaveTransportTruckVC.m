//
//  PublicSaveTransportTruckVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/24.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicSaveTransportTruckVC.h"
#import "PublicEndStationSelectVC.h"

#import "SingleInputCell.h"
#import "BlockActionSheet.h"

@interface PublicSaveTransportTruckVC ()<UITextFieldDelegate>

@property (strong, nonatomic) AppSaveTransportTruckInfo *toSaveData;
@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) NSSet *defaultKeyBoardTypeSet;

@end

@implementation PublicSaveTransportTruckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
}

- (void)setupNav {
    [self createNavWithTitle:@"派车" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"确定", [UIColor whiteColor]);
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
    if (!self.toSaveData.start_station_city_id) {
        [self showHint:@"请选择始发站"];
        return;
    }
    else if (!self.toSaveData.end_station.count) {
        [self showHint:@"请选择终点站"];
        return;
    }
    else if (!self.toSaveData.truck_driver_phone.length) {
        [self showHint:@"请输入电话"];
        return;
    }
    else {
        NSMutableDictionary *m_dic = [NSMutableDictionary new];
        [m_dic setObject:self.toSaveData.start_station_city_id forKey:@"start_station_city_id"];
        [m_dic setObject:self.toSaveData.saveStringForEndStationServices forKey:@"end_station_service_id"];
        for (int section = 1; section < self.showArray.count; section++) {
            NSArray *m_array = self.showArray[section];
            for (NSDictionary *dic in m_array) {
                NSString *key = dic[@"key"];
                NSString *value = [self.toSaveData valueForKey:key];
                if (!value.length) {
                    [self showHint:[NSString stringWithFormat:@"请补全%@", dic[@"title"]]];
                    return;
                }
                [m_dic setObject:value forKey:key];
            }
        }
        [self doShowHudFunction];
        QKWEAKSELF;
        [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_saveTransportTruckFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
            [weakself doHideHudFunction];
            if (!error) {
                ResponseItem *item = responseBody;
                if (item.flag == 1) {
                    [weakself saveTransportTruckCostSuccess];
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
}

- (void)editAtIndexPath:(NSIndexPath *)indexPath andContent:(NSString *)content {
    if (indexPath.section == 1 || indexPath.section == 2 ) {
        NSArray *m_array = self.showArray[indexPath.section];
        if (indexPath.row < m_array.count) {
            NSDictionary *m_dic = m_array[indexPath.row];
            NSString *key = m_dic[@"key"];
            [self.toSaveData setValue:content forKey:key];
        }
    }
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    NSArray *m_array = self.showArray[indexPath.section];
    if (indexPath.row > m_array.count - 1) {
        return;
    }
    NSDictionary *m_dic = m_array[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"start_station_city"]) {
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
        if (dataArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dataArray.count];
            for (AppCityInfo *m_data in dataArray) {
                [m_array addObject:m_data.open_city_name];
            }
            QKWEAKSELF;
            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                if (buttonIndex > 0 && (buttonIndex - 1) < dataArray.count) {
                    AppCityInfo *city = dataArray[buttonIndex - 1];
                    weakself.toSaveData.start_station_city_id = [city.open_city_id copy];
                    weakself.toSaveData.start_station_city_name = [city.open_city_name copy];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            } otherButtonTitlesArray:m_array];
            [sheet showInView:self.view];
        }
        else {
            [self pullCityArrayFunctionForCode:key selectionInIndexPath:indexPath];
        }
    }
    else if ([key isEqualToString:@"end_station"]) {
        PublicEndStationSelectVC *vc = [PublicEndStationSelectVC new];
        QKWEAKSELF;
        vc.doneBlock = ^(NSObject *object){
            if ([object isKindOfClass:[NSArray class]]) {
                [weakself.toSaveData.end_station removeAllObjects];
                [weakself.toSaveData.end_station addObjectsFromArray:(NSArray *)object];
                [weakself.tableView reloadData];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)saveTransportTruckCostSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TransportTruckSaveRefresh object:nil];
    [self showHint:@"派车已完成"];
    [self goBack];
//    QKWEAKSELF;
//    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"派车已完成" message:nil cancelButtonTitle:@"确定" clickButton:^(NSInteger buttonIndex) {
//        [weakself goBack];
//    } otherButtonTitles:nil];
//    [alert show];
}

#pragma mark - getter
- (AppSaveTransportTruckInfo *)toSaveData {
    if (!_toSaveData) {
        _toSaveData = [AppSaveTransportTruckInfo new];
    }
    return _toSaveData;
}

- (NSArray *)showArray {
    if (!_showArray) {
        _showArray = @[@[@{@"title":@"始发站",@"subTitle":@"请选择",@"key":@"start_station_city"},
                         @{@"title":@"终点站",@"subTitle":@"请选择",@"key":@"end_station"}],
                       @[@{@"title":@"车辆",@"subTitle":@"请输入",@"key":@"truck_number_plate"},
                         @{@"title":@"司机",@"subTitle":@"请输入",@"key":@"truck_driver_name"},
                         @{@"title":@"电话",@"subTitle":@"请输入",@"key":@"truck_driver_phone"}],
                       @[@{@"title":@"运费",@"subTitle":@"请输入",@"key":@"cost_register"}]
                       ];
    }
    return _showArray;
}

- (NSSet *)defaultKeyBoardTypeSet {
    if (!_defaultKeyBoardTypeSet) {
        _defaultKeyBoardTypeSet = [NSSet setWithObjects:@"note", @"truck_driver_name", @"truck_number_plate", nil];
    }
    
    return _defaultKeyBoardTypeSet;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1 + MAX(1, self.toSaveData.end_station.count);
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
    SingleInputCell *cell = nil;
    if (indexPath.section == 1 && indexPath.row == 0) {
        static NSString *CellIdentifier = @"TTPayCost_truck_plate_cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.baseView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.baseView.textField.delegate = self;
            cell.baseView.lineView.hidden = YES;
            
            UIButton *btn = [[IndexPathButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
            [btn setImage:[UIImage imageNamed:@"list_icon_common"] forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [cell.baseView addRightView:btn];
        }
    }
    else {
        static NSString *CellIdentifier = @"TTPayCost_cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.baseView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.baseView.textField.delegate = self;
            cell.baseView.lineView.hidden = YES;
        }
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
            if (indexPath.row < 2) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row == 0) {
                cell.baseView.textField.text = self.toSaveData.start_station_city_name;
            }
            else {
                NSUInteger index = indexPath.row - 1;
                if (index < self.toSaveData.end_station.count) {
                    AppServiceInfo *service = self.toSaveData.end_station[index];
                    cell.baseView.textField.text = [NSString stringWithFormat:@"%@-%@", service.open_city_name, service.service_name];
                }
                else {
                    cell.baseView.textField.text = @"";
                }
            }
        }
            break;
            
        case 1:
        case 2:{
            NSString *key = m_dic[@"key"];
            cell.baseView.textField.text = [self.toSaveData valueForKey:key];
            BOOL isKeybordDefault = [self.defaultKeyBoardTypeSet containsObject:key];
            cell.baseView.textField.keyboardType = isKeybordDefault ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
            cell.baseView.textField.enabled = YES;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self selectRowAtIndexPath:indexPath];
}


@end
