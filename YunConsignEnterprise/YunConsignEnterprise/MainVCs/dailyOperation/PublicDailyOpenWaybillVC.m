//
//  PublicDailyOpenWaybillVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicDailyOpenWaybillVC.h"

@interface PublicDailyOpenWaybillVC ()

@end

@implementation PublicDailyOpenWaybillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addGoodsButtonAction {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView wayBillTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    WayBillTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[WayBillTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.section) {
            case 0:{
                if ([reuseIdentifier hasSuffix:@"add"]) {
                    UIButton *addGoodsBtn = [[UIButton alloc] initWithFrame:CGRectMake(screen_width - 100, 0, 120, [self tableView:tableView heightForRowAtIndexPath:indexPath])];
                    [addGoodsBtn setImage:[UIImage imageNamed:@"list_icon_add"] forState:UIControlStateNormal];
                    [addGoodsBtn setTitle:@"  添加" forState:UIControlStateNormal];
                    [addGoodsBtn setTitleColor:MainColor forState:UIControlStateNormal];
                    addGoodsBtn.titleLabel.font = [AppPublic appFontOfSize:appButtonTitleFontSize];
                    [addGoodsBtn addTarget:self action:@selector(addGoodsButtonAction) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:addGoodsBtn];
                }
            }
                break;
                
            default:
                break;
        }
    }
    
    cell.baseView.textLabel.text = showObject;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView switchorCellForRowAtIndexPath:(NSIndexPath *)indexPath showObject:(id)showObject reuseIdentifier:(NSString *)reuseIdentifier {
    SwitchorCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[SwitchorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
        [cell.baseView.switchor addTarget:self action:@selector(switchorButtonAction:) forControlEvents:UIControlEventValueChanged];
    }
    
    cell.baseView.textLabel.text = showObject[@"title"];
    cell.baseView.switchor.indexPath = [indexPath copy];
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
    BOOL isKeybordDefault = [self.defaultKeyBoardTypeSet containsObject:key];
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
    cell.baseView.checkBtn.selected = NO;
    
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
    NSString *key2 = m_dic2[@"key"];
    cell.anotherBaseView.textField.enabled = ![self.inputInvalidSet containsObject:key2];
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    
    return cell;
}

#pragma mark - getter
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

- (NSSet *)defaultKeyBoardTypeSet {
    if (!_defaultKeyBoardTypeSet) {
        _defaultKeyBoardTypeSet = [NSSet setWithObjects:@"note", @"inner_note", @"change_cause", nil];
    }
    
    return _defaultKeyBoardTypeSet;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return kEdge;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdge;
}

@end