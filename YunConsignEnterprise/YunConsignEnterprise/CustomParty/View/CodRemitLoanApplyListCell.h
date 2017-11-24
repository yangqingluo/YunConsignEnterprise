//
//  CodRemitLoanApplyListCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@interface CodRemitLoanApplyListCell : PublicHeaderBodyFooterCell

@property (strong, nonatomic) UILabel *bodyLabelRight3;
@property (strong, nonatomic) UILabel *bodyLabel4;

@property (copy, nonatomic) AppCodLoanApplyWaitLoanInfo *data;

@end
