//
//  AppBasicViewController.m
//  helloworld
//
//  Created by chen on 14/6/30.
//  Copyright (c) 2014年 yangqingluo. All rights reserved.
//

#import "AppBasicViewController.h"

@interface AppBasicViewController (){
    float _nSpaceNavY;
    NSUInteger hudCount;
}

@property (nonatomic, strong) UIView *navView;

@end

@implementation AppBasicViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)setupNavigationViews{
    _nSpaceNavY = 20;
    double StatusbarSize = 0.0;
    if (iosVersion >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1){
        _nSpaceNavY = 0;
        StatusbarSize = 20.0;
    }
    
    _navigationBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _nSpaceNavY, self.view.width, 64 - _nSpaceNavY)];
    [self.view addSubview:_navigationBarView];
    [_navigationBarView setBackgroundColor:MainColor];
    
    _navView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, StatusbarSize, self.view.width, 44.f)];
    ((UIImageView *)_navView).backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navView];
    _navView.userInteractionEnabled = YES;
    
    self.navBottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, _navView.bounds.size.height - 0.5, _navView.bounds.size.width, 0.5)];
    self.navBottomLine.backgroundColor = baseSeparatorColor;
    self.navBottomLine.hidden = YES;
    [_navView addSubview:self.navBottomLine];
    
    self.titleLabel.frame = CGRectMake(60, (_navView.height - 40) * 0.5, _navView.width - 120, 40);
    [_navView addSubview:self.titleLabel];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = lightWhiteColor;
}

- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem{
    [self setupNavigationViews];
    
    self.title = szTitle;
    
    NSUInteger itemCount = 4;
    for (int i = 0; i < itemCount; i++) {
        UIView *item = menuItem(i);
        if (item){
            [_navView addSubview:item];
        }
    }
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (void)doShowHintFunction:(NSString *)hint {
    if (self.parentVC) {
        [self.parentVC showHint:hint];
    }
    else {
        [self showHint:hint];
    }
}

- (void)doShowHudFunction {
    [self doShowHudFunction:nil];
}

- (void)doShowHudFunction:(NSString *)hint {
    if (hudCount == 0) {
        if (self.parentVC) {
            [self.parentVC showHudInView:self.parentVC.view hint:hint];
        }
        else {
            [self showHudInView:self.view hint:hint];
        }
    }
    hudCount++;
}

- (void)doHideHudFunction {
    if (hudCount > 0) {
        hudCount--;
    }
    if (hudCount == 0) {
        if (self.parentVC) {
            [self.parentVC hideHud];
        }
        else {
            [self hideHud];
        }
    }
}

- (void)doPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.parentVC) {
        [self.parentVC.navigationController pushViewController:viewController animated:animated];
    }
    else {
        [self.navigationController pushViewController:viewController animated:animated];
    }
}

- (void)showFromVC:(AppBasicViewController *)fromVC {
    [fromVC doPushViewController:self animated:YES];
    //    MainTabNavController *nav = [[MainTabNavController alloc] initWithRootViewController:self];
    //    [fromVC presentViewController:nav animated:NO completion:^{
    //
    //    }];
}

- (void)editAtIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag andContent:(NSString *)content {
    
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray<__kindof UIViewController *> *)doPopToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.parentVC) {
        return [self.parentVC.navigationController popToViewController:viewController animated:animated];
    }
    else {
        return [self.navigationController popToViewController:viewController animated:animated];
    }
}

- (NSArray<__kindof UIViewController *> *)doPopToLastViewControllerSkip:(NSUInteger)skip animated:(BOOL)animated {
    return [self doPopToLastViewControllerSkip:skip animated:animated fromViewController:self.parentVC ? self.parentVC : self];
}

- (NSArray<__kindof UIViewController *> *)doPopToLastViewControllerSkip:(NSUInteger)skip animated:(BOOL)animated fromViewController:(UIViewController *)viewController {
    NSArray *m_array = viewController.navigationController.viewControllers;
    NSUInteger count = m_array.count;
    if (skip > 0 && skip <= count - 1) {
        UIViewController *VC = m_array[count - 1 - skip];
        return [viewController.navigationController popToViewController:VC animated:animated];
    }
    else {
        return nil;
    }
}


- (void)checkDataMapExistedForCode:(NSString *)key {
    
}

- (void)initialDataDictionaryForCode:(NSString *)dict_code {
    
}

- (void)pullDataDictionaryFunctionForCode:(NSString *)dict_code selectionInIndexPath:(NSIndexPath *)indexPath {
    NSString *m_code = [dict_code uppercaseString];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Get:@{@"dict_code" : m_code} HeadParm:nil URLFooter:@"/tms/common/get_dict_by_code.do" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            NSArray *m_array = [AppDataDictionary mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            if (m_array.count) {
                [[UserPublic getInstance].dataMapDic setObject:m_array forKey:dict_code];
                [weakself initialDataDictionaryForCode:dict_code ];
                if (indexPath) {
                    [weakself selectRowAtIndexPath:indexPath];
                }
            }
        }
        else {
            [weakself doShowHintFunction:error.userInfo[@"message"]];
        }
    }];
}

- (void)pullServiceArrayFunctionForCode:(NSString *)dict_code selectionInIndexPath:(NSIndexPath *)indexPath {
    NSString *functionCode = nil;
    if ([dict_code isEqualToString:@"start_service"]) {
        functionCode = @"hex_waybill_getCurrentService";
    }
    else if ([dict_code isEqualToString:@"end_service"]) {
        functionCode = @"hex_waybill_getEndService";
    }
    else if ([dict_code isEqualToString:@"power_service"]) {
        functionCode = @"hex_waybill_getPowerService";
    }
    
    if (!functionCode) {
        return;
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:functionCode Parm:nil completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            NSArray *m_array = [AppServiceInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            if (m_array.count) {
                [[UserPublic getInstance].dataMapDic setObject:m_array forKey:dict_code];
                if (indexPath) {
                    [weakself selectRowAtIndexPath:indexPath];
                }
            }
        }
        else {
            [weakself doShowHintFunction:error.userInfo[@"message"]];
        }
    }];
}

- (void)pullServiceArrayFunctionForCityID:(NSString *)open_city_id selectionInIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *m_dic = @{@"open_city_id" : open_city_id};
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_queryServiceListByCityId" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            NSArray *m_array = [AppServiceInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            if (m_array.count) {
                [[UserPublic getInstance].dataMapDic setObject:m_array forKey:serviceDataMapKeyForCity(open_city_id)];
                if (indexPath) {
                    [self selectRowAtIndexPath:indexPath];
                }
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)pullCityArrayFunctionForCode:(NSString *)dict_code selectionInIndexPath:(NSIndexPath *)indexPath {
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_dispatch_queryOpenCityList" Parm:nil completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            NSArray *m_array = [AppCityInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            if (m_array.count) {
                [[UserPublic getInstance].dataMapDic setObject:m_array forKey:dict_code];
                [weakself selectRowAtIndexPath:indexPath];
            }
        }
        else {
            [weakself doShowHintFunction:error.userInfo[@"message"]];
        }
    }];
}

- (void)pullLoadServiceArrayFunctionForTransportTruckID:(NSString *)transport_truck_id selectionInIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *m_dic = @{@"transport_truck_id" : transport_truck_id};
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_arrival_queryServiceListByTransportTruckId" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            NSArray *m_array = [AppServiceInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            if (m_array.count) {
                [[UserPublic getInstance].dataMapDic setObject:m_array forKey:serviceDataMapKeyForTruck(transport_truck_id)];
                if (indexPath) {
                    [weakself selectRowAtIndexPath:indexPath];
                }
            }
        }
        else {
            [weakself doShowHintFunction:error.userInfo[@"message"]];
        }
    }];
}

#pragma setter
- (void)setTitle:(NSString *)title{
    [super setTitle:title];
    self.titleLabel.text = title;
}

#pragma getter
- (UILabel *)titleLabel{         
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:20.0]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    return _titleLabel;
}

- (NSMutableSet *)toCheckDataMapSet {
    if (!_toCheckDataMapSet) {
        _toCheckDataMapSet = [NSMutableSet new];
    }
    return _toCheckDataMapSet;
}

#pragma mark - TextField
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    
//}
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    if ([textField.text isEqualToString:@"0"]) {
//        textField.text = @"";
//    }
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return (range.location < kInputLengthMax);
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > kInputLengthMax) {
        textField.text = [textField.text substringToIndex:kInputLengthMax];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - notification
- (void)needRefreshNotification:(NSNotification *)notification {
    self.needRefresh = YES;
}

@end
