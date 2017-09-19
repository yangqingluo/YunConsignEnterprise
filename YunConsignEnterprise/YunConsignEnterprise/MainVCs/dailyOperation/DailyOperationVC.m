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
    [self setupNav];
    [super viewDidLoad];
    
    self.bannerView.dataSource = [UserPublic getInstance].dailyOperationAccesses;
}

- (void)setupNav{
    [self createNavWithTitle:nil createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *i = [UIImage imageNamed:@"navbar_icon_menus"];
            [btn setImage:i forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(0, 0, 64, 44)];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [btn addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
}

- (void)editButtonAction {
    
}

#pragma mark - getter

#pragma UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo{
    if ([eventName isEqualToString:Event_BannerButtonClicked]) {
        NSIndexPath *indexPath = (NSIndexPath *)userInfo;
        NSLog(@"%ld-%ld", (long)indexPath.section, (long)indexPath.row);
    }
}

@end
