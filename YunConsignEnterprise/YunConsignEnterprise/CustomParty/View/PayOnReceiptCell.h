//
//  PayOnReceiptCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@interface PayOnReceiptCell : PublicHeaderBodyFooterCell

@property (strong, nonatomic) UILabel *urgentLabel;
@property (strong, nonatomic) UILabel *payLabel;

@property (copy, nonatomic) AppNeedReceiptWayBillInfo *data;

@end
