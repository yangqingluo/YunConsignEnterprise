//
//  CodLoanApplyWaybillQueryCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/9.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodLoanApplyWaybillQueryCell.h"

@implementation CodLoanApplyWaybillQueryCell

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

#pragma mark - setter
- (void)setData:(AppWayBillDetailInfo *)data {
    _data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"货号：%@/%@", data.goods_number, data.waybill_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"客户：%@", data.cust_info];
    
    self.bodyLabel2.text = [NSString stringWithFormat:@"应收：%d", [_data.cash_on_delivery_amount intValue]];
    [AppPublic adjustLabelWidth:self.bodyLabel2];
    
    self.payStyleLabel.text = [data payStyleStringForState];
    [AppPublic adjustLabelWidth:self.payStyleLabel];
    self.payStyleLabel.left = self.bodyLabel2.right;
    
    NSUInteger lines = 3;
    if (isTrue(data.is_can_apply)) {
        self.statusLabel.textColor = MainColor;
        self.statusLabel.text = [NSString stringWithFormat:@"(%@)", data.print_check_code];
        
        self.bodyLabel3.textColor = baseTextColor;
        self.bodyLabel3.text = [NSString stringWithFormat:@"实收：%@", data.cash_on_delivery_real_amount];
        if (data.cash_on_delivery_real_time.length) {
            self.bodyLabel3.text = [NSString stringWithFormat:@"%@（ %@）", self.bodyLabel3.text, data.cash_on_delivery_real_time];
        }
        
        BOOL is_cash_on_delivery_causes = [data.cash_on_delivery_causes_amount intValue] > 0;
        self.bodyLabel4.hidden = !is_cash_on_delivery_causes;
        self.bodyLabelRight4.hidden = !is_cash_on_delivery_causes;
        if (is_cash_on_delivery_causes) {
            lines++;
            self.bodyLabel4.text = [NSString stringWithFormat:@"少款：%@", data.cash_on_delivery_causes_amount];
            self.bodyLabelRight4.text = [NSString stringWithFormat:@"少款原因：%@", data.cash_on_delivery_causes_note];
        }
    }
    else {
        self.statusLabel.text = @"";
        self.bodyLabel3.textColor = WarningColor;
        self.bodyLabel3.text = [NSString stringWithFormat:@"%@", data.not_can_apply_note];
    }
    
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
}

@end
