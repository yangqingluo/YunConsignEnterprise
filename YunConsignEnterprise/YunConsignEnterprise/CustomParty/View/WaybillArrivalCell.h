//
//  WaybillArrivalCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@interface WaybillArrivalCell : PublicHeaderBodyFooterCell

@property (strong, nonatomic) UILabel *arriveTimeLabel;
@property (strong, nonatomic) UILabel *noHandoverLabel;

@property (copy, nonatomic) AppCanArrivalTransportTruckInfo *data;

@end
