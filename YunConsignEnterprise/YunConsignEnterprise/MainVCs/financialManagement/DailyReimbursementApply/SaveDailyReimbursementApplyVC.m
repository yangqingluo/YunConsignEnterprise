//
//  SaveDailyReimbursementApplyVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/6.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SaveDailyReimbursementApplyVC.h"

#import "SingleInputCell.h"
#import "BlockActionSheet.h"

@interface SaveDailyReimbursementApplyVC ()<UITextFieldDelegate>

@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) AppDailyReimbursementApplySaveInfo *toSaveData;
@property (strong, nonatomic) NSSet *defaultKeyBoardTypeSet;

@end

@implementation SaveDailyReimbursementApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
}

- (void)setupNav {
    [self createNavWithTitle:@"报销申请" createMenuItem:^UIView *(int nIndex){
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
    
}

- (void)editAtIndexPath:(NSIndexPath *)indexPath andContent:(NSString *)content {
    if (indexPath.row < self.showArray.count) {
        NSDictionary *m_dic = self.showArray[indexPath.row];
        NSString *key = m_dic[@"key"];
        [self.toSaveData setValue:content forKey:key];
    }
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    
}

#pragma mark - getter
- (NSArray *)showArray {
    if (!_showArray) {
        _showArray = @[@{@"title":@"报销科目",@"subTitle":@"请选择",@"key":@"daily_name"},
                       @{@"title":@"报销金额",@"subTitle":@"请输入",@"key":@"daily_fee"},
                       @{@"title":@"关联运单",@"subTitle":@"请选择",@"key":@"bind_waybill_id"},
                       @{@"title":@"报销备注",@"subTitle":@"请输入",@"key":@"note"},];
    }
    return _showArray;
}

- (AppDailyReimbursementApplySaveInfo *)toSaveData {
    if (!_toSaveData) {
        _toSaveData = [AppDailyReimbursementApplySaveInfo new];
    }
    return _toSaveData;
}

- (NSSet *)defaultKeyBoardTypeSet {
    if (!_defaultKeyBoardTypeSet) {
        _defaultKeyBoardTypeSet = [NSSet setWithObjects:@"note", nil];
    }
    
    return _defaultKeyBoardTypeSet;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kEdge;
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
    static NSString *CellIdentifier = @"TTPayCost_cell";
    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.baseView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        cell.baseView.textField.delegate = self;
        cell.baseView.lineView.hidden = YES;
    }
    NSDictionary *m_dic = self.showArray[indexPath.row];
    cell.baseView.textLabel.text = m_dic[@"title"];
    cell.baseView.textField.placeholder = m_dic[@"subTitle"];
    cell.baseView.textField.text = @"";
    cell.baseView.textField.indexPath = [indexPath copy];
    
    NSString *key = m_dic[@"key"];
    if (indexPath.row == 0 || indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.baseView.textField.enabled = NO;
        if (indexPath.row == 0) {
            cell.baseView.textField.text = self.toSaveData.daily_name.item_name;
        }
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.baseView.textField.enabled = YES;
        BOOL isKeybordDefault = [self.defaultKeyBoardTypeSet containsObject:key];
        cell.baseView.textField.keyboardType = isKeybordDefault ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
        cell.baseView.textField.enabled = YES;
        cell.baseView.textField.text = [self.toSaveData valueForKey:key];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self selectRowAtIndexPath:indexPath];
}

@end
