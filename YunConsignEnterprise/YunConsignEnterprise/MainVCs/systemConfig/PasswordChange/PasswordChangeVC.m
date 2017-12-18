//
//  PasswordChangeVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/12/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PasswordChangeVC.h"

@interface PasswordChangeVC ()

@end

@implementation PasswordChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupNav {
    [self createNavWithTitle:@"修改密码" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"修改", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"旧密码",@"subTitle":@"请输入旧密码",@"key":@"package_name", @"need" : @YES},
                       @{@"title":@"新密码",@"subTitle":@"请输入新密码",@"key":@"package_py", @"need" : @YES},
                       @{@"title":@"请确认密码",@"subTitle":@"请确认新密码",@"key":@"sort", @"need" : @YES}];
}

@end
