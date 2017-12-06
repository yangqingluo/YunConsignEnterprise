//
//  PublicCustomerPhoneVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/20.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicCustomerPhoneVC.h"

#import "PublicInputCellView.h"
#import "TextFieldCell.h"
#import "FourItemsListCell.h"

@interface PublicCustomerPhoneVC ()<UITextFieldDelegate>

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) NSMutableArray *dataSource;

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
    self.tableView.tableHeaderView = self.headerView;
    [self pulldataSource:self.data.customer.phone];
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

- (void)pulldataSource:(NSString *)prefix {
    if (prefix.length < 4) {
        return;
    }
    
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_queryCustListByPhoneAndCityFunction" Parm:@{@"phone" : prefix, @"city" : self.data.service.open_city_id}  completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:[AppCustomerInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]]];
            [weakself.tableView reloadData];
        }
    }];
}

#pragma mark - getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeightFilter)];
        
        PublicInputCellView *inputView = [[PublicInputCellView alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0, _headerView.width - 2 * kEdgeMiddle, _headerView.height)];
        [inputView.lineView removeFromSuperview];
        inputView.textField.keyboardType = UIKeyboardTypePhonePad;
        inputView.textField.delegate = self;
        [inputView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        NSDictionary *dic = @{@"title":@"客户电话",@"subTitle":@"请输入"};
        inputView.textLabel.text = dic[@"title"];
        inputView.textField.placeholder = dic[@"subTitle"];
        inputView.textField.text = @"";
        if (self.data.customer.phone.length) {
            inputView.textField.text = self.data.customer.phone;
        }
        [_headerView addSubview:inputView];
        [_headerView addSubview:NewSeparatorLine(CGRectMake(0, 0, _headerView.width, appSeparaterLineSize))];
        [_headerView addSubview:NewSeparatorLine(CGRectMake(0, _headerView.height - appSeparaterLineSize, _headerView.width, appSeparaterLineSize))];
    }
    return _headerView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [FourItemsListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataSource.count) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        bgView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(kEdge, 0, bgView.width - 2 * kEdge, bgView.height)];
        titleLable1.textAlignment = NSTextAlignmentCenter;
        titleLable1.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
        titleLable1.textColor = baseTextColor;
        [bgView addSubview:titleLable1];
        titleLable1.text = @"相似客户";
        
        return bgView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"customer_cell";
    FourItemsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[FourItemsListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.firstRightLabel.width = [AppPublic textSizeWithString:@"电话：01234567890" font:cell.firstRightLabel.font constantHeight:cell.firstRightLabel.height].width;
        cell.firstRightLabel.right = cell.baseView.width - kEdge;
        cell.firstLeftLabel.width = cell.firstRightLabel.left - 2 * kEdge;
        
        cell.secondRightLabel.width = [AppPublic textSizeWithString:@"时间：2017-01-01 " font:cell.secondRightLabel.font constantHeight:cell.secondRightLabel.height].width;
        cell.secondRightLabel.right = cell.baseView.width - kEdge;
        cell.secondLeftLabel.width = cell.secondRightLabel.left - 2 * kEdge;
    }
    AppCustomerInfo *item = self.dataSource[indexPath.row];
    cell.firstLeftLabel.text = [NSString stringWithFormat:@"姓名：%@", item.freight_cust_name];
    cell.firstRightLabel.text = [NSString stringWithFormat:@"电话：%@", item.phone];
    cell.secondLeftLabel.text = [NSString stringWithFormat:@"货物：%@", item.last_deliver_goods];
    cell.secondRightLabel.text = [NSString stringWithFormat:@"时间：%@", dateStringWithTimeString(item.last_deliver_time)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.data.customer = self.dataSource[indexPath.row];
    [self doDoneAction];
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
    [self pulldataSource:self.data.customer.phone];
}

@end
