//
//  WayBillOpenVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillOpenVC.h"
#import "PublicSRSelectVC.h"
#import "AddGoodsVC.h"

#import "BlockAlertView.h"
#import "BlockActionSheet.h"
#import "WayBillSRHeaderView.h"
#import "WayBillTitleCell.h"
#import "FourItemsDoubleListCell.h"
#import "GoodsSummaryCell.h"
#import "SingleInputCell.h"
#import "DoubleInputCell.h"
#import "SwitchorCell.h"
#import "SwitchedInputCell.h"

@interface WayBillOpenVC ()<UITextFieldDelegate>

@property (strong, nonatomic) WayBillSRHeaderView *headerView;
@property (strong, nonatomic) UIView *footerView;

@property (strong, nonatomic) NSMutableArray *goodsArray;
@property (strong, nonatomic) AppGoodsInfo *goodsSummary;
@property (strong, nonatomic) NSArray *feeShowArray;
@property (strong, nonatomic) NSArray *payStyleShowArray;

@property (strong, nonatomic) NSSet *selectorSet;
@property (strong, nonatomic) NSSet *inputForSelectorSet;
@property (strong, nonatomic) NSSet *switchorSet;
@property (strong, nonatomic) NSSet *inputInvalidSet;

@property (strong, nonatomic) IndexPathTextField *summaryFreightTextField;
@property (strong, nonatomic) UILabel *totalAmountLabel;

@property (strong, nonatomic) AppSaveWayBillInfo *data;

@end

@implementation WayBillOpenVC

- (void)dealloc {
    [self.data removeObserver:self forKeyPath:@"total_amount"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    [self.data addObserver:self forKeyPath:@"total_amount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
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
        [self.data appendSenderInfo:self.headerView.senderInfo];
    }
    
    if (!self.headerView.receiverInfo) {
        [self showHint:@"请补全收货人信息"];
        return;
    }
    else {
        [self.data appendReceiverInfo:self.headerView.receiverInfo];
    }
    
    if (!self.goodsArray.count) {
        [self showHint:@"请添加货物信息"];
        return;
    }
    else {
        self.data.waybill_items = [[AppGoodsInfo mj_keyValuesArrayWithObjectArray:self.goodsArray] mj_JSONString];
    }
    
//    long long amount = [self.data.total_amount longLongValue];
//    long long payNowAmount = self.data.is_pay_now ? [self.data.pay_now_amount longLongValue] : 0LL;
//    long long payOnReceiptAmount = self.data.is_pay_on_receipt ? [self.data.pay_on_receipt_amount longLongValue] : 0LL;
//    long long payOnDeliveryAmount = self.data.is_pay_on_delivery ? [self.data.pay_on_delivery_amount longLongValue] : 0LL;
//    if (amount != payNowAmount + payOnReceiptAmount + payOnDeliveryAmount) {
//        [self showHint:@"总费用不等于现付提付回单付的和，请检查"];
//        return;
//    }
    
    self.data.consignment_time = stringFromDate(self.headerView.date, @"yyyy-MM-dd");
    [self pushSaveWaybillFunction:self.data];
}

- (void)addGoodsButtonAction {
    if (!self.headerView.senderInfo) {
        [self showHint:@"请补全发货人信息"];
        return;
    }
    AddGoodsVC *vc = [AddGoodsVC new];
    vc.senderInfo = [self.headerView.senderInfo copy];
    QKWEAKSELF;
    vc.doneBlock = ^(id object){
        if ([object isKindOfClass:[AppGoodsInfo class]]) {
            AppGoodsInfo *item = (AppGoodsInfo *)object;
            [weakself.goodsArray addObject:item];
            [weakself caclateGoodsSummary];
            [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            weakself.data.freight = [NSString stringWithFormat:@"%lld", weakself.goodsSummary.freight];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkButtonAction:(IndexPathButton *)button {
    if (button.indexPath.section == 2) {
        NSDictionary *m_dic = self.payStyleShowArray[button.indexPath.row - 1];
        [self.data setValue:@(!button.selected) forKey:m_dic[@"subKey"]];
        [self.tableView reloadRowsAtIndexPaths:@[button.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)removeGoodsAtIndex:(NSUInteger)index {
    if (index < self.goodsArray.count) {
        [self.goodsArray removeObjectAtIndex:index];
        [self caclateGoodsSummary];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        self.data.freight = [NSString stringWithFormat:@"%lld", self.goodsSummary.freight];
    }
}

- (void)caclateGoodsSummary {
    _goodsSummary = nil;
    for (AppGoodsInfo *item in self.goodsArray) {
        self.goodsSummary.freight += item.freight;
        self.goodsSummary.number += item.number;
        self.goodsSummary.weight += item.weight;
        self.goodsSummary.volume += item.volume;
    }
}

- (void)editAtIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag andContent:(NSString *)content {
    switch (indexPath.section) {
        case 0: {
            self.goodsSummary.freight = [content longLongValue];
            self.data.freight = [NSString stringWithFormat:@"%lld", self.goodsSummary.freight];
        }
            break;
            
        case 1: {
            if (indexPath.row > 0 && indexPath.row - 1 < self.feeShowArray.count) {
                id object = self.feeShowArray[indexPath.row - 1];
                if ([object isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *m_dic = object;
                    [self.data setValue:[NSString stringWithFormat:@"%d", [content intValue]] forKey:m_dic[@"key"]];
                }
                else if ([object isKindOfClass:[NSArray class]]) {
                    NSArray *m_array = object;
                    if (m_array.count == 2 && tag >= 0 && tag <= 1) {
                        NSDictionary *m_dic = m_array[tag];
                        int value = [content intValue];
                        [self.data setValue:[NSString stringWithFormat:@"%d", value] forKey:m_dic[@"key"]];
                        NSString *key = m_dic[@"key"];
                        if ([key isEqualToString:@"insurance_amount"]) {
                            self.data.insurance_fee = [NSString stringWithFormat:@"%.0f", floor(value * 0.03)];
                            DoubleInputCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                            cell.anotherBaseView.textField.text = self.data.insurance_fee;
                        }
                    }
                }
            }
        }
            break;
            
        case 2: {
            if (indexPath.row > 0 && indexPath.row - 1 < self.payStyleShowArray.count) {
                NSDictionary *m_dic = self.payStyleShowArray[indexPath.row - 1];
                NSString *key = m_dic[@"key"];
                if ([key isEqualToString:@"note"] || [key isEqualToString:@"inner_note"]) {
                    [self.data setValue:content forKey:key];
                }
                else {
                    [self.data setValue:[NSString stringWithFormat:@"%d", [content intValue]] forKey:key];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)pushSaveWaybillFunction:(AppSaveWayBillInfo *)saveInfo {
    [self showHudInView:self.view hint:nil];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_saveWaybillFunction" Parm:[saveInfo app_keyValues] completion:^(id responseBody, NSError *error){
        [weakself hideHud];
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
        [weakself goBack];
    } otherButtonTitles:nil];
    [alert show];
}

#pragma mark - getter
- (WayBillSRHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WayBillSRHeaderView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 160 + kEdge)];
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

- (AppGoodsInfo *)goodsSummary {
    if (!_goodsSummary) {
        _goodsSummary = [AppGoodsInfo new];
    }
    return _goodsSummary;
}

- (NSArray *)feeShowArray {
    if (!_feeShowArray) {
        _feeShowArray = @[@{@"title":@"回单",@"subTitle":@"请选择",@"key":@"receipt_sign_type"},
                          @{@"title":@"代收款",@"subTitle":@"请选择",@"key":@"cash_on_delivery_type"},
                          @{@"title":@"代收款金额",@"subTitle":@"请输入",@"key":@"cash_on_delivery_amount"},
                          @{@"title":@"运费代扣",@"subTitle":@"请选择",@"key":@"is_deduction_freight"},
                          @{@"title":@"急货",@"subTitle":@"请选择",@"key":@"is_urgent"},
                          @{@"title":@"叉车费",@"subTitle":@"请输入",@"key":@"forklift_fee"},
                          @[@{@"title":@"保价",@"subTitle":@"请输入",@"key":@"insurance_amount"},
                            @{@"title":@"保价费",@"subTitle":@"请输入",@"key":@"insurance_fee"}],
                          @[@{@"title":@"接货费",@"subTitle":@"请输入",@"key":@"take_goods_fee"},
                            @{@"title":@"送货费",@"subTitle":@"请输入",@"key":@"deliver_goods_fee"}],
                          @[@{@"title":@"回扣费",@"subTitle":@"请输入",@"key":@"rebate_fee"},
                            @{@"title":@"垫付费",@"subTitle":@"请输入",@"key":@"pay_for_sb_fee"}],];
    }
    return _feeShowArray;
}

- (NSArray *)payStyleShowArray {
    if (!_payStyleShowArray) {
        _payStyleShowArray = @[@{@"title":@"现付",@"subTitle":@"请输入",@"key":@"pay_now_amount",@"subKey":@"is_pay_now"},
                               @{@"title":@"提付",@"subTitle":@"请输入",@"key":@"pay_on_delivery_amount",@"subKey":@"is_pay_on_delivery"},
                               @{@"title":@"回单付",@"subTitle":@"请输入",@"key":@"pay_on_receipt_amount",@"subKey":@"is_pay_on_receipt"},
                               @{@"title":@"运单备注",@"subTitle":@"无",@"key":@"note"},
                               @{@"title":@"内部备注",@"subTitle":@"无",@"key":@"inner_note"},];
    }
    return _payStyleShowArray;
}

- (NSSet *)selectorSet {
    if (!_selectorSet) {
        _selectorSet = [NSSet setWithObjects:@"receipt_sign_type", @"cash_on_delivery_type", nil];
    }
    
    return _selectorSet;
}

- (NSSet *)inputForSelectorSet {
    if (!_inputForSelectorSet) {
        _inputForSelectorSet = [NSSet setWithObjects:@"pay_now_amount", @"pay_on_delivery_amount", @"pay_on_receipt_amount", nil];
    }
    return _inputForSelectorSet;
}

- (NSSet *)switchorSet {
    if (!_switchorSet) {
        _switchorSet = [NSSet setWithObjects:@"is_deduction_freight", @"is_urgent", nil];
    }
    
    return _switchorSet;
}

- (NSSet *)inputInvalidSet {
    if (!_inputInvalidSet) {
        _inputInvalidSet = [NSSet setWithObjects:@"insurance_fee", nil];
    }
    
    return _inputInvalidSet;
}

- (AppSaveWayBillInfo *)data {
    if (!_data) {
        _data = [AppSaveWayBillInfo new];
        _data.receipt_sign_type = [NSString stringWithFormat:@"%d", (int)RECEIPT_SIGN_TYPE_4];
        _data.cash_on_delivery_type = [NSString stringWithFormat:@"%d", (int)CASH_ON_DELIVERY_TYPE_1];
        _data.freight = @"0";
        _data.pay_now_amount = @"0";
        _data.pay_on_delivery_amount = @"0";
        _data.pay_on_receipt_amount = @"0";
        _data.cash_on_delivery_amount = @"0";
//        _data.insurance_amount = @"0";//保价金额
        _data.insurance_fee = @"0";//保价费
        _data.take_goods_fee = @"0";//接货费
        _data.deliver_goods_fee = @"0";//送货费
        _data.rebate_fee = @"0";//回扣费
        _data.forklift_fee = @"0";//叉车费
        _data.pay_for_sb_fee = @"0";//垫付费
        _data.is_pay_on_delivery = YES;
    }
    return _data;
}

- (UITableViewCell *)tableView:(UITableView *)tableView switchorCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    SwitchorCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[SwitchorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
    }
    
    cell.baseView.textLabel.text = showObject[@"title"];
    return cell;
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
    cell.baseView.textField.indexPath = [indexPath copy];
    cell.baseView.textField.enabled = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSString *key = showObject[@"key"];
    if ([self.selectorSet containsObject:key]) {
        cell.baseView.textField.enabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.baseView.textField.text = [UserPublic stringForType:[[self.data valueForKey:key] integerValue] key:key];
    }
    else {
        NSString *value = [self.data valueForKey:key];
        if (value) {
            cell.baseView.textField.text = value;
        }
    }
    BOOL isKeybordDefault = [key isEqualToString:@"note"] || [key isEqualToString:@"inner_note"];
    cell.baseView.textField.keyboardType = isKeybordDefault ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView switchedInputCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    SwitchedInputCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[SwitchedInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
//        [cell.baseView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        cell.baseView.textField.delegate = self;
        cell.baseView.textField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.baseView.checkBtn addTarget:self action:@selector(checkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.baseView.textLabel.text = showObject[@"title"];
    cell.baseView.textField.placeholder = showObject[@"subTitle"];
    cell.baseView.textField.text = @"";
    cell.baseView.textField.indexPath = [indexPath copy];
    cell.baseView.textField.hidden = YES;
    cell.baseView.checkBtn.indexPath = [indexPath copy];
    
    NSString *key = showObject[@"key"];
    NSString *value = [self.data valueForKey:key];
    if (value) {
        cell.baseView.textField.text = value;
    }
    
    NSString *subKey = showObject[@"subKey"];
    NSString *subValue = [self.data valueForKey:subKey];
    if (subValue) {
        BOOL yn = [subValue boolValue];
        cell.baseView.checkBtn.selected = yn;
        cell.baseView.textField.hidden = !yn;
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
    NSString *value1 = [self.data valueForKey:key1];
    if (value1) {
        cell.baseView.textField.text = value1;
    }
    
    NSString *key2 = m_dic2[@"key"];
    NSString *value2 = [self.data valueForKey:key2];
    if (value2) {
        cell.anotherBaseView.textField.text = value2;
    }
    
    cell.anotherBaseView.textField.enabled = ![self.inputInvalidSet containsObject:key2];
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView wayBillTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    WayBillTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[WayBillTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.section) {
            case 0:{
                UIButton *addGoodsBtn = [[UIButton alloc] initWithFrame:CGRectMake(screen_width - 100, 0, 120, [self tableView:tableView heightForRowAtIndexPath:indexPath])];
                [addGoodsBtn setImage:[UIImage imageNamed:@"list_icon_add"] forState:UIControlStateNormal];
                [addGoodsBtn setTitle:@"  添加" forState:UIControlStateNormal];
                [addGoodsBtn setTitleColor:MainColor forState:UIControlStateNormal];
                addGoodsBtn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
                [addGoodsBtn addTarget:self action:@selector(addGoodsButtonAction) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:addGoodsBtn];
            }
                break;
                
            case 2:{
                if (!_totalAmountLabel) {
                    _totalAmountLabel = NewLabel(CGRectMake(0, 0, 200, [self tableView:tableView heightForRowAtIndexPath:indexPath]), nil, nil, NSTextAlignmentRight);
                    _totalAmountLabel.right = screen_width - kEdgeMiddle;
                }
                [cell.contentView addSubview:self.totalAmountLabel];
            }
                break;
                
            default:
                break;
        }
    }
    
    cell.textLabel.text = showObject;
    if (indexPath.section == 2) {
        self.totalAmountLabel.text = [NSString stringWithFormat:@"总费用：%@", self.data.total_amount];
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
                static NSString *CellIdentifier = @"goods_title_cell";
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
                    
                    _summaryFreightTextField = (IndexPathTextField *)cell.showArray[1];
                    _summaryFreightTextField.delegate = self;
                    [_summaryFreightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    _summaryFreightTextField.indexPath = indexPath;
                }
                
                AppGoodsInfo *item = self.goodsSummary;
                [cell addShowContents:@[@"运费：",
                                        [NSString stringWithFormat:@"%lld", item.freight],
                                        @"总数：",
                                        [NSString stringWithFormat:@"%d/%.1f/%.1f", item.number, item.weight, item.volume]]];
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
                                        notNilString(item.goods_name),
                                        @"包装",
                                        notNilString(item.packge),
                                        @"件/吨/方",
                                        [NSString stringWithFormat:@"%d/%.1f/%.1f", item.number, item.weight, item.volume],
                                        @"运费",
                                        [NSString stringWithFormat:@"%lld", item.freight]]];
                
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
    switch (indexPath.section) {
        case 1:{
            if (indexPath.row == 1) {
                NSArray *m_array = [UserPublic getInstance].receptSignTypeArray;
                QKWEAKSELF;
                BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                    if (buttonIndex > 0 && (buttonIndex - 1) < m_array.count) {
                        weakself.data.receipt_sign_type = [NSString stringWithFormat:@"%d", (int)buttonIndex];
                        [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                } otherButtonTitlesArray:m_array];
                [sheet showInView:self.view];
            }
            else if (indexPath.row == 2) {
                NSArray *m_array = [UserPublic getInstance].cashOnDeliveryTypeArray;
                QKWEAKSELF;
                BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                    if (buttonIndex > 0 && (buttonIndex - 1) < m_array.count) {
                        weakself.data.cash_on_delivery_type = [NSString stringWithFormat:@"%d", (int)buttonIndex];
                        [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                } otherButtonTitlesArray:m_array];
                [sheet showInView:self.view];
            }
        }
            break;
            
        default:
            break;
    }
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

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"total_amount"]) {
        long long amount = [self.data.total_amount longLongValue];
        long long payNowAmount = self.data.is_pay_now ? [self.data.pay_now_amount longLongValue] : 0LL;
        long long payOnReceiptAmount = self.data.is_pay_on_receipt ? [self.data.pay_on_receipt_amount longLongValue] : 0LL;
        self.data.pay_on_delivery_amount = [NSString stringWithFormat:@"%lld", MAX(0, amount - payNowAmount - payOnReceiptAmount)];
        
        self.totalAmountLabel.text = [NSString stringWithFormat:@"总费用：%@", self.data.total_amount];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end