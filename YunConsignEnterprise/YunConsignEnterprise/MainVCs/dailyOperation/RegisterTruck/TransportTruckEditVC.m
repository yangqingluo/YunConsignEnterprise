//
//  TransportTruckEditVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/12/20.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "TransportTruckEditVC.h"

#import "SingleInputCell.h"

@interface TransportTruckEditVC ()<UITextFieldDelegate>

@property (strong, nonatomic) AppTransportTruckDetailInfo *detailData;
@property (strong, nonatomic) NSSet *defaultKeyBoardTypeSet;

@end

@implementation TransportTruckEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData];
    [self setupNav];
    [self pullTransportTruckDetailData];
}

//初始化数据
- (void)initializeData {
    self.showArray = @[
                       @[@{@"title":@"车辆",@"subTitle":@"请输入",@"key":@"truck_number_plate",@"need":@YES},
                         @{@"title":@"司机",@"subTitle":@"请输入",@"key":@"truck_driver_name",@"need":@YES},
                         @{@"title":@"电话",@"subTitle":@"请输入",@"key":@"truck_driver_phone",@"need":@YES}],
                       @[@{@"title":@"登记运费",@"subTitle":@"请输入",@"key":@"cost_register",@"need":@YES},
                         @{@"title":@"装车费",@"subTitle":@"请输入",@"key":@"cost_load"},
                         @{@"title":@"预付费",@"subTitle":@"请输入",@"key":@"cost_before"},
                         @{@"title":@"打款账户",@"subTitle":@"请输入",@"key":@"driver_account"},
                         @{@"title":@"户主",@"subTitle":@"请输入",@"key":@"driver_account_name"},
                         @{@"title":@"开户行",@"subTitle":@"请输入",@"key":@"driver_account_bank"}],
                       @[@{@"title":@"备注",@"subTitle":@"请输入",@"key":@"note"}]
                       ];
}

- (void)setupNav {
    [self createNavWithTitle:@"派车信息" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"更新", [UIColor whiteColor]);
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
    for (NSArray *m_array in self.showArray) {
        for (NSDictionary *dic in m_array) {
            NSString *key = dic[@"key"];
            NSObject *value = [self.detailData valueForKey:key];
//            if ([key isEqualToString:@"cost_register"]) {
//                [self doShowHintFunction:@"登记运费不能为0"];
//                return;
//            }
//            else
            if ([dic[@"need"] boolValue] && !value) {
                [self doShowHintFunction:[NSString stringWithFormat:@"请补全%@", dic[@"title"]]];
                return;
            }
            if (value) {
                [m_dic setObject:value forKey:key];
            }
        }
    }

    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_updateTransportTruckByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
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

- (void)commonButtonAction:(IndexPathButton *)button {
    [self touchRowButtonAtIndexPath:button.indexPath];
}

- (void)editAtIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag andContent:(NSString *)content {
    NSArray *m_array = self.showArray[indexPath.section];
    if (indexPath.row < m_array.count) {
        NSDictionary *m_dic = m_array[indexPath.row];
        NSString *key = m_dic[@"key"];
        [self.detailData setValue:content forKey:key];
    }
}

- (void)touchRowButtonAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    NSArray *m_array = self.showArray[indexPath.section];
    if (indexPath.row > m_array.count - 1) {
        return;
    }
    NSDictionary *m_dic = m_array[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"truck_number_plate"]) {
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
        if (dataArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dataArray.count];
            for (AppTruckInfo *m_data in dataArray) {
                [m_array addObject:m_data.truck_number_plate];
            }
            QKWEAKSELF;
            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                if (buttonIndex > 0 && (buttonIndex - 1) < dataArray.count) {
                    AppTruckInfo *truck = dataArray[buttonIndex - 1];
                    weakself.detailData.truck_number_plate = [truck.truck_number_plate copy];
                    weakself.detailData.truck_driver_name = [truck.truck_driver_name copy];
                    weakself.detailData.truck_driver_phone = [truck.truck_driver_phone copy];
                    [weakself.tableView reloadData];
                }
            } otherButtonTitlesArray:m_array];
            [sheet showInView:self.view];
        }
        else {
            [self pullTruckArrayFunctionForCode:key selectionInIndexPath:indexPath];
        }
    }
}

- (void)payTransportTruckCostSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TransportTruckSaveRefresh object:nil];
    [self doShowHintFunction:@"更新派车信息成功"];
    [self goBack];
}

#pragma mark - getter
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *CellIdentifier = @"TTPayCost_truck_plate_cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            
            IndexPathButton *btn = [[IndexPathButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
            [btn setImage:[UIImage imageNamed:@"list_icon_common"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            btn.indexPath = [indexPath copy];
            [cell.baseView addRightView:btn];
        }
    }
    else {
        static NSString *CellIdentifier = @"TTPayCost_cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (!cell) {
            cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.baseView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    cell.baseView.textField.delegate = self;
    cell.baseView.lineView.hidden = YES;
    
    cell.baseView.textField.enabled = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSArray *m_array = self.showArray[indexPath.section];
    NSDictionary *m_dic = m_dic = m_array[indexPath.row];
    cell.baseView.textLabel.text = m_dic[@"title"];
    cell.baseView.textField.placeholder = m_dic[@"subTitle"];
    cell.baseView.textField.text = @"";
    cell.baseView.textField.indexPath = [indexPath copy];
    cell.baseView.textField.adjustZeroShow = NO;
    
    NSString *key = m_dic[@"key"];
    BOOL isKeybordDefault = [self.defaultKeyBoardTypeSet containsObject:key];
    if ([key isEqualToString:@"cost_load"] || [key isEqualToString:@"cost_before"] || [key isEqualToString:@"cost_register"] || [key isEqualToString:@"cost_check"]) {
        cell.baseView.textField.adjustZeroShow = YES;
        cell.baseView.textField.text = notShowFooterZeroString([self.detailData valueForKey:key], @"0");
    }
    else {
        cell.baseView.textField.text = [self.detailData valueForKey:key];
    }
    cell.baseView.textField.keyboardType = isKeybordDefault ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
    return cell;
}

@end
