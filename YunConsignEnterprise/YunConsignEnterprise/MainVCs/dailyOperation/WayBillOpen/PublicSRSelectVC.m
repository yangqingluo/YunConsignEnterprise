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
#import "BlockCustomSheet.h"
#import "JXTAlertController.h"

@interface PublicSRSelectVC ()<UITextFieldDelegate> {
    CGRect phoneTextFiledFrame;
}

@property (strong, nonatomic) BlockCustomSheet *customerSheet;

@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) NSMutableArray *serviceArray;
@property (strong, nonatomic) NSMutableDictionary *townDic;

@end

@implementation PublicSRSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self initializeData];
    if (!_isEditOnly || self.type == SRSelectType_Receiver) {
        [self pullServiceArrayFunction];
    }
    if (self.type == SRSelectType_Receiver && _data) {
        [self pullServiceTownArrayFunction:_data.service.service_id atIndexPath:nil];
    }
}

//初始化数据
- (void)initializeData{
    switch (self.type) {
        case SRSelectType_Sender: {
            self.title = @"发货人";
            _showArray = _isEditOnly ?
            @[@{@"title":@"始发站",@"subTitle":@"请选择"},
              @{@"title":@"客户电话",@"key":@"phone",@"subTitle":@"请输入"},
              @{@"title":@"客户姓名",@"key":@"freight_cust_name",@"subTitle":@"请输入"},
              @{@"title":@"银行名称",@"key":@"bank_name",@"subTitle":@"请输入"},
              @{@"title":@"银行账户",@"key":@"bank_card_account",@"subTitle":@"请输入"}]
            :
            @[@{@"title":@"始发站",@"subTitle":@"请选择"},
              @{@"title":@"客户电话",@"key":@"phone",@"subTitle":@"请输入"},
              @{@"title":@"客户姓名",@"key":@"freight_cust_name",@"subTitle":@"请输入"},
              @{@"title":@"身份证号",@"key":@"id_card",@"subTitle":@"请输入"},
              @{@"title":@"银行名称",@"key":@"bank_name",@"subTitle":@"请输入"},
              @{@"title":@"银行账户",@"key":@"bank_card_account",@"subTitle":@"请输入"}];
        }
            break;
        case SRSelectType_Receiver:{
            self.title = @"收货人";
            _showArray = @[@{@"title":@"终点站",@"subTitle":@"请选择"},
                           @{@"title":@"客户电话",@"key":@"phone",@"subTitle":@"请输入"},
                           @{@"title":@"客户姓名",@"key":@"freight_cust_name",@"subTitle":@"请输入"},
                           @{@"title":@"中转站",@"key":@"real_station_city_name",@"subTitle":@""}];
            
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
        if (self.type == SRSelectType_Sender) {
            self.data.customer.freight_cust_name = @"无";
        }
        else {
            dic = self.showArray[2];
        }
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
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    NSString *funcId = @"";
    if (self.type == SRSelectType_Sender) {
        funcId = @"hex_waybill_getCurrentService";
    }
    else if (self.type == SRSelectType_Receiver) {
        if (self.open_city_id) {
            funcId = @"hex_base_updateWaybillGetEndService";
            [m_dic setObject:self.open_city_id forKey:@"open_city_id"];
        }
        else {
            funcId = @"hex_base_getEndService";
        }
    }
    
    if (!funcId.length) {
        return;
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:funcId Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            [weakself.serviceArray removeAllObjects];
            [weakself.serviceArray addObjectsFromArray:[AppServiceInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]]];
             if (!weakself.data.service && weakself.serviceArray.count) {
                 [weakself changeService:weakself.serviceArray[0]];
             }
             [weakself.tableView reloadData];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)pullServiceTownArrayFunction:(NSString *)service_id atIndexPath:(NSIndexPath *)indexPath {
    if (!service_id) {
        return;
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_base_queryTownListById" Parm:@{@"service_id" : service_id} completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            NSArray *m_array = [AppTownInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            if (!m_array) {
                m_array = [NSArray new];
            }
            [weakself.townDic setObject:m_array forKey:service_id];
//            if (m_array.count && !weakself.data.town.town_name) {
//                weakself.data.town = m_array[0];
//            }
            [weakself.tableView reloadData];
            if (indexPath) {
                [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)editAtIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag andContent:(NSString *)content {
    if (indexPath.row == 0) {
        
    }
    else {
        NSDictionary *dic = self.showArray[indexPath.row];
        NSString *key = dic[@"key"];
        if ([key isEqualToString:@"real_station_city_name"]) {
            if (!self.data.town) {
                self.data.town = [AppTownInfo new];
            }
            self.data.town.town_name = content;
        }
        else if ([key isEqualToString:@"phone"]) {
            
        }
        else {
            [self.data.customer setValue:content forKey:key];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)changeService:(AppServiceInfo *)info {
    if ([info isEqual:self.data.service]) {
        return;
    }
    self.data.service = info;
    
    if (self.type == SRSelectType_Receiver) {
        self.data.town = [AppTownInfo new];
        NSArray *townArray = self.townDic[info.service_id];
        if (townArray) {
            [self.tableView reloadData];
        }
        else {
            [self pullServiceTownArrayFunction:info.service_id atIndexPath:nil];
        }
    }
}

- (void)pullCustListByPhoneAndCity:(NSString *)prefix {
    self.data.customer.phone = prefix;
    [self.customerSheet dismiss];
    if (prefix.length < 4) {
        return;
    }
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_waybill_queryCustListByPhoneAndCityFunction" Parm:@{@"phone" : prefix, @"city" : self.data.service.open_city_id}  completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            [weakself showCustomerSheet:[AppCustomerInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]]];
        }
    }];
}

- (void)showCustomerSheet:(NSArray *)array {
    if (!array.count) {
        return;
    }
    NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:array.count];
    for (AppCustomerInfo *item in array) {
        [m_array addObject:[NSString stringWithFormat:@"%@ %@", item.freight_cust_name, item.phone]];
    }
    self.customerSheet.top = phoneTextFiledFrame.origin.y + phoneTextFiledFrame.size.height;
    QKWEAKSELF;
    self.customerSheet.block = ^(NSInteger buttonIndex){
        if (buttonIndex < array.count) {
            weakself.data.customer = array[buttonIndex];
            [weakself.tableView reloadData];
        }
    };
    [self.customerSheet showWithStringArray:m_array];
}

#pragma mark - getter
- (BlockCustomSheet *)customerSheet {
    if (!_customerSheet) {
        CGFloat scale = 0.2;
        _customerSheet = [[BlockCustomSheet alloc] initWithFrame:CGRectMake(scale * screen_width, 0, (1- scale) * screen_width - kEdgeMiddle, 0) style:UITableViewStyleGrouped];
        [self.view addSubview:_customerSheet];
    }
    return _customerSheet;
}

- (NSMutableArray *)serviceArray {
    if (!_serviceArray) {
        _serviceArray = [NSMutableArray new];
    }
    return _serviceArray;
}

- (NSMutableDictionary *)townDic {
    if (!_townDic) {
        _townDic = [NSMutableDictionary new];
    }
    return _townDic;
}

- (AppSendReceiveInfo *)data {
    if (!_data) {
        _data = [AppSendReceiveInfo new];
        _data.customer = [AppCustomerInfo new];
        _data.town = [AppTownInfo new];
    }
    return _data;
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
        [cell.baseView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        cell.separatorInset = UIEdgeInsetsMake(0, screen_width, 0, 0);
    }
    cell.baseView.textLabel.text = dic[@"title"];
    cell.baseView.textField.placeholder = dic[@"subTitle"];
    cell.baseView.textField.text = @"";
    cell.baseView.textField.indexPath = [indexPath copy];
    cell.accessoryType = indexPath.row == 0 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    NSString *key = dic[@"key"];
    cell.baseView.textField.enabled = (indexPath.row != 0);
//    if (_isEditOnly) {
//        cell.baseView.textField.enabled = (indexPath.row != 0);
//    }
//    else {
//        cell.baseView.textField.enabled = !(indexPath.row == 0 || indexPath.row == 1);
//    }
    
    if (indexPath.row == 0) {
        cell.baseView.textField.text = [self.data.service showCityAndServiceName];
    }
    else {
        if ([key isEqualToString:@"real_station_city_name"]) {
            cell.baseView.textField.text = self.data.town.town_name;
            if (self.data.service) {
                NSArray *townArray = self.townDic[self.data.service.service_id];
                if (townArray.count) {
                    cell.baseView.textField.enabled = NO;
                    cell.baseView.textField.placeholder = @"请选择";
                }
                else {
                    cell.baseView.textField.enabled = YES;
                    cell.baseView.textField.placeholder = @"请输入";
                }
            }
        }
        else {
           cell.baseView.textField.text = [self.data.customer valueForKey:key];
        }
    }
    
    cell.baseView.textField.keyboardType = (indexPath.row == 1) ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
    cell.isShowBottomEdge = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self dismissKeyboard];
    switch (indexPath.row) {
        case 0:{
            if (_isEditOnly && self.type == SRSelectType_Sender) {
                return;
            }
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
                        [weakself changeService:weakself.serviceArray[buttonIndex - 1]];
                        [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                } otherButtonTitlesArray:m_array];
                [sheet showInView:self.view];
            }
            else {
                [self pullServiceArrayFunction];
            }
        }
            break;
            
        case 1:{
//            if (!_isEditOnly) {
//                PublicCustomerPhoneVC *vc = [PublicCustomerPhoneVC new];
//                vc.data = [self.data copy];
//                vc.title = self.title;
//                QKWEAKSELF;
//                vc.doneBlock = ^(id object){
//                    if ([object isKindOfClass:self.data.class]) {
//                        self.data.customer = [[object valueForKey:@"customer"] copy];
//                    }
//                    [weakself.tableView reloadData];
//                };
//                [self.navigationController pushViewController:vc animated:YES];
//            }
        }
            break;
            
        default:{
            NSDictionary *dic = self.showArray[indexPath.row];
            NSString *key = dic[@"key"];
            if ([key isEqualToString:@"real_station_city_name"] && self.data.service) {
                NSArray *townArray = self.townDic[self.data.service.service_id];
                if (townArray) {
                    if (!townArray.count) {
                        return;
                    }
                    NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:townArray.count];
                    for (AppTownInfo *item in townArray) {
                        [m_array addObject:item.town_name];
                    }
                    
                    QKWEAKSELF;
                    BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:@"选择中转站" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                        if (buttonIndex > 0 && (buttonIndex - 1) < townArray.count) {
                            weakself.data.town = townArray[buttonIndex - 1];
                            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    } otherButtonTitlesArray:m_array];
                    [sheet showInView:self.view];
                }
                else {
                    [self pullServiceTownArrayFunction:self.data.service.service_id atIndexPath:indexPath];
                }
            }
        }
            break;
    }
}

#pragma  mark - TextField
- (void)textFieldDidChange:(UITextField *)textField {
    if ([textField isKindOfClass:[IndexPathTextField class]]) {
        NSIndexPath *indexPath = [(IndexPathTextField *)textField indexPath];
        //在当前页面自动匹配补全联系人供选择
        if (indexPath.row == 1) {
            NSString *content = textField.text;
            phoneTextFiledFrame = [textField.superview convertRect:textField.frame toView:self.view];
            [self pullCustListByPhoneAndCity:content];
        }
    }
}

@end
