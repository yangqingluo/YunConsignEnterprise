//
//  CodWaitPayCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodWaitPayCell.h"

@implementation CodWaitPayCell

- (void)setupBody {
    [super setupBody];
    _payStyleLabel = NewLabel(self.bodyLabel2.frame, secondaryTextColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    [self.bodyView addSubview:_payStyleLabel];
}

- (void)setupFooter {
    [super setupFooter];
    [self.footerView updateDataSourceWithArray:@[@"收款", @"设置备注"]];
}

#pragma mark - setter
- (void)setData:(AppCashOnDeliveryWayBillInfo *)data {
    _data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"货号：%@", data.goods_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = data.waybill_state_text;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"客户：%@", _data.cust_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"应收：%d", [_data.cash_on_delivery_amount intValue]];
    [AppPublic adjustLabelWidth:self.bodyLabel2];
    
    self.payStyleLabel.text = [data payStyleStringForState];
    [AppPublic adjustLabelWidth:self.payStyleLabel];
    self.payStyleLabel.left = self.bodyLabel2.right + kEdge;
    
    NSUInteger lines = 2;
    BOOL is_cash_on_delivery_note = data.cash_on_delivery_note.length > 0;
    self.bodyLabel3.hidden = !is_cash_on_delivery_note;
    if (is_cash_on_delivery_note) {
        lines++;
        self.bodyLabel3.text = [NSString stringWithFormat:@"备注：%@", _data.cash_on_delivery_note];
    }
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
}

@end
