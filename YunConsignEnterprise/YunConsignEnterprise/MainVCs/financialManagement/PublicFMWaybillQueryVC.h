//
//  PublicFMWaybillQueryVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppBasicTableViewController.h"

typedef NS_ENUM(NSInteger, FMWaybillQueryType) {
    FMWaybillQueryType_DEFAULT = 0,
    FMWaybillQueryType_DailyReimburse,//报销申请运单选择
};

@interface PublicFMWaybillQueryVC : AppBasicTableViewController

@property (assign, nonatomic) FMWaybillQueryType type;

@end
