//
//  DailyReimbursementApplyCell.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/6.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicHeaderBodyFooterCell.h"

@interface DailyReimbursementApplyCell : PublicHeaderBodyFooterCell

@property (assign, nonatomic) NSInteger indextag;
@property (strong, nonatomic) UILabel *bodyLabel4;

@property (copy, nonatomic) AppDailyReimbursementApplyInfo *data;

@end
