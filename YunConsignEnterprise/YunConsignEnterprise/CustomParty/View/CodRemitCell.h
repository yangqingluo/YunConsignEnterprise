//
//  CodRemitCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@interface CodRemitCell : PublicHeaderBodyFooterCell

@property (assign, nonatomic) NSInteger indextag;

@property (copy, nonatomic) AppCodLoanApplyWaitLoanInfo *data;

@end
