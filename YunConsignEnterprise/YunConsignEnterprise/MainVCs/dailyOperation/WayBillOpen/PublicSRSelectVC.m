//
//  PublicSRSelectVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/20.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicSRSelectVC.h"
#import "PublicCustomerPhoneVC.h"

#import "SingleInputCell.h"
#import "BlockActionSheet.h"
#import "JXTAlertController.h"

@interface PublicSRSelectVC ()<UITextFieldDelegate>

@property (strong, nonatomic) AppSendReceiveInfo *data;
@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) NSMutableArray *serviceArray;

@end

@implementation PublicSRSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self initializeData];
    [self pullServiceArrayFunction];
}

//初始化数据
- (void)initializeData{
    switch (self.type) {
        case SRSelectType_Sender:
        case SRSelectType_Receiver:{
            self.title = self.type == SRSelectType_Sender ? @"发货人" : @"收货人";
            _showArray = @[@{@"title": (self.type == SRSelectType_Sender ? @"始发站" : @"终点站"),@"subTitle":@"请选择"},
                           @{@"title":@"客户电话",@"subTitle":@"请输入"},
                           @{@"title":@"客户姓名",@"subTitle":@"请输入"}];
            _data = [AppSendReceiveInfo new];
            _data.customer = [AppCustomerInfo new];
        }
            break;
            
        default:
            break;
    }
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
    NSDictionary *dic = nil;
    if (!self.data.service) {
        dic = self.showArray[0];
    }
    else if (!self.data.customer.phone.length) {
        dic = self.showArray[1];
    }
    else if (!self.data.customer.freight_cust_name.length) {
        dic = self.showArray[2];
    }
    
    if (dic) {
        [self showHint:[NSString stringWithFormat:@"%@%@", dic[@"subTitle"], dic[@"title"]]];
    }
    else {
        [self doDoneAction];
    }
}

- (void)doDoneAction{
    if (self.doneBlock) {
        self.doneBlock(self.data);
    }
    [self goBack];
}

- (void)pullServiceArrayFunction {
    [self showHudInView:self.view hint:nil];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:self.type == SRSelectType_Sender ? @"hex_waybill_getCurrentService" : @"hex_waybill_getEndService" Parm:nil completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            [weakself.serviceArray removeAllObjects];
            [weakself.serviceArray addObjectsFromArray:[AppServiceInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]]];
             if (weakself.serviceArray.count) {
                 weakself.data.service = weakself.serviceArray[0];
             }
             [weakself.tableView reloadData];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)editAtIndex:(NSUInteger )row andContent:(NSString *)content {
    if (row == 2) {
        self.data.customer.freight_cust_name = content;
    }
    else {
//        NSDictionary *dic = self.showArray[row];
//        [self.data setValue:content forKey:dic[@"key"]];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - getter
- (NSMutableArray *)serviceArray {
    if (!_serviceArray) {
        _serviceArray = [NSMutableArray new];
    }
    return _serviceArray;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = kCellHeightFilter;
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        rowHeight += kEdge;
    }
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.showArray[indexPath.row];
    
    static NSString *CellIdentifier = @"select_cell";
    SingleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SingleInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.baseView.textField.delegate = self;
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
    }
    cell.baseView.textLabel.text = dic[@"title"];
    cell.baseView.textField.placeholder = dic[@"subTitle"];
    cell.baseView.textField.text = @"";
    cell.baseView.textField.indexPath = [indexPath copy];
    cell.accessoryType = indexPath.row == 0 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    switch (indexPath.row) {
        case 0:{
            cell.baseView.textField.text = [self.data.service showCityAndServiceName];
        }
            break;
            
        case 1:{
            cell.baseView.textField.text = self.data.customer.phone;
        }
            break;
            
        case 2:{
            cell.baseView.textField.text = self.data.customer.freight_cust_name;
        }
            break;
            
        default:
            break;
    }
    cell.baseView.textField.enabled = (indexPath.row == 2);
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
            if (self.serviceArray.count) {
                if (self.type == SRSelectType_Sender) {
                    //始发站默认为当前所属站点
                    return;
                }
                
                NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:self.serviceArray.count];
                for (AppServiceInfo *item in self.serviceArray) {
                    [m_array addObject:item.showCityAndServiceName];
                }
                
                QKWEAKSELF;
                BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:@"选择站点" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                    if (buttonIndex > 0 && (buttonIndex - 1) < weakself.serviceArray.count) {
                        weakself.data.service = weakself.serviceArray[buttonIndex - 1];
                        [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                } otherButtonTitlesArray:m_array];
                [sheet showInView:self.view];
                
                //                [self jxt_showActionSheetWithTitle:@"选择站点" message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                //                    alertMaker.
                //                    addActionCancelTitle(@"cancel").
                //                    addActionDefaultTitles(m_array);
                //                } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                //                    if (buttonIndex > 0 && (buttonIndex - 1) < weakself.serviceArray.count) {
                //                        weakself.data.service = weakself.serviceArray[buttonIndex - 1];
                //                        [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                //                    }
                //
                //                }];
            }
            else {
                [self pullServiceArrayFunction];
            }
            break;
            
        case 1:{
            PublicCustomerPhoneVC *vc = [PublicCustomerPhoneVC new];
            vc.data = [self.data copy];
            vc.title = self.title;
            QKWEAKSELF;
            vc.doneBlock = ^(id object){
                if ([object isKindOfClass:self.data.class]) {
                    self.data.customer = [[object valueForKey:@"customer"] copy];
                }
                [weakself.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma  mark - TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return (range.location < kInputLengthMax);
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[IndexPathTextField class]]) {
        NSIndexPath *indexPath = [(IndexPathTextField *)textField indexPath];
        [self editAtIndex:indexPath.row andContent:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
