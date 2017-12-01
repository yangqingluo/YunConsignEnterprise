//
//  CodPayCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/12/1.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyCell.h"

@interface CodPayCell : PublicHeaderBodyCell

@property (strong, nonatomic) UILabel *urgentLabel;
@property (strong, nonatomic) UILabel *receiptLabel;
@property (strong, nonatomic) UILabel *bodyLabelMiddle2;
@property (strong, nonatomic) UILabel *bodyLabelRight2;
@property (strong, nonatomic) UILabel *payStyleLabel;

@property (copy, nonatomic) AppPaymentWaybillInfo *data;

@end
