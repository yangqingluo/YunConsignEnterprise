//
//  WayBillQueryVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillQueryVC.h"

@interface WayBillQueryVC ()

@end

@implementation WayBillQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self queryWaybillListByConditionFunction];
}

- (void)setupNav {
    [self createNavWithTitle:self.accessInfo.menu_name createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)queryWaybillListByConditionFunction {
    [self showHudInView:self.view hint:nil];
    
    NSDictionary *m_dic = @{@"start_time" : @"2017-09-20", @"end_time" : @"2017-09-25", @"start" : @"1", @"limit" : @"10", @"is_cancel" : @"2"};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"queryWaybillListByConditionFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        if (!error) {
            
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

@end
