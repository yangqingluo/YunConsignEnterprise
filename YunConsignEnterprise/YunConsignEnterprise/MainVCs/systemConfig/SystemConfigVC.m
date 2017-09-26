//
//  SystemConfigViewController.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SystemConfigVC.h"
#import "BlockAlertView.h"

@interface SystemConfigVC ()

@end

@implementation SystemConfigVC

- (void)viewDidLoad {
    [self setupNav];
    [super viewDidLoad];
    
    self.bannerView.dataSource = [UserPublic getInstance].systemConfigAccesses;
}

- (void)setupNav{
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
    [self showHudInView:self.view hint:nil];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Get:@{@"login_token" : [UserPublic getInstance].userData.login_token} HeadParm:nil URLFooter:@"/login/logout.do" completion:^(id responseBody, NSError *error){
        [weakself hideHud];
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
                switch (item.sort) {
                    default:{
                        [self showHint:[NSString stringWithFormat:@"%@ 敬请期待", item.menu_name]];
                    }
                        break;
                }
            }
        }
    }
}

@end
