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

#import "BlockActionSheet.h"
#import "WayBillSRHeaderView.h"
#import "WayBillTitleCell.h"
#import "FourItemsDoubleListCell.h"
#import "GoodsSummaryCell.h"
#import "SingleInputCell.h"
#import "DoubleInputCell.h"

@interface WayBillOpenVC ()<UITextFieldDelegate>

@property (strong, nonatomic) WayBillSRHeaderView *headerView;
@property (strong, nonatomic) UIView *footerView;

@property (strong, nonatomic) NSMutableArray *goodsArray;
@property (strong, nonatomic) AppGoodsInfo *goodsSummary;
@property (strong, nonatomic) NSArray *feeShowArray;
@property (strong, nonatomic) NSArray *payStyleShowArray;

@property (strong, nonatomic) NSSet *selectorSet;
@property (strong, nonatomic) NSSet *inputInvalidSet;

@property (strong, nonatomic) UITextField *summaryFreightTextField;
@property (strong, nonatomic) UILabel *summaryFreightLabel;

@property (strong, nonatomic) AppWayBillInfo *data;

@end

@implementation WayBillOpenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
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
            weakself.goodsSummary.freight += item.freight;
            weakself.goodsSummary.number += item.number;
            weakself.goodsSummary.weight += item.weight;
            weakself.goodsSummary.volume += item.volume;
            [weakself.goodsArray addObject:item];
            [weakself.tableView reloadData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)removeGoodsAtIndex:(NSUInteger)index {
    if (index < self.goodsArray.count) {
        [self.goodsArray removeObjectAtIndex:index];
        [self caclateGoodsSummary];
        [self.tableView reloadData];
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

#pragma mark - getter
- (WayBillSRHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WayBillSRHeaderView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 160)];
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
                          @[@{@"title":@"报价",@"subTitle":@"请输入",@"key":@"insurance_amount"},
                            @{@"title":@"报价费",@"subTitle":@"请输入",@"key":@"insurance_fee"}],
                          @[@{@"title":@"接货费",@"subTitle":@"请输入",@"key":@"take_goods_fee"},
                            @{@"title":@"送货费",@"subTitle":@"请输入",@"key":@"deliver_goods_fee"}],
                          @[@{@"title":@"回扣费",@"subTitle":@"请输入",@"key":@"rebate_fee"},
                            @{@"title":@"垫付费",@"subTitle":@"请输入",@"key":@"pay_for_sb_fee"}],];
    }
    return _feeShowArray;
}

- (NSArray *)payStyleShowArray {
    if (!_payStyleShowArray) {
        _payStyleShowArray = @[@{@"title":@"现付",@"subTitle":@"请输入",@"key":@"pay_now_amount"},
                               @{@"title":@"提付",@"subTitle":@"请输入",@"key":@"pay_on_delivery_amount"},
                               @{@"title":@"回单付",@"subTitle":@"请输入",@"key":@"pay_on_receipt_amount"},
                               @{@"title":@"运单备注",@"subTitle":@"请输入",@"key":@"note"},
                               @{@"title":@"内部备注",@"subTitle":@"请输入",@"key":@"inner_note"},];
    }
    return _payStyleShowArray;
}

- (NSSet *)selectorSet{
    if (!_selectorSet) {
        _selectorSet = [NSSet setWithObjects:@"receipt_sign_type", @"cash_on_delivery_type", nil];
    }
    
    return _selectorSet;
}

- (NSSet *)inputInvalidSet{
    if (!_inputInvalidSet) {
        _inputInvalidSet = [NSSet setWithObjects:@"is_deduction_freight", @"is_urgent", nil];
    }
    
    return _inputInvalidSet;
}

- (AppWayBillInfo *)data {
    if (!_data) {
        _data = [AppWayBillInfo new];
        _data.receipt_sign_type = RECEIPT_SIGN_TYPE_4;
        _data.cash_on_delivery_type = CASH_ON_DELIVERY_TYPE_1;
    }
    return _data;
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
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0){
//        return nil;
//    }
//    
//    UIView *contentView = [[UIView alloc] init];
//    [contentView setBackgroundColor:[UIColor whiteColor]];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kEdge, 0, screen_width - 2 * kEdge, kCellHeight)];
//    label.font = [UIFont systemFontOfSize:16.0];
//    
//    if (section == 1) {
//        label.text = @"应用管理";
//    }
//    else if (section == 2) {
//        label.text = @"统计报表";
//    }
//    
//    [contentView addSubview:label];
//    return contentView;
//}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"goods_title_cell";
                WayBillTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (!cell) {
                    cell = [[WayBillTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UIButton *addGoodsBtn = [[UIButton alloc] initWithFrame:CGRectMake(screen_width - 100, 0, 120, [self tableView:tableView heightForRowAtIndexPath:indexPath])];
                    [addGoodsBtn setImage:[UIImage imageNamed:@"list_icon_add"] forState:UIControlStateNormal];
                    [addGoodsBtn setTitle:@"  添加" forState:UIControlStateNormal];
                    [addGoodsBtn setTitleColor:MainColor forState:UIControlStateNormal];
                    addGoodsBtn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
                    [addGoodsBtn addTarget:self action:@selector(addGoodsButtonAction) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:addGoodsBtn];
                }
                
                cell.textLabel.text = @"货物信息";
                
                return cell;
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
                    
                    _summaryFreightTextField = (UITextField *)cell.showArray[1];
                    _summaryFreightTextField.delegate = self;
                    [_summaryFreightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
                WayBillTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (!cell) {
                    cell = [[WayBillTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cell.textLabel.text = @"费用信息";
                
                return cell;
            }
            else {
                id object = self.feeShowArray[indexPath.row - 1];
                if ([object isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *m_dic = object;
                    NSString *key = m_dic[@"key"];
                    
                    static NSString *CellIdentifier = @"fee_edit_cell";
                    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (!cell) {
                        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
                        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
                    }
                    
                    cell.inputView.textLabel.text = m_dic[@"title"];
                    cell.inputView.textField.placeholder = m_dic[@"subTitle"];
                    cell.inputView.textField.text = @"";
                    cell.inputView.textField.indexPath = [indexPath copy];
                    if (indexPath.row == 1) {
                        cell.inputView.textField.text = [UserPublic stringForReceptSignType:self.data.receipt_sign_type];
                    }
                    else if (indexPath.row == 2) {
                        cell.inputView.textField.text = [UserPublic stringForCashOnDeliveryType:self.data.cash_on_delivery_type];
                    }
                    
                    cell.accessoryType = [self.selectorSet containsObject:key] ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
                    cell.inputView.textField.enabled = !([self.selectorSet containsObject:key] || [self.inputInvalidSet containsObject:key]);
                    
                    return cell;
                }
                else if ([object isKindOfClass:[NSArray class]]){
                    NSArray *m_array = (NSArray *)object;
                    if (m_array.count == 2) {
                        static NSString *CellIdentifier = @"double_cell";
                        DoubleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (!cell) {
                            cell = [[DoubleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            [cell.inputView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                            [cell.anotherInputView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                            cell.inputView.textField.delegate = self;
                            cell.anotherInputView.textField.delegate = self;
                            cell.inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
                            cell.anotherInputView.textField.keyboardType = UIKeyboardTypeNumberPad;
                            cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
                        }
                        NSDictionary *m_dic1 = m_array[0];
                        NSDictionary *m_dic2 = m_array[1];
                        cell.inputView.textLabel.text = m_dic1[@"title"];
                        cell.inputView.textField.placeholder = m_dic1[@"subTitle"];
                        cell.inputView.textField.text = @"";
                        cell.inputView.textField.indexPath = [indexPath copy];
                        
                        cell.anotherInputView.textLabel.text = m_dic2[@"title"];
                        cell.anotherInputView.textField.placeholder = m_dic2[@"subTitle"];
                        cell.anotherInputView.textField.text = @"";
                        cell.anotherInputView.textField.indexPath = [indexPath copy];
                        
                        cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
                        
                        return cell;
                    }
                }
            }
        }
            break;
            
        case 2:{
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"pay_sytle_title_cell";
                WayBillTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (!cell) {
                    cell = [[WayBillTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    _summaryFreightLabel = NewLabel(CGRectMake(0, 0, 200, [self tableView:tableView heightForRowAtIndexPath:indexPath]), nil, nil, NSTextAlignmentRight);
                    _summaryFreightLabel.right = screen_width - kEdgeMiddle;
                    [cell.contentView addSubview:_summaryFreightLabel];
                }
                
                cell.textLabel.text = @"结算方式";
                _summaryFreightLabel.text = [NSString stringWithFormat:@"总运费：%lld", self.goodsSummary.freight];
                
                return cell;
            }
            else {
                id object = self.payStyleShowArray[indexPath.row - 1];
                if ([object isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *m_dic = object;
                    NSString *key = m_dic[@"key"];
                    
                    static NSString *CellIdentifier = @"pay_style_cell";
                    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (!cell) {
                        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
                        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
                    }
                    
                    cell.inputView.textLabel.text = m_dic[@"title"];
                    cell.inputView.textField.placeholder = m_dic[@"subTitle"];
                    cell.inputView.textField.text = @"";
                    cell.inputView.textField.indexPath = [indexPath copy];
                    
                    
                    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
                    
                    return cell;
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    static NSString *CellIdentifier = @"wayBill_cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
    }
//
//    cell.tag = indexPath.section;
//    cell.data = self.showArrays[indexPath.section];
//    
    return cell;
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
                        weakself.data.receipt_sign_type = buttonIndex;
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
                        weakself.data.cash_on_delivery_type = buttonIndex;
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
        IndexPathTextField *m_textField = (IndexPathTextField *)textField;
        switch (m_textField.indexPath.section) {
            case 0:{
                self.goodsSummary.freight = [textField.text longLongValue];
                _summaryFreightLabel.text = [NSString stringWithFormat:@"总运费：%lld", self.goodsSummary.freight];
            }
                break;
                
            default:
                break;
        }
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

@end
