//
//  AppDelegate.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/5.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

static void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    AppDataDictionary *m_url = [AppPublic getInstance].selectedURLZone;
    if (m_url) {
        if ((m_url.item_sort == 1 && [m_url.item_val isEqualToString:@"http://demo.tms.yunlaila.com.cn"]) || (m_url.item_sort == 2 && [m_url.item_val isEqualToString:@"http://tms.yunlaila.com.cn"])) {
            [[AppPublic getInstance] clearURLZone];
            [[UserPublic getInstance] clear];
        }
    }
    
    if ([UserPublic getInstance].userData) {
        [[AppPublic getInstance] goToMainVC];
    }
    else {
        [[AppPublic getInstance] goToLoginCompletion:nil];
    }
    
//    if (@available(iOS 11.0, *)) {
//        UITableView.appearance.estimatedRowHeight = 0;
//        UITableView.appearance.estimatedSectionHeaderHeight = 0;
//        UITableView.appearance.estimatedSectionFooterHeight = 0;
//        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
