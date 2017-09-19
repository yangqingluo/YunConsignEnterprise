//
//  FinancialManagementViewController.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "FinancialManagementVC.h"

@interface FinancialManagementVC ()

@end

@implementation FinancialManagementVC

- (void)viewDidLoad {
    [self setupNav];
    [super viewDidLoad];
    
    self.bannerView.dataSource = [UserPublic getInstance].financialManagementAccesses;
}

- (void)setupNav{
    [self createNavWithTitle:nil createMenuItem:^UIView *(int nIndex){
        //        if (nIndex == 0){
        //            UIButton *btn = NewTextButton(@"登出", [UIColor whiteColor]);
        //            [btn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        //            return btn;
        //        }
        
        return nil;
    }];
}

#pragma UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo{
    if ([eventName isEqualToString:Event_BannerButtonClicked]) {
        NSIndexPath *indexPath = (NSIndexPath *)userInfo;
        NSLog(@"%ld-%ld", (long)indexPath.section, (long)indexPath.row);
    }
}

@end
