//
//  QueryWaybillReimburseListCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/9.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "QueryWaybillReimburseListCell.h"

@implementation QueryWaybillReimburseListCell

#pragma mark - setter
- (void)setData:(AppDailyReimbursementApplyInfo *)data {
    _data = data;
    self.titleLabel.text = data.daily_info;
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = data.daily_apply_state_text;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"申请时间：%@", data.apply_time];
    self.bodyLabel2.text = [NSString stringWithFormat:@"申请编号：%@", data.daily_apply_id];
    
    NSUInteger lines = 2;
    if (data.note.length) {
        lines ++;
        self.bodyLabel3.text = [NSString stringWithFormat:@"申请备注：%@", data.note];
    }
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
}

@end
