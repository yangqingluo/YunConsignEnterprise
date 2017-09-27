//
//  DailyOperationViewController.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DailyOperationVC.h"
#import "WayBillOpenVC.h"
#import "WayBillQueryVC.h"
#import "TransportTruckVC.h"

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
        NSArray *m_array = [UserPublic getInstance].dailyOperationAccesses;
        if (index >= 0 && index < m_array.count) {
            AppAccessInfo *item = m_array[index];
            switch (item.sort) {
                case 1:{
                    WayBillOpenVC *vc = [[WayBillOpenVC alloc] initWithStyle:UITableViewStyleGrouped];
                    vc.accessInfo = item;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                case 2: {
                    WayBillQueryVC *vc = [[WayBillQueryVC alloc]initWithStyle:UITableViewStyleGrouped];
                    vc.accessInfo = item;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                case 3: {
                    TransportTruckVC *vc = [TransportTruckVC new];
                    vc.accessInfo = item;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                default:{
                    [self showHint:[NSString stringWithFormat:@"%@ 敬请期待", item.menu_name]];
                }
                    break;
            }
        }
    }
}

@end
