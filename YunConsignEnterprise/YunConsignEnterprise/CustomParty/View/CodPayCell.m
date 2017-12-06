//
//  CodPayCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/12/1.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodPayCell.h"

@implementation CodPayCell

- (void)setupHeader {
    [super setupHeader];
    self.titleLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
}

- (void)setupBody {
    [super setupBody];
    
    _bodyLabelMiddle2 = NewLabel(self.bodyLabel2.frame, nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_bodyLabelMiddle2];
    
    _bodyLabelRight2 = NewLabel(self.bodyLabel2.frame, nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_bodyLabelRight2];
    
    CGFloat width = (self.bodyView.width - 2 * self.bodyLabel2.left ) / 3.0;
    self.bodyLabel2.width = width;
    self.bodyLabelMiddle2.width = width;
    self.bodyLabelMiddle2.left = self.bodyLabel2.right;
    self.bodyLabelRight2.width = width;
    self.bodyLabelRight2.left = self.bodyLabelMiddle2.right;
    
    _payStyleLabel = NewLabel(self.bodyLabel3.frame, secondaryTextColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    [self.bodyView addSubview:_payStyleLabel];
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:3];
}

#pragma mark - setter
- (void)setData:(AppPaymentWaybillInfo *)data {
    _data = data;
    
    self.titleLabel.text = [NSString stringWithFormat:@"货号：%@/%@", notNilString(data.goods_number, nil), notNilString(data.waybill_number, nil)];
    [AppPublic adjustLabelWidth:self.titleLabel];
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"货物：%@/%@/%@", notNilString(_data.goods_name, nil), notNilString(_data.goods_packge, nil), notNilString(_data.goods_total, nil)];
    self.bodyLabel2.text = [NSString stringWithFormat:@"已收：%d", [_data.pay_now_amount intValue]];
    self.bodyLabelMiddle2.text = [NSString stringWithFormat:@"提付：%d", [_data.pay_on_delivery_amount intValue]];
    self.bodyLabelRight2.text = [NSString stringWithFormat:@"回单付：%d", [_data.pay_on_receipt_amount intValue]];
    self.bodyLabel3.text = [NSString stringWithFormat:@"代收款：%d", [_data.cash_on_delivery_amount intValue]];
    [AppPublic adjustLabelWidth:self.bodyLabel3];
    self.payStyleLabel.text = [data payStyleStringForState];
    [AppPublic adjustLabelWidth:self.payStyleLabel];
    self.payStyleLabel.left = self.bodyLabel3.right;
    
    if (!_data) {
        self.titleLabel.text = @"货号：";
        self.bodyLabel1.text = @"货物：";
    }
}

@end
