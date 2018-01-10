//
//  WaybillCustReceiveCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillCustReceiveCell.h"

@implementation WaybillCustReceiveCell

- (void)setupHeader {
    [super setupHeader];
//    self.titleLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
    
    _urgentLabel = NewLabel(CGRectMake(self.titleLabel.right + kEdgeMiddle, self.titleLabel.top, 30, self.titleLabel.height), WarningColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    _urgentLabel.text = @"[送]";
    [AppPublic adjustLabelWidth:_urgentLabel];
    [self.headerView addSubview:_urgentLabel];
    
    _receiptLabel = NewLabel(CGRectMake(self.urgentLabel.right + kEdgeMiddle, self.titleLabel.top, 30, self.titleLabel.height), RGBA(0xc5, 0x2c, 0x2c, 1.0), [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    _receiptLabel.text = @"[回]";
    [AppPublic adjustLabelWidth:_receiptLabel];
    [self.headerView addSubview:_receiptLabel];
}

- (void)setupBody {
    [super setupBody];
    
    _bodyLabel4 = NewLabel(self.bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _bodyLabel4.top = self.bodyLabel3.bottom + kEdge;
    [self.bodyView addSubview:_bodyLabel4];
    
    _bodyLabelRight2 = NewLabel(CGRectMake(kEdge + 0.5 * self.bodyView.width, self.bodyLabel2.top, 0.5 * self.bodyView.width - 1 * kEdge, self.bodyLabel2.height), nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_bodyLabelRight2];
    
    _bodyLabelRight3 = NewLabel(CGRectMake(kEdge + 0.5 * self.bodyView.width, self.bodyLabel3.top, 0.5 * self.bodyView.width - 1 * kEdge, self.bodyLabel3.height), nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_bodyLabelRight3];
    
    _bodyLabelRight4 = NewLabel(CGRectMake(kEdge + 0.5 * self.bodyView.width, self.bodyLabel4.top, 0.5 * self.bodyView.width - 1 * kEdge, self.bodyLabel2.height), nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_bodyLabelRight4];
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:4];
}

#pragma mark - setter
- (void)setData:(AppPaymentWaybillInfo *)data {
    _data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"货号：%@", notNilString(data.goods_number, nil)];
    [AppPublic adjustLabelWidth:self.titleLabel];
    
    self.urgentLabel.hidden = !isTrue(data.is_deliver_goods);
    self.receiptLabel.hidden = !isTrue(data.is_receipt);
    
    if (!self.urgentLabel.hidden) {
        self.urgentLabel.left = self.titleLabel.right + kEdge;
        self.receiptLabel.left = self.urgentLabel.right + kEdge;
    }
    else if (!self.receiptLabel.hidden) {
        self.receiptLabel.left = self.titleLabel.right + kEdge;
    }
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"货物：%@/%@/%@", notNilString(_data.goods_name, nil), notNilString(_data.goods_packge, nil), notNilString(_data.goods_total, nil)];
    self.bodyLabel2.text = [NSString stringWithFormat:@"已收：%d", [_data.pay_now_amount intValue]];
    self.bodyLabelRight2.text = [NSString stringWithFormat:@"提付：%d", [_data.pay_on_delivery_amount intValue]];
    self.bodyLabel3.text = [NSString stringWithFormat:@"回单付：%d", [_data.pay_on_receipt_amount intValue]];
    
    self.bodyLabel4.hidden = YES;
    self.bodyLabelRight3.hidden = YES;
    self.bodyLabelRight4.hidden = YES;
    if ([_data.cash_on_delivery_amount integerValue] > 0) {
        [self showLabel:self.bodyLabel4 conten:[NSString stringWithFormat:@"代收款：%@", notNilString(_data.cash_on_delivery_type_text, nil)]];
        [self showLabel:self.bodyLabelRight3 conten:[NSString stringWithFormat:@"运费代扣：%@", isTrue(_data.is_deduction_freight) ? @"是" : @"否"]];
        [self showLabel:self.bodyLabelRight4 conten:[NSString stringWithFormat:@"金额：%d", [_data.cash_on_delivery_amount intValue]]];
    }
    
    if (!_data) {
        self.titleLabel.text = @"货号：";
        self.bodyLabel1.text = @"货物：";
    }
}

@end
