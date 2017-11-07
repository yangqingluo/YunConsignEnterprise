//
//  CodLoanCheckCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodLoanCheckCell.h"

@implementation CodLoanCheckCell

- (void)refreshFooter {
    NSArray *m_array = @[@"运单明细"];
    [self.footerView updateDataSourceWithArray:m_array];
}

#pragma mark - setter
- (void)setData:(AppCodLoanApplyInfo *)data {
    _data = data;
    self.titleLabel.text = data.cust_info;
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = dateStringWithTimeString(data.loan_apply_state_text);
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"银行信息：%@", data.bank_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"申请金额：%@（%@）", data.apply_amount, data.apply_time];
    self.bodyLabel3.text = [NSString stringWithFormat:@"审核金额：%@（%@）", data.audit_amount, data.audit_time];
    [self refreshFooter];
}

@end
