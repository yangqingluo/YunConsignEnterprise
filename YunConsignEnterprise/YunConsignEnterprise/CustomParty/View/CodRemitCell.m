//
//  CodRemitCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodRemitCell.h"

@implementation CodRemitCell

- (void)setupFooter {
    [super setupFooter];
    [self.footerView updateDataSourceWithArray:@[@"申请单", @"运单明细"]];
}

#pragma mark - setter
- (void)setData:(AppCodLoanApplyWaitLoanInfo *)data {
    _data = data;
    self.titleLabel.text = data.cust_info;
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = data.remit_amount;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"银行名称：%@", data.bank_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"银行账号：%@", data.bank_account];
    self.bodyLabel3.text = [NSString stringWithFormat:@"打款人：%@（%@）", data.operator_name, data.operate_time];
}

@end
