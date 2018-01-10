//
//  WaybillArrivalDetailCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyCell.h"

@interface WaybillArrivalDetailCell : PublicHeaderBodyCell

@property (strong, nonatomic) UILabel *urgentLabel;
@property (strong, nonatomic) UILabel *bodyLabelRight2;

@property (copy, nonatomic) AppCanArrivalWayBillInfo *data;

@end
