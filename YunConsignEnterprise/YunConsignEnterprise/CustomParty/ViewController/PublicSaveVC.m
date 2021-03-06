//
//  PublicSaveVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicSaveVC.h"

@interface PublicSaveVC ()<UITextFieldDelegate>

@end

@implementation PublicSaveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self initializeData];
    if (self.baseData) {
        [self pullDetailData];
    }
}

- (void)setupNav {
    [self createNavWithTitle:self.title ? self.title : @"编辑" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
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

- (void)saveButtonAction {
    [self dismissKeyboard];
    [self pushUpdateData];
}

- (void)initializeData {
    
}

- (void)pullDetailData {
    
}

- (void)pushUpdateData {
    
}

- (void)saveDataSuccess {
    [self doShowHintFunction:@"保存成功"];
    [self goBackWithDone:YES];
}

- (void)editAtIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag andContent:(NSString *)content {
    if (indexPath.row < self.showArray.count) {
        id object = self.showArray[indexPath.row];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *m_dic = object;
            NSString *key = m_dic[@"key"];
            if ([self.numberKeyBoardTypeSet containsObject:key]) {
                [self.toSaveData setValue:[NSString stringWithFormat:@"%d", [content intValue]] forKey:m_dic[@"key"]];
            }
            else {
                [self.toSaveData setValue:content forKey:m_dic[@"key"]];
            }
        }
    }
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([self.boolValidSet containsObject:key]) {
        NSArray *m_array = @[@"是", @"否"];
        QKWEAKSELF;
        BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
            if (buttonIndex > 0) {
                [weakself.toSaveData setValue:boolString(buttonIndex == 1) forKey:key];
                [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        } otherButtonTitlesArray:m_array];
        [sheet showInView:self.view];
    }
}

#pragma mark - getter
- (NSMutableSet *)numberKeyBoardTypeSet {
    if (!_numberKeyBoardTypeSet) {
        _numberKeyBoardTypeSet = [NSMutableSet setWithObjects:@"sort", nil];
    }
    return _numberKeyBoardTypeSet;
}

- (NSMutableSet *)selectorSet {
    if (!_selectorSet) {
        _selectorSet = [NSMutableSet new];
    }
    return _selectorSet;
}

- (NSMutableSet *)boolValidSet {
    if (!_boolValidSet) {
        _boolValidSet = [NSMutableSet new];
    }
    return _boolValidSet;
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
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *m_dic = self.showArray[indexPath.row];
    static NSString *CellIdentifier = @"save_edit_cell";
    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
        if (indexPath.section == 1) {
            [cell.baseView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        cell.baseView.textField.delegate = self;
    }
    cell.baseView.textLabel.text = m_dic[@"title"];
    cell.baseView.textField.placeholder = m_dic[@"subTitle"];
    cell.baseView.textField.text = @"";
    cell.baseView.textField.enabled = YES;
    cell.baseView.textField.indexPath = [indexPath copy];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.baseView.textField.secureTextEntry = [m_dic[@"secureTextEntry"] boolValue];
    
    NSString *key = m_dic[@"key"];
    NSString *showKey = m_dic[@"showKey"];
    BOOL isKeybordDefault = ![self.numberKeyBoardTypeSet containsObject:key];
    cell.baseView.textField.keyboardType = isKeybordDefault ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    
    if ([self.selectorSet containsObject:key]) {
        cell.baseView.textField.enabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if ([key isEqualToString:@"open_city"]) {
            cell.baseView.textField.text = [self.toSaveData valueForKey:@"open_city_name"];
        }
        else if ([key isEqualToString:@"service_state"]) {
            cell.baseView.textField.text = [self.toSaveData valueForKey:@"service_state_text"];
        }
        else if ([key isEqualToString:@"location"]) {
            cell.baseView.textField.text = [self.toSaveData valueForKey:@"location"];
        }
        else {
            if (showKey) {
                cell.baseView.textField.text = [self.toSaveData valueForKey:showKey];
            }
            else {
                NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
                for (AppDataDictionary *m_data in dicArray) {
                    if ([m_data.item_val isEqualToString:[self.toSaveData valueForKey:key]]) {
                        cell.baseView.textField.text = m_data.item_name;
                        break;
                    }
                }
            }
        }
    }
    else if ([self.boolValidSet containsObject:key]) {
        cell.baseView.textField.enabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *value = [self.toSaveData valueForKey:key];
        if (value) {
            cell.baseView.textField.text = isTrue(value) ? @"是" : @"否";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self selectRowAtIndexPath:indexPath];
}

#pragma  mark - TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    BOOL m_bool = YES;
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
        
        if (key.length) {if ([self.numberKeyBoardTypeSet containsObject:key]) {
                length = kPriceLengthMax;
            }
        }
    }
    
    return m_bool && (range.location < length);
}

@end
