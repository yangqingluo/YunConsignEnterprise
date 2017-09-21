//
//  UserPublic.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTabNavController.h"

@interface UserPublic : NSObject

+ (UserPublic *)getInstance;

//MaintabNav
@property (strong, nonatomic) MainTabNavController *mainTabNav;

//用户登陆数据
@property (strong, nonatomic) AppUserInfo *userData;

//日常操作权限
@property (strong, nonatomic) NSMutableArray *dailyOperationAccesses;
//财务管理权限
@property (strong, nonatomic) NSMutableArray *financialManagementAccesses;
//系统设置权限
@property (strong, nonatomic) NSMutableArray *systemConfigAccesses;

@property (strong, nonatomic) NSArray *receptSignTypeArray;
@property (strong, nonatomic) NSArray *cashOnDeliveryTypeArray;

//保存用户数据
- (void)saveUserData:(AppUserInfo *)data;
//清除
- (void)clear;

+ (NSString *)stringForReceptSignType:(RECEIPT_SIGN_TYPE)type;
+ (NSString *)stringForCashOnDeliveryType:(CASH_ON_DELIVERY_TYPE)type;

@end
