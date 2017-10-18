//
//  WayBillCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@interface WayBillCell : PublicHeaderBodyFooterCell

@property (strong, nonatomic) UILabel *urgentLabel;
@property (strong, nonatomic) UIImageView *statusImageView;

@property (strong, nonatomic) UILabel *payNowLabel;
@property (strong, nonatomic) UILabel *payOnReceiptLabel;

@property (copy, nonatomic) AppWayBillInfo *data;

@end
