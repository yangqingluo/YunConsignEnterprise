//
//  WayBillOpenVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillOpenVC.h"

@interface WayBillOpenVC ()


@end

@implementation WayBillOpenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self clearData];
    [[QKNetworkSingleton sharedManager] getInsuranceFeeRateByJoinIdCompletion:nil];
}

- (void)setupNav {
    [self createNavWithTitle:self.accessInfo.menu_name createMenuItem:^UIView *(int nIndex){
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

- (void)senderButtonAction {
    PublicSRSelectVC *vc = [PublicSRSelectVC new];
    vc.type = SRSelectType_Sender;
    vc.data = [self.headerView.senderInfo copy];
    vc.doneBlock = ^(id object){
        if ([object isKindOfClass:[AppSendReceiveInfo class]]) {
            self.headerView.senderInfo = [object copy];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)receiverButtonAction {
    PublicSRSelectVC *vc = [PublicSRSelectVC new];
    vc.type = SRSelectType_Receiver;
    vc.data = [self.headerView.receiverInfo copy];
    vc.doneBlock = ^(id object){
        if ([object isKindOfClass:[AppSendReceiveInfo class]]) {
            self.headerView.receiverInfo = [object copy];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)saveButtonAction {
    [self dismissKeyboard];
    
    if (!self.headerView.senderInfo) {
        [self showHint:@"请补全发货人信息"];
        return;
    }
    else {
        [self.toSaveData appendSenderInfo:self.headerView.senderInfo];
    }
    
    if (!self.headerView.receiverInfo) {
        [self showHint:@"请补全收货人信息"];
        return;
    }
    else {
        [self.toSaveData appendReceiverInfo:self.headerView.receiverInfo];
    }
    
    if (!self.goodsArray.count) {
        [self showHint:@"请添加货物信息"];
        return;
    }
    else {
        self.toSaveData.waybill_items = [[AppGoodsInfo mj_keyValuesArrayWithObjectArray:self.goodsArray] mj_JSONString];
    }
    
//    long long amount = [self.toSaveData.total_amount longLongValue];
//    long long payNowAmount = self.toSaveData.is_pay_now ? [self.toSaveData.pay_now_amount longLongValue] : 0LL;
//    long long payOnReceiptAmount = self.toSaveData.is_pay_on_receipt ? [self.toSaveData.pay_on_receipt_amount longLongValue] : 0LL;
//    long long payOnDeliveryAmount = self.toSaveData.is_pay_on_delivery ? [self.toSaveData.pay_on_delivery_amount longLongValue] : 0LL;
//    if (amount != payNowAmount + payOnReceiptAmount + payOnDeliveryAmount) {
//        [self showHint:@"总费用不等于现付提付回单付的和，请检查"];
//        return;
//    }
    
    self.toSaveData.consignment_time = stringFromDate(self.headerView.date, nil);
    [self pushSaveWaybillFunction:[self.toSaveData app_keyValues]];
}

- (void)addGoodsButtonAction {
    if (!self.headerView.senderInfo) {
        [self showHint:@"请补全发货人信息"];
        return;
    }
    else if (!self.headerView.receiverInfo) {
        [self showHint:@"请补全收货人信息"];
        return;
    }
    AddGoodsVC *vc = [AddGoodsVC new];
    vc.senderInfo = [self.headerView.senderInfo copy];
    QKWEAKSELF;
    vc.doneBlock = ^(id object){
        if ([object isKindOfClass:[AppGoodsInfo class]]) {
            AppGoodsInfo *item = (AppGoodsInfo *)object;
            [weakself.goodsArray addObject:item];
            [weakself caclateGoodsSummary:YES];
            [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)switchorButtonAction:(IndexPathSwitch *)button {
    if (button.indexPath.section == 1) {
        NSDictionary *m_dic = self.feeShowArray[button.indexPath.row - 1];
        [self.toSaveData setValue:boolString(button.isOn) forKey:m_dic[@"key"]];
//        [self.tableView reloadRowsAtIndexPaths:@[button.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)commonButtonAction:(IndexPathButton *)button {
    [self touchRowButtonAtIndexPath:button.indexPath];
}

- (void)checkButtonAction:(IndexPathButton *)button {
    if (button.indexPath.section == 2) {
        NSDictionary *m_dic = self.payStyleShowArray[button.indexPath.row - 1];
        button.selected = !button.selected;
        [self.toSaveData setValue:boolString(button.selected) forKey:m_dic[@"subKey"]];
        if (!button.selected) {
            [self.toSaveData setValue:@"0" forKey:m_dic[@"key"]];
        }
        [self.tableView reloadRowsAtIndexPaths:@[button.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)removeGoodsAtIndex:(NSUInteger)index {
    if (index < self.goodsArray.count) {
        [self.goodsArray removeObjectAtIndex:index];
        [self caclateGoodsSummary:YES];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)caclateGoodsSummary:(BOOL)isUpdateWaybillItem {
    if (isUpdateWaybillItem) {
        is_update_waybill_item = YES;
    }
    long long freight = 0;
    int number = 0;
    double weight = 0.0;
    double volume = 0.0;
    for (AppGoodsInfo *item in self.goodsArray) {
        freight += [item.freight longLongValue];
        number += [item.number intValue];
        weight += [item.weight doubleValue];
        volume += [item.volume doubleValue];
    }
    self.toSaveData.freight = [NSString stringWithFormat:@"%lld", freight];
    self.toSaveData.goods_total_count = [NSString stringWithFormat:@"%d", number];
    self.toSaveData.goods_total_weight = [NSString stringWithFormat:@"%.1f", weight];
    self.toSaveData.goods_total_volume = [NSString stringWithFormat:@"%.1f", volume];
}

- (void)checkDataMapExistedForCode:(NSString *)key {
    NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
    if (dataArray.count) {
        if (![self.toSaveData valueForKey:key] && [self.toCheckDataMapSet containsObject:key]) {
            AppDataDictionary *item = [key isEqualToString:@"receipt_sign_type"] ? dataArray[dataArray.count - 1] : dataArray[0];
            [self.toSaveData setValue:item.item_val forKey:key];
            [self.tableView reloadData];
        }
    }
    else {
        [self pullDataDictionaryFunctionForCode:key selectionInIndexPath:nil];
    }
}

- (void)editAtIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag andContent:(NSString *)content {
    switch (indexPath.section) {
        case 0: {
            self.toSaveData.freight = [NSString stringWithFormat:@"%lld", [content longLongValue]];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
            
        case 1: {
            if (indexPath.row > 0 && indexPath.row - 1 < self.feeShowArray.count) {
                id object = self.feeShowArray[indexPath.row - 1];
                if ([object isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *m_dic = object;
                    [self.toSaveData setValue:[NSString stringWithFormat:@"%d", [content intValue]] forKey:m_dic[@"key"]];
                }
                else if ([object isKindOfClass:[NSArray class]]) {
                    NSArray *m_array = object;
                    if (m_array.count == 2 && tag >= 0 && tag <= 1) {
                        NSDictionary *m_dic = m_array[tag];
                        int value = [content intValue];
                        [self.toSaveData setValue:[NSString stringWithFormat:@"%d", value] forKey:m_dic[@"key"]];
                        NSString *key = m_dic[@"key"];
                        if ([key isEqualToString:@"insurance_amount"]) {
                            self.toSaveData.insurance_fee = [NSString stringWithFormat:@"%.0f", ceil(value * [UserPublic getInstance].insuranceFeeRate)];
                            DoubleInputCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                            cell.anotherBaseView.textField.text = self.toSaveData.insurance_fee;
                        }
                    }
                }
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
            break;
            
        case 2: {
            if (indexPath.row > 0 && indexPath.row - 1 < self.payStyleShowArray.count) {
                NSDictionary *m_dic = self.payStyleShowArray[indexPath.row - 1];
                NSString *key = m_dic[@"key"];
                if ([self.defaultKeyBoardTypeSet containsObject:key]) {
                    [self.toSaveData setValue:content forKey:key];
                }
                else {
                    [self.toSaveData setValue:[NSString stringWithFormat:@"%d", [content intValue]] forKey:key];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:{
            if (indexPath.row == 1 || indexPath.row == 2) {
                NSDictionary *m_dic = self.feeShowArray[indexPath.row - 1];
                NSString *key = m_dic[@"key"];
                if (key.length) {
                    NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
                    if (dicArray.count) {
                        NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dicArray.count];
                        for (AppDataDictionary *m_data in dicArray) {
                            [m_array addObject:m_data.item_name];
                        }
                        QKWEAKSELF;
                        BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                            if (buttonIndex > 0 && (buttonIndex - 1) < m_array.count) {
                                AppDataDictionary *item = dicArray[buttonIndex - 1];
                                [weakself.toSaveData setValue:item.item_val forKey:key];
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
        }
            break;
            
        default:
            break;
    }
}

- (void)touchRowButtonAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        NSDictionary *m_dic = self.payStyleShowArray[indexPath.row - 1];
        NSString *key = m_dic[@"key"];
        if ([key isEqualToString:@"note"]) {
            NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
            if (dataArray.count) {
                NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dataArray.count];
                for (AppNoteInfo *m_data in dataArray) {
                    [m_array addObject:m_data.note_info];
                }
                QKWEAKSELF;
                BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                    if (buttonIndex > 0 && (buttonIndex - 1) < dataArray.count) {
                        AppNoteInfo *item = dataArray[buttonIndex - 1];
                        [weakself.toSaveData setValue:item.note_info forKey:key];
                        [weakself.tableView reloadData];
                    }
                } otherButtonTitlesArray:m_array];
                [sheet showInView:self.view];
            }
            else {
                [self pullServiceNoteArrayFunctionForCode:key selectionInIndexPath:indexPath];
            }
        }
    }
}

- (void)pushSaveWaybillFunction:(NSDictionary *)parm {
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_saveWaybillFunction" Parm:parm completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1 && item.items.count) {
                AppSaveBackWayBillInfo *info = [AppSaveBackWayBillInfo mj_objectWithKeyValues:item.items[0]];
                [weakself saveWayBillSuccess:info];
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

- (void)saveWayBillSuccess:(AppSaveBackWayBillInfo *)info {
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"运单已保存" message:nil cancelButtonTitle:@"确定" clickButton:^(NSInteger buttonIndex) {
        [weakself clearData];
    } otherButtonTitles:nil];
    [alert show];
}

- (void)clearData {
    _toSaveData = nil;
    _headerView = nil;
    is_update_waybill_item = NO;
    [self.goodsArray removeAllObjects];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self initialDataDictionaryForCodeArray:@[@"receipt_sign_type", @"cash_on_delivery_type"]];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - getter
- (WayBillSRHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [WayBillSRHeaderView new];
        [_headerView.senderButton addTarget:self action:@selector(senderButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.receiverButton addTarget:self action:@selector(receiverButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeightMiddle)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:_footerView.bounds];
        btn.backgroundColor = MainColor;
        btn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
        [btn setTitle:@"保存运单" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
    }
    return _footerView;
}

- (NSMutableArray *)goodsArray {
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray new];
    }
    return _goodsArray;
}

//- (AppGoodsInfo *)goodsSummary {
//    if (!_goodsSummary) {
//        _goodsSummary = [AppGoodsInfo new];
//    }
//    return _goodsSummary;
//}

- (AppSaveWayBillInfo *)toSaveData {
    if (!_toSaveData) {
        _toSaveData = [AppSaveWayBillInfo new];
//        _toSaveData.receipt_sign_type = @"4";
//        _toSaveData.cash_on_delivery_type = @"1";
        _toSaveData.freight = @"0";
        _toSaveData.pay_now_amount = @"0";
        _toSaveData.pay_on_delivery_amount = @"0";
        _toSaveData.pay_on_receipt_amount = @"0";
        _toSaveData.cash_on_delivery_amount = @"0";
        _toSaveData.insurance_amount = @"0";//保价金额
        _toSaveData.insurance_fee = @"0";//保价费
        _toSaveData.take_goods_fee = @"0";//接货费
        _toSaveData.deliver_goods_fee = @"0";//送货费
        _toSaveData.rebate_fee = @"0";//回扣费
        _toSaveData.forklift_fee = @"0";//叉车费
        _toSaveData.transfer_fee = @"0";//中转费
        _toSaveData.pay_for_sb_fee = @"0";//垫付费
        _toSaveData.is_pay_on_delivery = boolString(YES);//默认提付
        _toSaveData.is_pay_now = boolString(NO);
        _toSaveData.is_pay_on_receipt = boolString(NO);
    }
    return _toSaveData;
}

- (UITableViewCell *)tableView:(UITableView *)tableView wayBillTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    WayBillTitleCell *cell = (WayBillTitleCell *)[super tableView:tableView wayBillTitleCellForRowAtIndexPath:indexPath showObject:showObject reuseIdentifier:reuseIdentifier];
    if (indexPath.section == 2) {
        cell.baseView.subTextLabel.text = [NSString stringWithFormat:@"总运费：%@", notNilString(self.toSaveData.total_amount, @"0")];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView switchorCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    SwitchorCell *cell = (SwitchorCell *)[super tableView:tableView switchorCellForRowAtIndexPath:indexPath showObject:showObject reuseIdentifier:reuseIdentifier];
    NSString *key = showObject[@"key"];
    if ([self.switchorSet containsObject:key]) {
        NSString *value = [self.toSaveData valueForKey:key];
        cell.baseView.switchor.on = isTrue(value);
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView singleInputCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    SingleInputCell *cell = (SingleInputCell *)[super tableView:tableView singleInputCellForRowAtIndexPath:indexPath showObject:showObject reuseIdentifier:reuseIdentifier];
    NSString *key = showObject[@"key"];
    if ([self.selectorSet containsObject:key]) {
        cell.baseView.textField.enabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.baseView.textField.text = [UserPublic stringForType:[[self.toSaveData valueForKey:key] integerValue] key:key];
    }
    else {
        NSString *value = [self.toSaveData valueForKey:key];
        if (value) {
            cell.baseView.textField.text = value;
        }
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView switchedInputCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    SwitchedInputCell *cell = (SwitchedInputCell *)[super tableView:tableView switchedInputCellForRowAtIndexPath:indexPath showObject:showObject reuseIdentifier:reuseIdentifier];
    
    NSString *key = showObject[@"key"];
    NSString *value = [self.toSaveData valueForKey:key];
    if (value) {
        cell.baseView.textField.text = value;
    }
    
    NSString *subKey = showObject[@"subKey"];
    NSString *subValue = [self.toSaveData valueForKey:subKey];
    if (subValue) {
        BOOL yn = isTrue(subValue);
        cell.baseView.checkBtn.selected = yn;
        cell.baseView.textField.hidden = !yn;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView doubleInputCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    NSArray *m_array = showObject;
    DoubleInputCell *cell = (DoubleInputCell *)[super tableView:tableView doubleInputCellForRowAtIndexPath:indexPath showObject:showObject reuseIdentifier:reuseIdentifier];
    NSDictionary *m_dic1 = m_array[0];
    NSDictionary *m_dic2 = m_array[1];
    NSString *key1 = m_dic1[@"key"];
    NSString *value1 = [self.toSaveData valueForKey:key1];
    if (value1) {
        cell.baseView.textField.text = [NSString stringWithFormat:@"%d", [value1 intValue]];
    }
    NSString *key2 = m_dic2[@"key"];
    NSString *value2 = [self.toSaveData valueForKey:key2];
    if (value2) {
        cell.anotherBaseView.textField.text = [NSString stringWithFormat:@"%d", [value2 intValue]];
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView commonInputCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    SingleInputCell *cell = (SingleInputCell *)[super tableView:tableView commonInputCellForRowAtIndexPath:indexPath showObject:showObject reuseIdentifier:reuseIdentifier];
    NSString *key = showObject[@"key"];
    NSString *value = [self.toSaveData valueForKey:key];
    if (value) {
        cell.baseView.textField.text = value;
    }
    return cell;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rows = 0;
    switch (section) {
        case 0:{
            rows = 1 + 1 + self.goodsArray.count;
        }
            break;
            
        case 1:{
            rows = 1 + self.feeShowArray.count;
        }
            break;
            
        case 2:{
            rows = 1 + self.payStyleShowArray.count;
        }
            break;
            
        default:
            break;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return kEdgeHuge;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = kCellHeightFilter;
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                
            }
            else if (self.goodsArray.count == 0) {
                rowHeight = 114.0;
            }
            else if (indexPath.row == self.goodsArray.count + 1) {
                rowHeight = [GoodsSummaryCell tableView:tableView heightForRowAtIndexPath:indexPath];
            }
            else {
                rowHeight = [FourItemsDoubleListCell tableView:tableView heightForRowAtIndexPath:indexPath];
            }
        }
            break;
            
        case 1:{
            if (indexPath.row == 0) {
                
            }
            else if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
                rowHeight += kEdge;
            }
            else {
                
            }
        }
            break;
            
        case 2:{
            if (indexPath.row == 0) {
                
            }
            else if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
                rowHeight += kEdge;
            }
            else {
                
            }
        }
            break;
            
        default:
            break;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"goods_title_cell_add";
                return [self tableView:tableView wayBillTitleCellForRowAtIndexPath:indexPath showObject:@"货物信息" reuseIdentifier:CellIdentifier];
            }
            else if (self.goodsArray.count == 0) {
                static NSString *CellIdentifier = @"no_goods_cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.textColor = secondaryTextColor;
                    cell.textLabel.font = [AppPublic appFontOfSize:appLabelFontSize];
                }
                
                cell.textLabel.text = @"尚未添加货物";
                
                return cell;
            }
            else if (indexPath.row == self.goodsArray.count + 1) {
                static NSString *CellIdentifier = @"goods_summary_cell";
                GoodsSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell) {
                    cell = [[GoodsSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
                    
                    self.summaryFreightTextField = (IndexPathTextField *)cell.showArray[1];
                    self.summaryFreightTextField.delegate = self;
                    [self.summaryFreightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    self.summaryFreightTextField.indexPath = indexPath;
                }
                
                [cell addShowContents:@[@"运费：",
                                        self.toSaveData.freight,
                                        @"总数：",
                                        [NSString stringWithFormat:@"%@/%@/%@", notShowFooterZeroString(self.toSaveData.goods_total_count, @"0"), notShowFooterZeroString(self.toSaveData.goods_total_weight, @"0"), notShowFooterZeroString(self.toSaveData.goods_total_volume, @"0")]]];
                return cell;
            }
            else {
                static NSString *CellIdentifier = @"goods_item_cell";
                FourItemsDoubleListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell) {
                    cell = [[FourItemsDoubleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
                    cell.backgroundColor = [UIColor whiteColor];
                }
                
                AppGoodsInfo *item = self.goodsArray[indexPath.row - 1];
                [cell addShowContents:@[[NSString stringWithFormat:@"品名%@", indexChineseString(indexPath.row)],
                                        notNilString(item.goods_name, nil),
                                        @"包装",
                                        notNilString(item.packge, nil),
                                        @"件/吨/方",
                                        [NSString stringWithFormat:@"%@/%@/%@", item.number, item.weight, item.volume],
                                        @"运费",
                                        [NSString stringWithFormat:@"%@", item.freight]]];
                
                return cell;
            }
        }
            break;
            
        case 1:{
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"fee_title_cell";
                return [self tableView:tableView wayBillTitleCellForRowAtIndexPath:indexPath showObject:@"费用信息" reuseIdentifier:CellIdentifier];
            }
            else {
                id object = self.feeShowArray[indexPath.row - 1];
                if ([object isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *m_dic = object;
                    NSString *key = m_dic[@"key"];
                    
                    if ([self.switchorSet containsObject:key]) {static NSString *CellIdentifier = @"fee_edit_switchor_cell";
                        return [self tableView:tableView switchorCellForRowAtIndexPath:indexPath showObject:m_dic reuseIdentifier:CellIdentifier];
                    }
                    else {
                        static NSString *CellIdentifier = @"fee_edit_cell";
                        return [self tableView:tableView singleInputCellForRowAtIndexPath:indexPath showObject:m_dic reuseIdentifier:CellIdentifier];
                    }
                }
                else if ([object isKindOfClass:[NSArray class]]){
                    NSArray *m_array = (NSArray *)object;
                    if (m_array.count == 2) {
                        static NSString *CellIdentifier = @"double_cell";
                        return [self tableView:tableView doubleInputCellForRowAtIndexPath:indexPath showObject:m_array reuseIdentifier:CellIdentifier];
                    }
                }
            }
        }
            break;
            
        case 2:{
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"pay_sytle_title_cell";
                return [self tableView:tableView wayBillTitleCellForRowAtIndexPath:indexPath showObject:@"结算方式" reuseIdentifier:CellIdentifier];
            }
            else {
                id object = self.payStyleShowArray[indexPath.row - 1];
                if ([object isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *m_dic = object;
                    NSString *key = m_dic[@"key"];
                    if ([self.inputForSelectorSet containsObject:key]) {
                        static NSString *CellIdentifier = @"pay_style_switchedInput_cell";
                        return [self tableView:tableView switchedInputCellForRowAtIndexPath:indexPath showObject:m_dic reuseIdentifier:CellIdentifier];
                    }
                    else if ([key isEqualToString:@"note"]) {
                        static NSString *CellIdentifier = @"note_cell";
                        return [self tableView:tableView commonInputCellForRowAtIndexPath:indexPath showObject:m_dic reuseIdentifier:CellIdentifier];
                    }
                    else {
                        static NSString *CellIdentifier = @"pay_style_edit_cell";
                        return [self tableView:tableView singleInputCellForRowAtIndexPath:indexPath showObject:m_dic reuseIdentifier:CellIdentifier];
                    }
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self selectRowAtIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.goodsArray.count > 0) {
        if (indexPath.row > 0 && indexPath.row < self.goodsArray.count + 1) {
            return YES;
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.goodsArray.count > 0) {
        if (indexPath.row > 0 && indexPath.row < self.goodsArray.count + 1) {
            if (editingStyle == UITableViewCellEditingStyleDelete) {
                [self removeGoodsAtIndex:indexPath.row - 1];
            }
        }
    }
    
}

#pragma  mark - TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSInteger length = kInputLengthMax;
    if ([textField isKindOfClass:[IndexPathTextField class]]) {
        IndexPathTextField *m_textField = (IndexPathTextField *)textField;
        switch (m_textField.indexPath.section) {
            case 0:{
                length = kPriceLengthMax;
            }
                break;
                
            default:
                break;
        }
    }
    
    return (range.location < length);
}

@end
