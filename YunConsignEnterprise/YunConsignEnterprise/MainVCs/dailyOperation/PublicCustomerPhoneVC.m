//
//  PublicCustomerPhoneVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/20.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicCustomerPhoneVC.h"

#import "TextFieldCell.h"
#import "FourItemsListCell.h"

@interface PublicCustomerPhoneVC ()<UITextFieldDelegate>

@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) NSMutableArray *customerArray;

@end

@implementation PublicCustomerPhoneVC

//- (void)viewDidLayoutSubviews {
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];

//    // 设置毛玻璃
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
//    self.tableView.separatorEffect = vibrancyEffect;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self pullCustomerArray:self.data.customer.phone];
}

- (void)setupNav {
    [self createNavWithTitle:self.title ? self.title : nil createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"确定", [UIColor whiteColor]);
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
    [self doDoneAction];
}

- (void)doDoneAction{
    if (self.doneBlock) {
        self.doneBlock(self.data);
    }
    [self goBack];
}

- (void)pullCustomerArray:(NSString *)prefix {
    if (prefix.length < 4) {
        return;
    }
    
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_queryCustListByPhoneAndCityFunction" Parm:@{@"phone" : prefix, @"city" : self.data.service.open_city_id}  completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            [self.customerArray removeAllObjects];
            [self.customerArray addObjectsFromArray:[AppCustomerInfo mj_objectArrayWithKeyValuesArray:responseBody]];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationBottom];
        }
    }];
}

#pragma mark - getter
- (NSMutableArray *)customerArray {
    if (!_customerArray) {
        _customerArray = [NSMutableArray new];
    }
    return _customerArray;
}

- (NSArray *)showArray {
    if (!_showArray) {
        _showArray = @[@{@"title":@"客户电话",@"subTitle":@"请输入"}];
    }
    return _showArray;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:{
            return self.showArray.count;
        }
            break;
            
        case 1:{
            return self.customerArray.count;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return [FourItemsListCell tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return kCellHeightMiddle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return STATUS_HEIGHT;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if (self.customerArray.count) {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, STATUS_HEIGHT)];
            bgView.backgroundColor = [UIColor clearColor];
            
            UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(kEdge, 0, bgView.width - 2 * kEdge, bgView.height)];
            titleLable1.textAlignment = NSTextAlignmentCenter;
            titleLable1.font = [AppPublic appFontOfSize:appLabelFontSize];
            titleLable1.textColor = baseTextColor;
            [bgView addSubview:titleLable1];
            titleLable1.text = @"相似客户";
            
            return bgView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSDictionary *dic = self.showArray[indexPath.row];
        
        static NSString *CellIdentifier = @"select_cell";
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.font = [UIFont systemFontOfSize:appLabelFontSizeMiddle];
            
            cell.textField.font = cell.textLabel.font;
            cell.textField.textAlignment = NSTextAlignmentRight;
            cell.textField.frame = CGRectMake(cellDetailLeft, kEdge, cellDetailRightWhenIndicator - cellDetailLeft, kCellHeightMiddle - 2 * kEdge);
            cell.textField.delegate = self;
            cell.textField.keyboardType = UIKeyboardTypePhonePad;
            [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        cell.textLabel.text = dic[@"title"];
        cell.textField.placeholder = dic[@"subTitle"];
        cell.textField.text = @"";
        cell.textField.indexPath = [indexPath copy];
        if (self.data.customer.phone.length) {
            cell.textField.text = self.data.customer.phone;
        }
        
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"customer_cell";
        FourItemsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[FourItemsListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        AppCustomerInfo *item = self.customerArray[indexPath.row];
        cell.firstLeftLabel.text = [NSString stringWithFormat:@"姓名：%@", item.freight_cust_name];
        cell.firstRightLabel.text = [NSString stringWithFormat:@"电话：%@", item.phone];
        cell.secondLeftLabel.text = [NSString stringWithFormat:@"货物：%@", item.last_deliver_goods];
        cell.secondRightLabel.text = [NSString stringWithFormat:@"时间：%@", dateStringWithTimeString(item.last_deliver_time)];
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        self.data.customer = self.customerArray[indexPath.row];
        [self doDoneAction];
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 1) {
//        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//            [cell setSeparatorInset:UIEdgeInsetsMake(0, screen_width, 0, 0)];
//        }
//        
//        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//            [cell setLayoutMargins:UIEdgeInsetsMake(0, screen_width, 0, 0)];
//        }
//    }
//}

#pragma  mark - TextField
- (void)textFieldDidChange:(UITextField *)textField {
    self.data.customer.phone = textField.text;
    [self pullCustomerArray:self.data.customer.phone];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return (range.location < kPhoneNumberLength);
}
@end
