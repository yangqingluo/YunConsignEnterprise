//
//  AppBasicViewController.h
//  helloworld
//
//  Created by chen on 14/6/30.
//  Copyright (c) 2014年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+KGViewExtend.h"

#define iosVersion      ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface AppBasicViewController : UIViewController

@property (weak, nonatomic) AppBasicViewController *parentVC;
@property (strong, nonatomic) UIImageView *navigationBarView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *navBottomLine;
@property (copy,   nonatomic) DoneBlock doneBlock;
@property (copy,   nonatomic) AppAccessInfo *accessInfo;
@property (assign, nonatomic) BOOL needRefresh;

- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem;
- (void)dismissKeyboard;
- (void)needRefreshNotification:(NSNotification *)notification;
- (void)doShowHintFunction:(NSString *)hint;
- (void)doShowHudFunction;
- (void)doShowHudFunction:(NSString *)hint;
- (void)doHideHudFunction;
- (void)doPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)textFieldDidChange:(UITextField *)textField;

@end
