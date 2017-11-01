//
//  CodQueryCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/1.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyCell.h"

@interface CodQueryCell : PublicHeaderBodyCell

@property (strong, nonatomic) UILabel *payStyleLabel;
@property (strong, nonatomic) UILabel *bodyLabel4;
@property (strong, nonatomic) UILabel *bodyLabelRight4;
@property (strong, nonatomic) UILabel *bodyLabel5;

@property (copy, nonatomic) AppCashOnDeliveryWayBillInfo *data;

@end
