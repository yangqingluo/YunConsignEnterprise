//
//  CustomerEditVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CustomerEditVC.h"

#import "WaybillCustReceiveCell.h"
#import "SingleInputCell.h"
#import "BlockActionSheet.h"

@interface CustomerEditVC ()<UITextFieldDelegate>

@property (strong, nonatomic) AppCustomerDetailInfo *toSaveData;

@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) NSSet *defaultKeyBoardTypeSet;
@property (strong, nonatomic) NSSet *selectorSet;

@end

@implementation CustomerEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
}

- (void)setupNav {
    [self createNavWithTitle:@"编辑" createMenuItem:^UIView *(int nIndex){
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
    [self doUpdateCustByIdFunction];
}

- (void)pullWaybillPaymentInfo {
    [self doShowHudFunction];
    NSDictionary *m_dic = @{@"freight_cust_id" : self.customerData.freight_cust_id};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_cust_queryCustDetailById" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = (ResponseItem *)responseBody;
            if (item.items.count) {
                weakself.toSaveData = [AppCustomerDetailInfo mj_objectWithKeyValues:item.items[0]];
            }
            [weakself updateSubviews];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)doUpdateCustByIdFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"freight_cust_id" : self.toSaveData.freight_cust_id}];
    if (self.toSaveData.freight_cust_name) {
        [m_dic setObject:self.toSaveData.freight_cust_name forKey:@"freight_cust_name"];
    }
    if (self.toSaveData.phone) {
        [m_dic setObject:self.toSaveData.phone forKey:@"phone"];
    }
    if (self.toSaveData.note) {
        [m_dic setObject:self.toSaveData.note forKey:@"note"];
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_cust_updateCustById" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself updateCustByIdFunctionSuccess];
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

- (void)updateSubviews {
    [self.tableView reloadData];
}

- (void)updateCustByIdFunctionSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_CustomerManageRefresh object:nil];
    [self showHint:@"更新成功"];
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
    }
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    switch (indexPath.section) {
        case 1:{
            if (indexPath.row == 2) {
                
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - getter
- (AppCustomerDetailInfo *)toSaveData {
    if (!_toSaveData) {
        _toSaveData = [AppCustomerDetailInfo mj_objectWithKeyValues:self.customerData.mj_keyValues];
    }
    return _toSaveData;
}

- (NSArray *)showArray {
    if (!_showArray) {
        _showArray = @[
                       @{@"title":@"客户姓名",@"subTitle":@"请输入",@"key":@"freight_cust_name"},
                       @{@"title":@"客户电话",@"subTitle":@"请输入",@"key":@"phone"},
                       @{@"title":@"所属城市",@"subTitle":@"请选择",@"key":@"belong_city_name"},
                       @{@"title":@"客户备注",@"subTitle":@"请输入",@"key":@"note"}];
    }
    return _showArray;
}

- (NSSet *)defaultKeyBoardTypeSet {
    if (!_defaultKeyBoardTypeSet) {
        _defaultKeyBoardTypeSet = [NSSet setWithObjects:@"freight_cust_name", @"note", nil];
    }
    return _defaultKeyBoardTypeSet;
}

- (NSSet *)selectorSet {
    if (!_selectorSet) {
        _selectorSet = [NSSet setWithObjects:@"belong_city_name", nil];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = kCellHeightFilter;
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        rowHeight += kEdge;
    }
    
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *m_dic = self.showArray[indexPath.row];
    static NSString *CellIdentifier = @"fee_edit_cell";
    return [self tableView:tableView singleInputCellForRowAtIndexPath:indexPath showObject:m_dic reuseIdentifier:CellIdentifier];
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
            if ([key isEqualToString:@"phone"]) {
                length = kPhoneNumberLength;
            }
            else if (![self.defaultKeyBoardTypeSet containsObject:key]) {
                length = kPriceLengthMax;
            }
        }
    }
    
    return (range.location < length);
}

@end
