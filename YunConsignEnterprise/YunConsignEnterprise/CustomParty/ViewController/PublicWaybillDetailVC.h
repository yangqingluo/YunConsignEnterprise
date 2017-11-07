//
//  PublicWaybillDetailVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicDailyOpenWaybillVC.h"

typedef NS_ENUM(NSInteger, WaybillDetailType) {
    WaybillDetailType_WayBillQuery = 0,
    WaybillDetailType_CodQuery,
};

@interface PublicWaybillDetailVC : PublicDailyOpenWaybillVC

@property (assign, nonatomic) WaybillDetailType type;
@property (copy, nonatomic) AppWayBillInfo *data;

@end
