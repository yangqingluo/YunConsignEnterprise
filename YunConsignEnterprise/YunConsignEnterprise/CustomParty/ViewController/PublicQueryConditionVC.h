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
} QueryConditionType;

@interface PublicQueryConditionVC : AppBasicTableViewController

@property (assign, nonatomic) QueryConditionType type;
@property (strong, nonatomic) AppQueryConditionInfo *condition;

@end
