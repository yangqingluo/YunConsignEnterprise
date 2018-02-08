//
//  FinancialManagementViewController.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "FinancialManagementVC.h"
#import "FreightCheckVC.h"
#import "FreightNotPayVC.h"
#import "CodQueryVC.h"
#import "CodWaitPayVC.h"
#import "CodCheckVC.h"
#import "CodLoanApplyVC.h"
#import "CodLoanCheckVC.h"
#import "CodRemitVC.h"
#import "DailyReimbursementApplyVC.h"
#import "DailyReimbursementCheckVC.h"
#import "GrossMarginCountVC.h"

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
            AppBasicViewController *vc = nil;
            if ([item.menu_code isEqualToString:@"FREIGHT_CHECK"]) {
                vc = [FreightCheckVC new];
            }
            else if ([item.menu_code isEqualToString:@"FREIGHT_NOT_PAY"]) {
                vc = [FreightNotPayVC new];
            }
            else if ([item.menu_code isEqualToString:@"COD_QUERY"]) {
                vc = [CodQueryVC new];
            }
            else if ([item.menu_code isEqualToString:@"COD_WAIT_PAY"]) {
                vc = [CodWaitPayVC new];
            }
            else if ([item.menu_code isEqualToString:@"COD_CHECK"]) {
                vc = [CodCheckVC new];
            }
            else if ([item.menu_code isEqualToString:@"COD_LOAN_APPLY"]) {
                vc = [CodLoanApplyVC new];
            }
            else if ([item.menu_code isEqualToString:@"COD_LOAN_CHECK"]) {
                vc = [CodLoanCheckVC new];
            }
            else if ([item.menu_code isEqualToString:@"COD_REMIT"]) {
                vc = [CodRemitVC new];
            }
            else if ([item.menu_code isEqualToString:@"DAILY_REIMBURSEMENT_APPLY"]) {
                vc = [DailyReimbursementApplyVC new];
            }
            else if ([item.menu_code isEqualToString:@"DAILY_REIMBURSEMENT_CHECK"]) {
                vc = [DailyReimbursementCheckVC new];
            }
            else if ([item.menu_code isEqualToString:@"GROSS_MARGIN_COUNT"]) {
                vc = [GrossMarginCountVC new];
            }
            
            if (vc) {
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
