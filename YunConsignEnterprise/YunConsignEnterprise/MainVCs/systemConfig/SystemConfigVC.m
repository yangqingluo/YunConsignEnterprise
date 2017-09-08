//
//  SystemConfigViewController.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SystemConfigVC.h"

@interface SystemConfigVC ()

@end

@implementation SystemConfigVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}

- (void)setupNav{
    [self createNavWithTitle:@"系统设置" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewTextButton(@"登出", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
}

- (void)logout {
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

@end
