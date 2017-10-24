//
//  PublicEndStationSelectVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/24.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicEndStationSelectVC.h"

@interface PublicEndStationSelectVC ()

@end

@implementation PublicEndStationSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.tableView.width = 80;
}

- (void)setupNav {
    [self createNavWithTitle:@"选择终点站" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"保存", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonAction {
    [self dismissKeyboard];
    
}

@end
