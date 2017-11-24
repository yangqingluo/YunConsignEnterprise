//
//  CodPayVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodPayVC.h"

#import "MJRefresh.h"
#import "WaybillCustReceiveCell.h"
#import "SingleInputCell.h"
#import "BlockActionSheet.h"

@interface CodPayVC ()<UITextFieldDelegate>

@property (strong, nonatomic) AppPaymentWaybillInfo *paymentData;
@property (strong, nonatomic) WaybillToCustReceiveInfo *toSaveData;

@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) NSSet *defaultKeyBoardTypeSet;
@property (strong, nonatomic) NSSet *selectorSet;

@end

@implementation CodPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTableViewHeader];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"代收款收款" createMenuItem:^UIView *(int nIndex){
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
    if (!self.toSaveData.waybill_id) {
        self.toSaveData.waybill_id = [self.billData.waybill_id copy];
    }
    else if (!self.toSaveData.cash_on_delivery_real_amount) {
        [self showHint:@"请输入实收代收款"];
        return;
    }
    else if (!self.toSaveData.cash_on_delivery_causes_type) {
        [self showHint:@"请选择代收款少款类型"];
        return;
    }
    else if (!self.toSaveData.cash_on_delivery_causes_amount) {
//        [self showHint:@"请输入代收款少款"];
//        return;
        self.toSaveData.cash_on_delivery_causes_amount = @"0";
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
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"waybill_id" : self.toSaveData.waybill_id, @"cash_on_delivery_real_amount" : self.toSaveData.cash_on_delivery_real_amount, @"cash_on_delivery_causes_amount" : self.toSaveData.cash_on_delivery_causes_amount, @"cash_on_delivery_causes_type" : self.toSaveData.cash_on_delivery_causes_type}];
    if (self.toSaveData.cash_on_delivery_causes_note) {
        [m_dic setObject:self.toSaveData.cash_on_delivery_causes_note forKey:@"cash_on_delivery_causes_note"];
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_finance_payWaybillCashOnDeliveryByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_CodWaitPayRefresh object:nil];
    [self showHint:@"代收款收款成功"];
    [self goBack];
}

- (void)editAtIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag andContent:(NSString *)content {
    if (indexPath.row < self.showArray.count) {
        id object = self.showArray[indexPath.row];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *m_dic = object;
            NSString *key = m_dic[@"key"];
            if ([self.defaultKeyBoardTypeSet containsObject:key]) {
                [self.toSaveData setValue:content forKey:m_dic[@"key"]];
            }
            else {
                [self.toSaveData setValue:[NSString stringWithFormat:@"%d", [content intValue]] forKey:m_dic[@"key"]];
            }
        }
//        else if ([object isKindOfClass:[NSArray class]]) {
//            NSArray *m_array = object;
//            if (m_array.count == 2 && tag >= 0 && tag <= 1) {
//                NSDictionary *m_dic = m_array[tag];
//                int value = [content intValue];
//                [self.toSaveData setValue:[NSString stringWithFormat:@"%d", value] forKey:m_dic[@"key"]];
//            }
//        }
    }
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    switch (indexPath.section) {
        case 1:{
            if (indexPath.row == 1) {
                NSDictionary *m_dic = self.showArray[indexPath.row];
                NSString *key = m_dic[@"key"];
                NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
                if (dicArray.count) {
                    NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dicArray.count];
//                    if (![self.toSaveData valueForKey:key]) {
//                        AppDataDictionary *m_data = dicArray[0];
//                        [self.toSaveData setValue:m_data.item_val forKey:key];
//                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                    }
                    for (AppDataDictionary *m_data in dicArray) {
                        [m_array addObject:m_data.item_name];
                    }
                    QKWEAKSELF;
                    BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                        if (buttonIndex > 0 && (buttonIndex - 1) < dicArray.count) {
                            AppDataDictionary *m_data = dicArray[buttonIndex - 1];
                            [weakself.toSaveData setValue:m_data.item_val forKey:key];
                            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
        _showArray = @[
                       @{@"title":@"实收代收款",@"subTitle":@"请输入",@"key":@"cash_on_delivery_real_amount"},
                       @{@"title":@"代收款少款",@"subTitle":@"请选择",@"key":@"cash_on_delivery_causes_type"},
                       @{@"title":@"少款金额",@"subTitle":@"请输入",@"key":@"cash_on_delivery_causes_amount"},
                       @{@"title":@"少款原因",@"subTitle":@"请输入",@"key":@"cash_on_delivery_causes_note"}];
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
    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self selectRowAtIndexPath:indexPath];
}

#pragma  mark - TextField
- (void)textFieldDidChange:(UITextField *)textField {
    if ([textField isKindOfClass:[IndexPathTextField class]]) {
        NSIndexPath *indexPath = [(IndexPathTextField *)textField indexPath];
        [self editAtIndexPath:indexPath tag:textField.tag andContent:textField.text];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[IndexPathTextField class]]) {
        NSIndexPath *indexPath = [(IndexPathTextField *)textField indexPath];
        [self editAtIndexPath:indexPath tag:textField.tag andContent:textField.text];
    }
}

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
            if ([key isEqualToString:@"consignee_id_card"]) {
                length = kIDLengthMax;
            }
            else if (![self.defaultKeyBoardTypeSet containsObject:key]) {
                length = kPriceLengthMax;
            }
        }
    }
    
    return (range.location < length);
}

@end
