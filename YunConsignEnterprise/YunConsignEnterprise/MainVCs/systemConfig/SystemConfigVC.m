//
//  SystemConfigViewController.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SystemConfigVC.h"
#import "OpenCityVC.h"
#import "ServiceVC.h"
#import "JsonUserVC.h"
#import "ServiceGoodVC.h"
#import "ServicePackageVC.h"
#import "TruckManageVC.h"
#import "PasswordChangeVC.h"
#import "ServiceNoteVC.h"

#import "BlockAlertView.h"

@interface SystemConfigVC ()

@end

@implementation SystemConfigVC

- (void)viewDidLoad {
    [self setupNav];
    [super viewDidLoad];
    
    self.bannerView.dataSource = [UserPublic getInstance].systemConfigAccesses;
}

- (void)setupNav {
    [self createNavWithTitle:nil createMenuItem:^UIView *(int nIndex){
        if (nIndex == 1){
            UIButton *btn = NewTextButton(@"登出", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)logout {
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定退出登录" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakself doLogoutFunction];
        }
    } otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)doLogoutFunction {
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Get:@{@"login_token" : [UserPublic getInstance].userData.login_token} HeadParm:nil URLFooter:@"/tms/login/logout.do" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            [[AppPublic getInstance] logout];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

#pragma UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo{
    if ([eventName isEqualToString:Event_BannerButtonClicked]) {
        if ([eventName isEqualToString:Event_BannerButtonClicked]) {
            NSInteger index = [(NSIndexPath *)userInfo row];
            NSArray *m_array = [UserPublic getInstance].systemConfigAccesses;
            if (index >= 0 && index < m_array.count) {
                AppAccessInfo *item = m_array[index];
                AppBasicViewController *vc = nil;
                if ([item.menu_code isEqualToString:@"OPEN_CITY"]) {
                    vc = [OpenCityVC new];
                }
                else if ([item.menu_code isEqualToString:@"SERVICE"]) {
                    vc = [ServiceVC new];
                }
                else if ([item.menu_code isEqualToString:@"JSON_USER"]) {
                    vc = [JsonUserVC new];
                }
                else if ([item.menu_code isEqualToString:@"SERVICE_GOOD"]) {
                    vc = [ServiceGoodVC new];
                }
                else if ([item.menu_code isEqualToString:@"SERVICE_PACKAGE"]) {
                    vc = [ServicePackageVC new];
                }
                else if ([item.menu_code isEqualToString:@"TRUCK_MANAGE"]) {
                    vc = [TruckManageVC new];
                }
                else if ([item.menu_code isEqualToString:@"PASSWORD_CHANGE"]) {
                    vc = [PasswordChangeVC new];
                }
                else if ([item.menu_code isEqualToString:@"PRINT_SET"]) {
                    
                }
                else if ([item.menu_code isEqualToString:@"SERVICE_NOTE"]) {
                    vc = [ServiceNoteVC new];
                }
                
                if (vc) {
                    vc.accessInfo = item;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else {
                    [self showHint:[NSString stringWithFormat:@"%@ 敬请期待", item.menu_name]];
                }
            }
        }
    }
}

@end
