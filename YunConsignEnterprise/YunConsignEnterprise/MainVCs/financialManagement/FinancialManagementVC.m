//
//  FinancialManagementViewController.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "FinancialManagementVC.h"

@interface FinancialManagementVC ()

@end

@implementation FinancialManagementVC

- (void)viewDidLoad {
    [self setupNav];
    [super viewDidLoad];
    
    self.bannerView.dataSource = [UserPublic getInstance].financialManagementAccesses;
}

- (void)setupNav{
    [self createNavWithTitle:nil createMenuItem:^UIView *(int nIndex){
        //        if (nIndex == 0){
        //            UIButton *btn = NewTextButton(@"登出", [UIColor whiteColor]);
        //            [btn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        //            return btn;
        //        }
        
        return nil;
    }];
}

#pragma UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo{
    if ([eventName isEqualToString:Event_BannerButtonClicked]) {
        NSInteger index = [(NSIndexPath *)userInfo row];
        NSArray *m_array = [UserPublic getInstance].financialManagementAccesses;
        if (index >= 0 && index < m_array.count) {
            AppAccessInfo *item = m_array[index];
            if ([item.menu_code isEqualToString:@"FREIGHT_CHECK"]) {
//                WayBillOpenVC *vc = [[WayBillOpenVC alloc] initWithStyle:UITableViewStyleGrouped];
//                vc.accessInfo = item;
//                [self.navigationController pushViewController:vc animated:YES];
            }
//            else if ([item.menu_code isEqualToString:@"COD_QUERY"]) {
//                
//            }
//            else if ([item.menu_code isEqualToString:@"COD_WAIT_PAY"]) {
//                
//            }
//            else if ([item.menu_code isEqualToString:@"COD_CHECK"]) {
//                
//            }
//            else if ([item.menu_code isEqualToString:@"COD_LOAN_APPLY"]) {
//                
//            }
//            else if ([item.menu_code isEqualToString:@"COD_LOAN_CHECK"]) {
//                
//            }
//            else if ([item.menu_code isEqualToString:@"COD_REMIT"]) {
//                
//            }
//            else if ([item.menu_code isEqualToString:@"DAILY_REIMBURSEMENT_APPLY"]) {
//                
//            }
//            else if ([item.menu_code isEqualToString:@"DAILY_REIMBURSEMENT_CHECK"]) {
//                
//            }
            else {
                [self showHint:[NSString stringWithFormat:@"%@ 敬请期待", item.menu_name]];
            }
        }
    }
}

@end
