//
//  CodLoanCheckDetailCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodLoanCheckDetailCell.h"

@implementation CodLoanCheckDetailCell

- (void)setupBody {
    [super setupBody];
    
    _bodyLabelRight2 = NewLabel(CGRectMake(kEdge + 0.5 * self.bodyView.width, self.bodyLabel2.top, 0.5 * self.bodyView.width - 1 * kEdge, self.bodyLabel2.height), nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_bodyLabelRight2];
}

- (void)refreshFooter {
    NSArray *m_array = nil;
    if ([self.data.loan_apply_state integerValue] == 1) {
        m_array = @[@"驳回"];
    }
    [self.footerView updateDataSourceWithArray:m_array];
}

#pragma mark - setter
- (void)setData:(AppLoanApplyCheckWaybillInfo *)data {
    _data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"货号：%@", data.goods_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = data.system_check;
    self.statusLabel.textColor = [data.system_check isEqualToString:@"正常"] ? secondaryTextColor : WarningColor;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"客户：%@", data.cust_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"应收：%@", data.cash_on_delivery_amount];
    self.bodyLabel3.text = [NSString stringWithFormat:@"实收：%@", data.cash_on_delivery_real_amount];
    self.bodyLabelRight2.text = [NSString stringWithFormat:@"代收方式：%@", data.cash_on_delivery_type_text];
    [self refreshFooter];
}

@end
