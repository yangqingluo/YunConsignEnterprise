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
    if (!self.baseData) {
        self.toSaveData = [AppPasswordInfo new];
    }
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
    self.showArray = @[@{@"title":@"旧密码",@"subTitle":@"请输入旧密码",@"key":@"pass_old", @"need" : @YES, @"secureTextEntry" : @YES},
                       @{@"title":@"新密码",@"subTitle":@"请输入新密码",@"key":@"pass_new", @"need" : @YES, @"secureTextEntry" : @YES},
                       @{@"title":@"请确认密码",@"subTitle":@"请确认新密码",@"key":@"pass_again", @"need" : @YES, @"secureTextEntry" : @YES}];
}

- (void)pushUpdateData {
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    AppPasswordInfo *m_data = (AppPasswordInfo *)self.toSaveData;
    if (!m_data.pass_old.length) {
        [self doShowHintFunction:@"请输入旧密码"];
        return;
    }
    else if (!m_data.pass_new.length) {
        [self doShowHintFunction:@"请输入新密码"];
        return;
    }
    else if (!m_data.pass_again.length) {
        [self doShowHintFunction:@"请确认新密码"];
        return;
    }
    else if (![m_data.pass_new isEqualToString:m_data.pass_again]) {
        [self doShowHintFunction:@"两次输入新密码不一致，请重试"];
        return;
    }
    
    [m_dic setObject:m_data.pass_old forKey:@"old_pass"];
    [m_dic setObject:m_data.pass_new forKey:@"new_pass"];
    
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_login_changePasswordFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself saveDataSuccess];
            }
            else {
                [weakself doShowHintFunction:item.message.length ? item.message : @"数据出错"];
            }
        }
        else {
            [weakself doShowHintFunction:error.userInfo[@"message"]];
        }
    }];
}

- (void)saveDataSuccess {
    [self doShowHintFunction:@"更新密码成功"];
    [self goBackWithDone:YES];
}

@end
