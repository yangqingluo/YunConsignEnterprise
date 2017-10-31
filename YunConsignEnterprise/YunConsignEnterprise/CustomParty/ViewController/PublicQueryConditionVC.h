//
//  PublicQueryConditionVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppBasicTableViewController.h"

typedef enum : NSUInteger {
    QueryConditionType_Default = 0,
    QueryConditionType_WaybillQuery,//运单查询
    QueryConditionType_TransportTruck,//派车查询
    QueryConditionType_WaybillLoad,//配载装车
    QueryConditionType_WaybillLoadTT,//配载装车-运单配载
    QueryConditionType_WaybillLoaded,//配载装车-已配载
    QueryConditionType_WaybillArrival,//到货交接
    QueryConditionType_WaybillArrivalDetail,//到货交接详情
    QueryConditionType_WaybillReceive,//客户自提
    QueryConditionType_PayOnReceipt,//回单付款
    QueryConditionType_CustomerManage,//客户管理
    QueryConditionType_FreightCheck,//运输款对账
} QueryConditionType;

@interface PublicQueryConditionVC : AppBasicTableViewController

@property (assign, nonatomic) QueryConditionType type;
@property (strong, nonatomic) AppQueryConditionInfo *condition;

@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) NSSet *dataDicSet;
@property (strong, nonatomic) NSSet *inputValidSet;
@property (strong, nonatomic) NSSet *boolValidSet;

@property (strong, nonatomic) UIView *footerView;

- (void)showFromVC:(AppBasicViewController *)fromVC;
- (void)checkDataMapExistedFor:(NSString *)key;

@end
