//
//  CustomerConditionVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/1/10.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "CustomerConditionVC.h"
#import "CustomerManageVC.h"

@interface CustomerConditionVC ()

@end

@implementation CustomerConditionVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_CustomerManage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.accessInfo.menu_name;
}

- (void)searchButtonAction {
    [self dismissKeyboard];
    if (self.condition.freight_cust_name.length == 0 && self.condition.phone.length == 0) {
        [self doShowHintFunction:@"请输入客户姓名或电话后查询"];
        return;
    }
    
//    if (self.condition.freight_cust_name.length < 2 && self.condition.phone.length < 4) {
//        [self doShowHintFunction:@"请输入至少2位客户姓名或4位电话后查询"];
//        return;
//    }
    
    CustomerManageVC *vc = [CustomerManageVC new];
    vc.condition = self.condition;
    vc.accessInfo = self.accessInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
