//
//  CodRemitCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodRemitCell.h"

@implementation CodRemitCell
- (void)refreshFooter {
    NSArray *m_array = @[@"发放完成", @"申请单", @"运单明细"];
    if (self.indextag != 0) {
        m_array = @[@"申请单", @"运单明细"];
    }
    [self.footerView updateDataSourceWithArray:m_array];
}

#pragma mark - setter
- (void)setData:(AppCodLoanApplyWaitLoanInfo *)data {
    _data = data;
    self.titleLabel.text = data.cust_info;
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = data.remit_amount;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"银行名称：%@", data.bank_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"银行账号：%@", data.bank_account];
    NSUInteger lines = 2;
    if (self.indextag == 0) {
        
    }
    else {
        lines++;
        self.bodyLabel3.text = [NSString stringWithFormat:@"打款人：%@（%@）", data.operator_name, data.operate_time];
    }
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
    [self refreshFooter];
}

@end
