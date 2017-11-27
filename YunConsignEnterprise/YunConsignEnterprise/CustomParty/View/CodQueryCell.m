//
//  CodQueryCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/1.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodQueryCell.h"

@implementation CodQueryCell

- (void)setupBody {
    [super setupBody];
    _payStyleLabel = NewLabel(self.bodyLabel2.frame, secondaryTextColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    [self.bodyView addSubview:_payStyleLabel];
    
    _bodyLabel4 = NewLabel(self.bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _bodyLabel4.top = self.bodyLabel3.bottom + kEdge;
    [self.bodyView addSubview:_bodyLabel4];
    
    _bodyLabelRight4 = NewLabel(CGRectMake(kEdge + 0.5 * self.bodyView.width, self.bodyLabel4.top, 0.5 * self.bodyView.width - 1 * kEdge, self.bodyLabel4.height), nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_bodyLabelRight4];
    
    _bodyLabel5 = NewLabel(self.bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _bodyLabel5.top = self.bodyLabel4.bottom + kEdge;
    [self.bodyView addSubview:_bodyLabel5];
}

#pragma mark - setter
- (void)setData:(AppCashOnDeliveryWayBillInfo *)data {
    _data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"%@：%@", data.goods_number, data.goods_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = data.cash_on_delivery_state_text;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"客户：%@", _data.cust_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"应收：%@", _data.cash_on_delivery_amount];
    [AppPublic adjustLabelWidth:self.bodyLabel2];
    
    self.payStyleLabel.text = [data payStyleStringForState];
    [AppPublic adjustLabelWidth:self.payStyleLabel];
    self.payStyleLabel.left = self.bodyLabel2.right;
    
    self.bodyLabel3.text = [NSString stringWithFormat:@"实收：%@", data.cash_on_delivery_real_amount];
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
        self.bodyLabelRight4.text = [NSString stringWithFormat:@"少款原因：%@", data.cash_on_delivery_causes_note];
    }
    
    BOOL is_cash_on_delivery = [data.cash_on_delivery_state intValue] == 6;
    self.bodyLabel5.hidden = YES;
    if (is_cash_on_delivery) {
        lines++;
        if (is_cash_on_delivery_causes) {
            self.bodyLabel5.text = [NSString stringWithFormat:@"放款：%@（ %@）", data.remitter_name, data.remittance_time];
            self.bodyLabel5.hidden = NO;
        }
        else {
            self.bodyLabel4.text = [NSString stringWithFormat:@"放款：%@（ %@）", data.remitter_name, data.remittance_time];
            self.bodyLabel4.hidden = NO;
        }
    }
    
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
}

@end
