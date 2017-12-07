//
//  CodLoanApplyDetailCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/12/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodLoanApplyDetailCell.h"

@implementation CodLoanApplyDetailCell

#pragma mark - setter
- (void)setData:(AppLoanApplyCheckWaybillInfo *)data {
    super.data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"%@：%@", @"货号", data.goods_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
}

@end
