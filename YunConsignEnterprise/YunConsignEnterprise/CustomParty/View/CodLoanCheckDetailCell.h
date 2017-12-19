//
//  CodLoanCheckDetailCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@interface CodLoanCheckDetailCell : PublicHeaderBodyFooterCell

@property (strong, nonatomic) UILabel *payStyleLabel;
@property (strong, nonatomic) UILabel *bodyLabel4;
@property (strong, nonatomic) UILabel *bodyLabelRight4;
@property (strong, nonatomic) UILabel *rejectNoteLabel;//驳回原因
@property (assign, nonatomic) BOOL isChecker;//只有在审核者视角才显示驳回

@property (copy, nonatomic) AppLoanApplyCheckWaybillInfo *data;

@end
