//
//  MainTabBarController.m
//  SafetyOfMAS
//
//  Created by yangqingluo on 16/9/9.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "MainTabBarController.h"
#import "DailyOperationVC.h"
#import "FinancialManagementVC.h"
#import "SystemConfigVC.h"

@interface MainTabBarController ()

@property (nonatomic, strong) NSArray *tabItemArray;

@end

@implementation MainTabBarController

- (instancetype)init{
    self = [super init];
    
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.viewControllers = @[[DailyOperationVC new], [FinancialManagementVC new], [SystemConfigVC new]];
        self.tabBar.backgroundImage = [[UIImage imageWithColor:[UIColor whiteColor]] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        self.tabBar.tintColor = MainColor;
        for (UIViewController *vc in self.viewControllers) {
            NSDictionary *dic = self.tabItemArray[[self.viewControllers indexOfObject:vc]];
            vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:dic[@"title"] image:[[UIImage imageNamed:dic[@"imageName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:dic[@"selectedImageName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            [self unSelectedTapTabBarItems:vc.tabBarItem];
            [self selectedTapTabBarItems:vc.tabBarItem];
        }
    }
    
    return self;
}

- (void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} forState:UIControlStateNormal];
}

- (void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} forState:UIControlStateSelected];
}

//#pragma tabbar annimation
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    NSInteger index = [self.tabBar.items indexOfObject:item];
//    
//    if (self.selectedIndex != index) {
//        [self animationWithIndex:index];
//    }
//}
//// 动画
//- (void)animationWithIndex:(NSInteger) index {
//    NSMutableArray *tabbarbuttonArray = [NSMutableArray array];
//    for (UIView *tabBarButton in self.tabBar.subviews) {
//        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            [tabbarbuttonArray addObject:tabBarButton];
//        }
//    }
//    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pulse.duration = 0.08;
//    pulse.repeatCount = 1;
//    pulse.autoreverses = YES;
//    pulse.fromValue = [NSNumber numberWithFloat:0.9];
//    pulse.toValue = [NSNumber numberWithFloat:1.1];
//    [[tabbarbuttonArray[index] layer] addAnimation:pulse forKey:nil];
//    
//}

#pragma getter
- (NSArray *)tabItemArray{
    if (!_tabItemArray) {
        _tabItemArray = @[@{@"title":@"日常操作",@"imageName":@"tabbar_icon_daily_normal",@"selectedImageName":@"tabbar_icon_daily_selected"},
                          @{@"title":@"财务管理",@"imageName":@"tabbar_icon_money_normal",@"selectedImageName":@"tabbar_icon_money_selected"},
                          @{@"title":@"系统设置",@"imageName":@"tabbar_icon_setting_normal",@"selectedImageName":@"tabbar_icon_setting_selected"}];
    }
    
    return _tabItemArray;
}

@end
