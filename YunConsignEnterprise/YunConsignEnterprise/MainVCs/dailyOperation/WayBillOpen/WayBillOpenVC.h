//
//  WayBillOpenVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/19.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicDailyOpenWaybillVC.h"
#import "PublicSRSelectVC.h"
#import "AddGoodsVC.h"

#import "BlockAlertView.h"
#import "BlockActionSheet.h"
#import "WayBillSRHeaderView.h"

@interface WayBillOpenVC : PublicDailyOpenWaybillVC {
    BOOL is_update_waybill_item;
}

@property (strong, nonatomic) WayBillSRHeaderView *headerView;
@property (strong, nonatomic) UIView *footerView;

@property (strong, nonatomic) NSMutableArray *goodsArray;
//@property (strong, nonatomic) AppGoodsInfo *goodsSummary;

@property (strong, nonatomic) AppSaveWayBillInfo *toSaveData;

@end
