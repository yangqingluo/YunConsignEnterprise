//
//  WaybillReceiveCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@interface WaybillReceiveCell : PublicHeaderBodyFooterCell

@property (strong, nonatomic) UILabel *urgentLabel;
@property (strong, nonatomic) UILabel *payStyleLabel;

@property (copy, nonatomic) AppCanReceiveWayBillInfo *data;

@end
