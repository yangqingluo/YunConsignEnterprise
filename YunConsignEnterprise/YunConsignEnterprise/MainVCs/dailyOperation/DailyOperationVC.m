//
//  DailyOperationViewController.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DailyOperationVC.h"

@interface DailyOperationVC ()

@end

@implementation DailyOperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}

- (void)setupNav{
    [self createNavWithTitle:@"日常操作" createMenuItem:^UIView *(int nIndex){
//        if (nIndex == 0){
//            UIButton *btn = NewTextButton(@"登出", [UIColor whiteColor]);
//            [btn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
//            return btn;
//        }
        
        return nil;
    }];
}

@end
