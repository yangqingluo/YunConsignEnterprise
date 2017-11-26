//
//  AppBasicViewController.h
//  helloworld
//
//  Created by chen on 14/6/30.
//  Copyright (c) 2014年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+KGViewExtend.h"
#import "AppResponder.h"

#define iosVersion      ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface AppBasicViewController : UIViewController

@property (weak, nonatomic) AppBasicViewController *parentVC;
@property (strong, nonatomic) UIImageView *navigationBarView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *navBottomLine;
@property (copy,   nonatomic) DoneBlock doneBlock;
@property (copy,   nonatomic) AppAccessInfo *accessInfo;
@property (assign, nonatomic) BOOL needRefresh;
@property (strong, nonatomic) NSMutableSet *toCheckDataMapSet;


- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem;
- (void)dismissKeyboard;
- (void)needRefreshNotification:(NSNotification *)notification;
- (void)doShowHintFunction:(NSString *)hint;
- (void)doShowHudFunction;
- (void)doShowHudFunction:(NSString *)hint;
- (void)doHideHudFunction;
- (void)doPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)showFromVC:(AppBasicViewController *)fromVC;
- (void)editAtIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag andContent:(NSString *)content;
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray<__kindof UIViewController *> *)doPopToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSArray<__kindof UIViewController *> *)doPopToLastViewControllerSkip:(NSUInteger)skip animated:(BOOL)animated;
- (void)textFieldDidChange:(UITextField *)textField;

- (void)checkDataMapExistedForCode:(NSString *)key;
- (void)initialDataDictionaryForCode:(NSString *)dict_code;
- (void)pullDataDictionaryFunctionForCode:(NSString *)dict_code selectionInIndexPath:(NSIndexPath *)indexPath;
- (void)pullServiceArrayFunctionForCode:(NSString *)dict_code selectionInIndexPath:(NSIndexPath *)indexPath;
- (void)pullServiceArrayFunctionForCityID:(NSString *)open_city_id selectionInIndexPath:(NSIndexPath *)indexPath ;
- (void)pullCityArrayFunctionForCode:(NSString *)dict_code selectionInIndexPath:(NSIndexPath *)indexPath;
- (void)pullLoadServiceArrayFunctionForTransportTruckID:(NSString *)transport_truck_id selectionInIndexPath:(NSIndexPath *)indexPath;

@end
