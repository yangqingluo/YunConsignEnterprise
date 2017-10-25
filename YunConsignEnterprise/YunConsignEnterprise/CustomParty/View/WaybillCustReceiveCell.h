//
//  WaybillCustReceiveCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyCell.h"

@interface WaybillCustReceiveCell : PublicHeaderBodyCell

@property (strong, nonatomic) UILabel *urgentLabel;
@property (strong, nonatomic) UILabel *receiptLabel;
@property (strong, nonatomic) UILabel *bodyLabelRight2;
@property (strong, nonatomic) UILabel *bodyLabelRight3;
@property (strong, nonatomic) UILabel *bodyLabel4;
@property (strong, nonatomic) UILabel *bodyLabelRight4;


@property (copy, nonatomic) AppPaymentWaybillInfo *data;

@end
