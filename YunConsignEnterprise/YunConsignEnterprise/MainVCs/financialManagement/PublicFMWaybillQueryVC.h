//
//  PublicFMWaybillQueryVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicResultTableVC.h"

typedef NS_ENUM(NSInteger, FMWaybillQueryType) {
    FMWaybillQueryType_DEFAULT = 0,
    FMWaybillQueryType_DailyReimburse,//报销申请运单
    FMWaybillQueryType_CodLoanApply,//代收款放款申请
};

@interface PublicFMWaybillQueryVC : PublicResultTableVC

@property (assign, nonatomic) FMWaybillQueryType type;
@property (strong, nonatomic) AppWayBillDetailInfo *selectedData;

@end
