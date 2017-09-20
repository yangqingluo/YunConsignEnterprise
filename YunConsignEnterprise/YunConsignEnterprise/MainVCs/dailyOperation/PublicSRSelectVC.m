//
//  PublicSRSelectVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/20.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicSRSelectVC.h"

#import "TextFieldCell.h"
#import "BlockActionSheet.h"
#import "JXTAlertController.h"

@interface PublicSRSelectVC ()<UITextFieldDelegate, UITextViewDelegate>

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
            _showArray = @[@{@"title":@"始发站",@"subTitle":@"必填，请选择"},
                           @{@"title":@"客户电话",@"subTitle":@"请输入"},
                           @{@"title":@"客户姓名",@"subTitle":@"请输入"}];
            _data = [AppSendReceiveInfo new];
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
    
}

- (void)pullServiceArray {
    [self showHudInView:self.view hint:nil];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_getCurrentService" Parm:nil  completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            [self.serviceArray removeAllObjects];
            [self.serviceArray addObjectsFromArray:[AppServiceInfo mj_objectArrayWithKeyValuesArray:responseBody]];
            [self.serviceArray addObject:[AppServiceInfo mj_objectWithKeyValues:@{@"open_city_id": @"1",
                                                                                 @"open_city_name": @"成都",
                                                                                 @"service_id": @"1",
                                                                                 @"service_name": @"五块石店"}]];
            [self.serviceArray addObject:[AppServiceInfo mj_objectWithKeyValues:@{@"open_city_id": @"1",
                                                                                  @"open_city_name": @"重庆",
                                                                                  @"service_id": @"1",
                                                                                  @"service_name": @"朝天门店"}]];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:{
            cell.textField.text = [self.data.service showCityAndServiceName];
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
        case 0:{
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
        }
            break;
            
        default:
            break;
    }
}
@end
