//
//  DailyOperationViewController.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DailyOperationVC.h"
#import "WayBillOpenViewController.h"

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
        NSInteger index = [(NSIndexPath *)userInfo row];
        if (index >= 0 && index < [UserPublic getInstance].dailyOperationAccesses.count) {
            AppAccessInfo *item = [UserPublic getInstance].dailyOperationAccesses[index];
            switch (item.sort) {
                case 1:{
                    WayBillOpenViewController *vc = [[WayBillOpenViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    vc.accessInfo = item;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

@end
