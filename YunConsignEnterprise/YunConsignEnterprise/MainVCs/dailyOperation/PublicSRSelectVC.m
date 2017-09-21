//
//  PublicSRSelectVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/20.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicSRSelectVC.h"
#import "PublicCustomerPhoneVC.h"

#import "TextFieldCell.h"
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
    [self pullServiceArray];
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

- (void)pullServiceArray {
    [self showHudInView:self.view hint:nil];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:self.type == SRSelectType_Sender ? @"hex_waybill_getCurrentService" : @"hex_waybill_getEndService" Parm:nil  completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            [self.serviceArray removeAllObjects];
            [self.serviceArray addObjectsFromArray:[AppServiceInfo mj_objectArrayWithKeyValuesArray:responseBody]];
            if (self.serviceArray.count) {
                self.data.service = self.serviceArray[0];
            }
            [self.tableView reloadData];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)editAtIndex:(NSUInteger )row andContent:(NSString *)content{
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
    return kCellHeightMiddle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    }
    cell.textLabel.text = dic[@"title"];
    cell.textField.placeholder = dic[@"subTitle"];
    cell.textField.text = @"";
    cell.textField.indexPath = [indexPath copy];
    cell.accessoryType = indexPath.row == 0 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    switch (indexPath.row) {
        case 0:{
            cell.textField.text = [self.data.service showCityAndServiceName];
        }
            break;
            
        case 1:{
            cell.textField.text = self.data.customer.phone;
        }
            break;
            
        case 2:{
            cell.textField.text = self.data.customer.freight_cust_name;
        }
            break;
            
        default:
            break;
    }
    cell.textField.enabled = (indexPath.row == 2);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
            if (self.serviceArray.count) {
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
                [self pullServiceArray];
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
