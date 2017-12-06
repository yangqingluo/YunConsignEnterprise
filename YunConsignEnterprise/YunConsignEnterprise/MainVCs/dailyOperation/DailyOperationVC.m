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
#import "SearchQuantityVC.h"
#import "WaybillLoadVC.h"
#import "WaybillArrivalVC.h"
#import "WaybillReceiveVC.h"
#import "PayOnReceiptVC.h"
#import "CustomerManageVC.h"

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
//        if (nIndex == 0){
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            UIImage *i = [UIImage imageNamed:@"navbar_icon_menus"];
//            [btn setImage:i forState:UIControlStateNormal];
//            [btn setFrame:CGRectMake(0, 0, 64, 44)];
//            [btn addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
//            return btn;
//        }
        
        return nil;
    }];
}

- (void)editButtonAction {
    
}

#pragma mark - getter

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_BannerButtonClicked]) {
        NSInteger index = [(NSIndexPath *)userInfo row];
        NSArray *m_array = [UserPublic getInstance].dailyOperationAccesses;
        if (index >= 0 && index < m_array.count) {
            AppAccessInfo *item = m_array[index];
            if ([item.menu_code isEqualToString:@"WAYBILL_OPEN"]) {
                WayBillOpenVC *vc = [WayBillOpenVC new];
                vc.accessInfo = item;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ([item.menu_code isEqualToString:@"WAYBILL_QUERY"]) {
                WayBillQueryVC *vc = [WayBillQueryVC new];
                vc.accessInfo = item;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ([item.menu_code isEqualToString:@"REGISTERED_TRUCK"]) {
                TransportTruckVC *vc = [TransportTruckVC new];
                vc.accessInfo = item;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ([item.menu_code isEqualToString:@"SEARCH_QUANTITY"]) {
                SearchQuantityVC *vc = [SearchQuantityVC new];
                vc.accessInfo = item;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ([item.menu_code isEqualToString:@"WAYBILL_LOAD"]) {
                WaybillLoadVC *vc = [WaybillLoadVC new];
                vc.accessInfo = item;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ([item.menu_code isEqualToString:@"WAYBILL_ARRIVAL"]) {
                WaybillArrivalVC *vc = [WaybillArrivalVC new];
                vc.accessInfo = item;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ([item.menu_code isEqualToString:@"WAYBILL_RECEIVE"]) {
                WaybillReceiveVC *vc = [WaybillReceiveVC new];
                vc.accessInfo = item;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ([item.menu_code isEqualToString:@"PAY_ON_RECEIPT"]) {
                PayOnReceiptVC *vc = [PayOnReceiptVC new];
                vc.accessInfo = item;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ([item.menu_code isEqualToString:@"CUST_MANAGE"]) {
                CustomerManageVC *vc = [CustomerManageVC new];
                vc.accessInfo = item;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [self showHint:[NSString stringWithFormat:@"%@ 敬请期待", item.menu_name]];
            }
        }
    }
}

@end
