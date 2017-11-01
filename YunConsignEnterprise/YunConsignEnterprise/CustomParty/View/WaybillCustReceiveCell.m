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
    self.titleLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
    
    _urgentLabel = NewLabel(CGRectMake(self.titleLabel.right + kEdgeMiddle, self.titleLabel.top, 30, self.titleLabel.height), RGBA(0xc5, 0x2c, 0x2c, 1.0), [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    _urgentLabel.text = @"[急]";
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
    self.titleLabel.text = [NSString stringWithFormat:@"运单号：%@/%@", data.waybill_number, data.goods_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
    
    self.urgentLabel.hidden = !isTrue(data.is_urgent);
    self.receiptLabel.hidden = isTrue(data.is_receipt);
    
    if (!self.urgentLabel.hidden) {
        self.urgentLabel.left = self.titleLabel.right + kEdge;
        self.receiptLabel.left = self.urgentLabel.right + kEdge;
    }
    else if (!self.receiptLabel.hidden) {
        self.receiptLabel.left = self.titleLabel.right + kEdge;
    }
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"货物：%@", _data.goods_name];
    self.bodyLabel2.text = [NSString stringWithFormat:@"已收：%@", _data.pay_now_amount];
    self.bodyLabel3.text = [NSString stringWithFormat:@"回单付：%@", _data.pay_on_receipt_amount];
    self.bodyLabel4.text = [NSString stringWithFormat:@"代收款：%@", _data.cash_on_delivery_type_text];
    self.bodyLabelRight2.text = [NSString stringWithFormat:@"提付：%@", _data.pay_on_delivery_amount];
    self.bodyLabelRight3.text = [NSString stringWithFormat:@"运费代扣：%@", isTrue(_data.is_deduction_freight) ? @"是" : @"否"];
    self.bodyLabelRight4.text = [NSString stringWithFormat:@"金额：%@", _data.cash_on_delivery_amount];
    
}

@end
