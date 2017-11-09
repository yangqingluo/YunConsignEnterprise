//
//  CodLoanCheckCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@interface CodLoanCheckCell : PublicHeaderBodyFooterCell

@property (strong, nonatomic) UILabel *bodyLabelRight3;
@property (strong, nonatomic) UILabel *bodyLabel4;

@property (assign, nonatomic) NSInteger indextag;

@property (copy, nonatomic) AppCodLoanApplyInfo *data;

@end
