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
//保价费率
@property (assign, nonatomic) double insuranceFeeRate;

//数据字典数据
@property (strong, nonatomic) NSMutableDictionary *dataMapDic;
NSString *serviceDataMapKeyForCity(NSString *open_city_id);
NSString *serviceDataMapKeyForTruck(NSString *transport_truck_id);

//检查是否是财务数据
@property (strong, nonatomic) AppCheckUserFinanceInfo *financeData;

//保存用户数据
- (void)saveUserData:(AppUserInfo *)data;
//保存用户报价费率
- (void)saveUserInsuranceFeeRate:(NSString *)data;
//清除
- (void)clear;

+ (NSString *)stringForType:(NSInteger)type key:(NSString *)key;
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

@end
