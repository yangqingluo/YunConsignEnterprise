//
//  MainTabNavController.m
//  SafetyOfMAS
//
//  Created by yangqingluo on 16/9/9.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "MainTabNavController.h"

@interface MainTabNavController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation MainTabNavController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.navigationBarHidden = true;
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.childViewControllers.count > 1;
}

@end
