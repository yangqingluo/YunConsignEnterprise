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
    _payStyleLabel = NewLabel(self.bodyLabel2.frame, secondaryTextColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    [self.bodyView addSubview:_payStyleLabel];

    _bodyLabel4 = NewLabel(self.bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _bodyLabel4.top = self.bodyLabel3.bottom + kEdge;
    [self.bodyView addSubview:_bodyLabel4];
    
    _bodyLabelRight4 = NewLabel(CGRectMake(kEdge + 0.5 * self.bodyView.width, self.bodyLabel4.top, 0.5 * self.bodyView.width - 1 * kEdge, self.bodyLabel4.height), nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_bodyLabelRight4];
}

- (void)refreshFooter {
    if (!self.isChecker) {
        self.footerView.hidden = YES;
        return;
    }
    
    NSArray *m_array = nil;
    if ([self.data.loan_apply_state integerValue] == LOAN_APPLY_STATE_1) {
        m_array = @[@"驳回"];
        self.footerView.hidden = NO;
        [self.footerView updateDataSourceWithArray:m_array];
    }
    else {
        self.footerView.hidden = YES;
    }
}

#pragma mark - setter
- (void)setData:(AppLoanApplyCheckWaybillInfo *)data {
    _data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"货号：%@", data.goods_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
    if (data.loan_apply_state_text) {
        self.statusLabel.text = data.loan_apply_state_text;
        self.statusLabel.textColor = ([data.loan_apply_state integerValue] == LOAN_APPLY_STATE_3) ? WarningColor : secondaryTextColor;
    }
    else {
        self.statusLabel.text = data.system_check;
        self.statusLabel.textColor = [data.system_check isEqualToString:@"正常"] ? secondaryTextColor : WarningColor;
    }
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"客户：%@", notNilString(data.cust_info, nil)];
    self.bodyLabel2.text = [NSString stringWithFormat:@"应收：%@", notNilString(data.cash_on_delivery_amount, nil)];
    [AppPublic adjustLabelWidth:self.bodyLabel2];
    
    self.payStyleLabel.text = [data payStyleStringForState];
    [AppPublic adjustLabelWidth:self.payStyleLabel];
    self.payStyleLabel.left = self.bodyLabel2.right;
    
    self.bodyLabel3.text = [NSString stringWithFormat:@"实收：%@", notNilString(data.cash_on_delivery_real_amount, nil)];
    if (data.cash_on_delivery_real_time.length) {
        self.bodyLabel3.text = [NSString stringWithFormat:@"%@（ %@）", self.bodyLabel3.text, data.cash_on_delivery_real_time];
    }
    NSUInteger lines = 3;
    BOOL is_cash_on_delivery_causes = [data.cash_on_delivery_causes_amount intValue] > 0;
    self.bodyLabel4.hidden = !is_cash_on_delivery_causes;
    self.bodyLabelRight4.hidden = !is_cash_on_delivery_causes;
    if (is_cash_on_delivery_causes) {
        lines++;
        self.bodyLabel4.text = [NSString stringWithFormat:@"少款：%@", data.cash_on_delivery_causes_amount];
        if (data.cash_on_delivery_causes_note.length) {
            self.bodyLabelRight4.text = [NSString stringWithFormat:@"少款原因：%@", data.cash_on_delivery_causes_note];
        }
    }
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
    [self refreshFooter];
}

@end
