//
//  ServiceRemainDetailVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/4/11.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "ServiceRemainDetailVC.h"

@interface ServiceRemainDetailVC ()

@end

@implementation ServiceRemainDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupNav {
    [self createNavWithTitle:[NSString stringWithFormat:@"%@-剩货明细", self.serviceQuantityData.service_name] createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

@end
