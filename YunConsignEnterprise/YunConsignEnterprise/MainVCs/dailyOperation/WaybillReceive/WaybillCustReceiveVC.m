//
//  WaybillCustReceiveVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillCustReceiveVC.h"

#import "MJRefresh.h"
#import "WaybillCustReceiveCell.h"
#import "SingleInputCell.h"
#import "DoubleInputCell.h"
#import "BlockActionSheet.h"

@interface WaybillCustReceiveVC ()<UITextFieldDelegate>

@property (strong, nonatomic) AppPaymentWaybillInfo *paymentData;
@property (strong, nonatomic) WaybillToCustReceiveInfo *toSaveData;

@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) NSSet *defaultKeyBoardTypeSet;
@property (strong, nonatomic) NSSet *selectorSet;

@end

@implementation WaybillCustReceiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"自提" createMenuItem:^UIView *(int nIndex){
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

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonAction {
    [self dismissKeyboard];
    if (!self.toSaveData.consignee_name) {
        [self showHint:@"请补全提货人姓名"];
        return;
    }
    else if (!self.toSaveData.consignee_phone) {
        [self showHint:@"请补全提货人电话"];
        return;
    }
    else {
        if ([self.billData.cash_on_delivery_type isEqualToString: @"3"]) {
            //没有代收款
            
        }
        else {
            if (!self.toSaveData.cash_on_delivery_causes_type) {
                [self showHint:@"请选择代收款少款类型"];
                return;
            }
        }
    }
    
    if (!self.toSaveData.waybill_id) {
        self.toSaveData.waybill_id = [self.billData.waybill_id copy];
    }
    [self doCustReceiveWaybillByIdFunction];
}

- (void)pullWaybillPaymentInfo {
    NSDictionary *m_dic = @{@"waybill_id" : self.billData.waybill_id};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_receive_queryWaybillPaymentInfoByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = (ResponseItem *)responseBody;
            if (item.items.count) {
                weakself.paymentData = [AppPaymentWaybillInfo mj_objectWithKeyValues:item.items[0]];
            }
            [weakself updateSubviews];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)doCustReceiveWaybillByIdFunction {
    NSDictionary *m_dic = [self.toSaveData mj_keyValues];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_receive_custReceiveWaybillByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself custReceiveWaybillSuccess];
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

- (void)updateTableViewHeader {
    QKWEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself pullWaybillPaymentInfo];
    }];
}

- (void)endRefreshing {
    [self doHideHudFunction];
    [self.tableView.mj_header endRefreshing];
}

- (void)updateSubviews {
    [self.tableView reloadData];
}

- (void)custReceiveWaybillSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_WaybillReceiveRefresh object:nil];
    [self showHint:@"自提成功"];
    [self goBack];
}

- (void)editAtIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag andContent:(NSString *)content {
    if (indexPath.row < self.showArray.count) {
        id object = self.showArray[indexPath.row];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *m_dic = object;
            NSString *key = m_dic[@"key"];
            if ([self.defaultKeyBoardTypeSet containsObject:key]) {
                [self.toSaveData setValue:content forKey:key];
            }
            else {
                [self.toSaveData setValue:[NSString stringWithFormat:@"%d", [content intValue]] forKey:key];
            }
        }
        else if ([object isKindOfClass:[NSArray class]]) {
            NSArray *m_array = object;
            if (m_array.count == 2 && tag >= 0 && tag <= 1) {
                NSDictionary *m_dic = m_array[tag];
                int value = [content intValue];
                [self.toSaveData setValue:[NSString stringWithFormat:@"%d", value] forKey:m_dic[@"key"]];
            }
        }
    }
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    switch (indexPath.section) {
        case 1:{
            if (indexPath.row == 4) {
                NSDictionary *m_dic = self.showArray[indexPath.row];
                NSString *key = m_dic[@"key"];
                NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
                if (dicArray.count) {
                    NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dicArray.count];
                    for (AppDataDictionary *m_data in dicArray) {
                        [m_array addObject:m_data.item_name];
                    }
                    QKWEAKSELF;
                    BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                        if (buttonIndex > 0 && (buttonIndex - 1) < dicArray.count) {
                            AppDataDictionary *m_data = dicArray[buttonIndex - 1];
                            [weakself.toSaveData setValue:m_data.item_val forKey:key];
                            if ([m_data.item_val isEqualToString:boolString(NO)]) {
                                weakself.toSaveData.cash_on_delivery_causes_note = m_data.item_name;
                                weakself.toSaveData.cash_on_delivery_real_amount = [NSString stringWithFormat:@"%d", [self.paymentData.cash_on_delivery_amount intValue] - [self.paymentData.pay_on_delivery_amount intValue]];
                                weakself.toSaveData.cash_on_delivery_causes_amount = [NSString stringWithFormat:@"%d", [self.paymentData.pay_on_delivery_amount intValue]];
                            }
                            else {
                                weakself.toSaveData.cash_on_delivery_causes_note = nil;
                                weakself.toSaveData.cash_on_delivery_real_amount = @"0";
                                weakself.toSaveData.cash_on_delivery_causes_amount = @"0";
                            }
                            [weakself.tableView reloadData];
                        }
                    } otherButtonTitlesArray:m_array];
                    [sheet showInView:self.view];
                }
                else {
                    [self pullDataDictionaryFunctionForCode:key selectionInIndexPath:indexPath];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - getter
- (WaybillToCustReceiveInfo *)toSaveData {
    if (!_toSaveData) {
        _toSaveData = [WaybillToCustReceiveInfo new];
        _toSaveData.waybill_id = [self.billData.waybill_id copy];
        _toSaveData.consignee_name = [self.billData.consignee_name copy];
        _toSaveData.consignee_phone = [self.billData.consignee_phone copy];
        _toSaveData.cash_on_delivery_real_amount = @"0";
        _toSaveData.cash_on_delivery_causes_amount = @"0";
        _toSaveData.payment_indemnity_amount = @"0";
        _toSaveData.deliver_indemnity_amount = @"0";
    }
    return _toSaveData;
}

- (NSArray *)showArray {
    if (!_showArray) {
        _showArray = @[@{@"title":@"提货人",@"subTitle":@"请输入",@"key":@"consignee_name"},
                       @{@"title":@"联系电话",@"subTitle":@"请输入",@"key":@"consignee_phone"},
                       @{@"title":@"提货人身份证",@"subTitle":@"请输入",@"key":@"consignee_id_card"},
                       @{@"title":@"实收代收款",@"subTitle":@"请输入",@"key":@"cash_on_delivery_real_amount"},
                       @{@"title":@"代收款少款",@"subTitle":@"请选择",@"key":@"cash_on_delivery_causes_type"},
                       @{@"title":@"少款原因",@"subTitle":@"请输入",@"key":@"cash_on_delivery_causes_note"},
                       @{@"title":@"少款",@"subTitle":@"请输入",@"key":@"cash_on_delivery_causes_amount"},
                       @[@{@"title":@"赔款",@"subTitle":@"请输入",@"key":@"payment_indemnity_amount"},
                         @{@"title":@"包送",@"subTitle":@"请输入",@"key":@"deliver_indemnity_amount"}],
                       @{@"title":@"自提备注",@"subTitle":@"无",@"key":@"waybill_receive_note"},];
        if ([self.billData.cash_on_delivery_type isEqualToString: @"3"]) {
            //没有代收款
            _showArray = @[@{@"title":@"提货人",@"subTitle":@"请输入",@"key":@"consignee_name"},
                           @{@"title":@"联系电话",@"subTitle":@"请输入",@"key":@"consignee_phone"},
                           @{@"title":@"提货人身份证",@"subTitle":@"请输入",@"key":@"consignee_id_card"},
                           @{@"title":@"少款",@"subTitle":@"请输入",@"key":@"cash_on_delivery_causes_amount"},
                           @[@{@"title":@"赔款",@"subTitle":@"请输入",@"key":@"payment_indemnity_amount"},
                             @{@"title":@"包送",@"subTitle":@"请输入",@"key":@"deliver_indemnity_amount"}],
                           @{@"title":@"自提备注",@"subTitle":@"无",@"key":@"waybill_receive_note"},];
        }
    }
    return _showArray;
}

- (NSSet *)defaultKeyBoardTypeSet {
    if (!_defaultKeyBoardTypeSet) {
        _defaultKeyBoardTypeSet = [NSSet setWithObjects:@"waybill_receive_note", @"cash_on_delivery_causes_note", @"consignee_name", nil];
    }
    return _defaultKeyBoardTypeSet;
}

- (NSSet *)selectorSet {
    if (!_selectorSet) {
        _selectorSet = [NSSet setWithObjects:@"cash_on_delivery_causes_type", nil];
    }
    return _selectorSet;
}

- (UITableViewCell *)tableView:(UITableView *)tableView singleInputCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
        if (indexPath.section == 1) {
            [cell.baseView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        cell.baseView.textField.delegate = self;
        cell.baseView.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    cell.baseView.textLabel.text = showObject[@"title"];
    cell.baseView.textField.placeholder = showObject[@"subTitle"];
    cell.baseView.textField.text = @"";
    cell.baseView.textField.enabled = YES;
    cell.baseView.textField.indexPath = [indexPath copy];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSString *key = showObject[@"key"];
    BOOL isKeybordDefault = [self.defaultKeyBoardTypeSet containsObject:key];
    cell.baseView.textField.keyboardType = isKeybordDefault ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
    cell.baseView.textField.adjustZeroShow = !isKeybordDefault;
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    
    if ([self.selectorSet containsObject:key]) {
        cell.baseView.textField.enabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
        for (AppDataDictionary *m_data in dicArray) {
            if ([m_data.item_val isEqualToString:[self.toSaveData valueForKey:key]]) {
                cell.baseView.textField.text = m_data.item_name;
                break;
            }
        }
    }
    else {
        NSString *value = [self.toSaveData valueForKey:key];
        if (value) {
            cell.baseView.textField.text = value;
        }
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView doubleInputCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    NSArray *m_array = showObject;
    DoubleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = [[DoubleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.baseView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.anotherBaseView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        cell.baseView.textField.delegate = self;
        cell.anotherBaseView.textField.delegate = self;
        cell.baseView.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.anotherBaseView.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.baseView.textField.adjustZeroShow = YES;
        cell.anotherBaseView.textField.adjustZeroShow = YES;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
    }
    NSDictionary *m_dic1 = m_array[0];
    NSDictionary *m_dic2 = m_array[1];
    cell.baseView.textLabel.text = m_dic1[@"title"];
    cell.baseView.textField.placeholder = m_dic1[@"subTitle"];
    cell.baseView.textField.text = @"";
    cell.baseView.textField.indexPath = [indexPath copy];
    
    cell.anotherBaseView.textLabel.text = m_dic2[@"title"];
    cell.anotherBaseView.textField.placeholder = m_dic2[@"subTitle"];
    cell.anotherBaseView.textField.text = @"";
    cell.anotherBaseView.textField.indexPath = [indexPath copy];
    
    NSString *key1 = m_dic1[@"key"];
    NSString *key2 = m_dic2[@"key"];
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    
    NSString *value1 = [self.toSaveData valueForKey:key1];
    if (value1) {
        cell.baseView.textField.text = value1;
    }
    NSString *value2 = [self.toSaveData valueForKey:key2];
    if (value2) {
        cell.anotherBaseView.textField.text = value2;
    }
    
    return cell;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rows = 1;
    if (section == 1) {
        return self.showArray.count;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = kCellHeightFilter;
    if (indexPath.section == 0) {
        rowHeight = [WaybillCustReceiveCell tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
            rowHeight += kEdge;
        }
    }
    
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kEdgeSmall;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section != 0) {
        return kEdge;
    }
    return kEdgeSmall;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"way_bill_receive_cell";
        WaybillCustReceiveCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[WaybillCustReceiveCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
        }
        
        cell.data = self.paymentData;
        return cell;
    }
    else if (indexPath.section == 1) {
        id object = self.showArray[indexPath.row];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *m_dic = object;
            static NSString *CellIdentifier = @"fee_edit_cell";
            return [self tableView:tableView singleInputCellForRowAtIndexPath:indexPath showObject:m_dic reuseIdentifier:CellIdentifier];
        }
        else if ([object isKindOfClass:[NSArray class]]){
            NSArray *m_array = (NSArray *)object;
            if (m_array.count == 2) {
                static NSString *CellIdentifier = @"double_cell";
                return [self tableView:tableView doubleInputCellForRowAtIndexPath:indexPath showObject:m_array reuseIdentifier:CellIdentifier];
            }
        }
    }
    else if (indexPath.section == 2) {
        static NSString *CellIdentifier = @"receipt_form_voucher_cell";
        SingleInputCell *cell = (SingleInputCell *)[self tableView:tableView singleInputCellForRowAtIndexPath:indexPath showObject:@{@"title":@"签收底单",@"subTitle":@"拍照上传",@"key":@"receipt_form_voucher"} reuseIdentifier:CellIdentifier];
        cell.baseView.textField.enabled = NO;
        cell.baseView.lineView.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
    return [UITableViewCell new];
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
    NSInteger length = kInputLengthMax;
    if ([textField isKindOfClass:[IndexPathTextField class]]) {
        NSIndexPath *indexPath = [(IndexPathTextField *)textField indexPath];
        id item = self.showArray[indexPath.row];
        NSString *key = @"";
        if ([item isKindOfClass:[NSDictionary class]]) {
            key = item[@"key"];
        }
        else if ([item isKindOfClass:[NSArray class]]) {
            NSDictionary *m_dic = item[textField.tag];
            key = m_dic[@"key"];
        }
        
        if (key.length) {
            if (![self.defaultKeyBoardTypeSet containsObject:key]) {
                length = kPriceLengthMax;
            }
        }
    }
    
    return (range.location < length);
}

@end
