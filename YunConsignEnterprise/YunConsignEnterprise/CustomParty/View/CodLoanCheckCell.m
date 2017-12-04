//
//  CodLoanCheckCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodLoanCheckCell.h"

@implementation CodLoanCheckCell

- (void)setupBody {
    [super setupBody];
    _bodyLabelRight3 = NewLabel(CGRectMake(kEdge + 0.5 * self.bodyView.width, self.bodyLabel3.top, 0.5 * self.bodyView.width - 1 * kEdge, self.bodyLabel3.height), nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_bodyLabelRight3];
    
    _bodyLabel4 = NewLabel(self.bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _bodyLabel4.top = self.bodyLabel3.bottom + kEdge;
    [self.bodyView addSubview:_bodyLabel4];
}

- (void)refreshFooter {
    NSArray *m_array = @[@"审核通过", @"运单明细"];
    if (self.indextag != 0) {
        m_array = @[@"运单明细"];
    }
    [self.footerView updateDataSourceWithArray:m_array];
}

#pragma mark - setter
- (void)setData:(AppCodLoanApplyInfo *)data {
    _data = data;
    self.titleLabel.text = data.cust_info;
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = data.loan_apply_state_text;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"银行信息：%@", data.bank_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"申请金额：%@（%@）", data.apply_amount, data.apply_time];
    NSUInteger lines = 3;
    if (self.indextag == 0) {
        self.bodyLabel3.text = [NSString stringWithFormat:@"实际放款：%@", data.audit_amount];
        self.bodyLabelRight3.text = [NSString stringWithFormat:@"手续费：%@", data.apply_amount_fee];
    }
    else {
        self.bodyLabel3.text = [NSString stringWithFormat:@"审核金额：%@（%@）", data.audit_amount, data.audit_time];
    }
    
    if (self.indextag == 0) {
        self.bodyLabel4.text = @"";
        if (data.apply_note.length) {
            lines++;
            self.bodyLabel4.text = [NSString stringWithFormat:@"申请备注：%@", data.apply_note];
        }
        self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
    }
    
    [self refreshFooter];
}

@end
