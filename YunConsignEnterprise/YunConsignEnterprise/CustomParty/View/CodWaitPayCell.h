//
//  CodWaitPayCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@interface CodWaitPayCell : PublicHeaderBodyFooterCell

@property (strong, nonatomic) UILabel *payStyleLabel;

@property (copy, nonatomic) AppCashOnDeliveryWayBillInfo *data;

@end
