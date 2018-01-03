//
//  CodRemitLoanApplyListCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodRemitLoanApplyListCell.h"

@implementation CodRemitLoanApplyListCell

- (void)setupBody {
    [super setupBody];
    
    _bodyLabelRight3 = NewLabel(CGRectMake(kEdge + 0.5 * self.bodyView.width, self.bodyLabel3.top, 0.5 * self.bodyView.width - 1 * kEdge, self.bodyLabel3.height), nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_bodyLabelRight3];
    
    _bodyLabel4 = NewLabel(self.bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _bodyLabel4.top = self.bodyLabel3.bottom + kEdge;
    [self.bodyView addSubview:_bodyLabel4];
}

- (void)setupFooter {
    [super setupFooter];
    [self.footerView updateDataSourceWithArray:@[@"运单明细"]];
}

#pragma mark - setter
- (void)setData:(AppCodLoanApplyWaitLoanInfo *)data {
    _data = data;
    self.titleLabel.text = data.cust_info;
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = data.remit_amount;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"申请金额：%@（%@）", data.apply_amount, data.apply_time];
    self.bodyLabel2.text = [NSString stringWithFormat:@"审核金额：%@（%@）", data.audit_amount, data.audit_time];
    self.bodyLabel3.text = [NSString stringWithFormat:@"审核人：%@", data.audit_name];
    self.bodyLabelRight3.text = [NSString stringWithFormat:@"手续费：%@", data.apply_amount_fee];
    NSUInteger lines = 3;
    self.bodyLabel4.hidden = YES;
    if (data.apply_note.length) {
        lines++;
        [self showLabel:self.bodyLabel4 conten:[NSString stringWithFormat:@"申请备注：%@", data.apply_note]];
    }
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
}

@end
