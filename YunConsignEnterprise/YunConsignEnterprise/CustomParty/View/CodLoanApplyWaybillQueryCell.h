//
//  CodLoanApplyWaybillQueryCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/9.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyCell.h"

@interface CodLoanApplyWaybillQueryCell : PublicHeaderBodyCell

@property (strong, nonatomic) UILabel *payStyleLabel;
@property (strong, nonatomic) UILabel *bodyLabel4;
@property (strong, nonatomic) UILabel *bodyLabelRight4;

@property (copy, nonatomic) AppWayBillDetailInfo *data;

@end
