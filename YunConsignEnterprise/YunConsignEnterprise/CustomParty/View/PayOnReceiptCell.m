//
//  PayOnReceiptCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PayOnReceiptCell.h"

@implementation PayOnReceiptCell

- (void)setupHeader {
    [super setupHeader];
    _urgentLabel = NewLabel(CGRectMake(self.titleLabel.right + kEdgeMiddle, self.titleLabel.top, 30, self.titleLabel.height), WarningColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    _urgentLabel.text = @"[急]";
    [AppPublic adjustLabelWidth:_urgentLabel];
    [self.headerView addSubview:_urgentLabel];
}

- (void)setupBody {
    [super setupBody];
    _payLabel = NewLabel(CGRectMake(kEdge + 0.5 * self.bodyView.width, self.bodyLabel3.top, 0.5 * self.bodyView.width - 1 * kEdge, self.bodyLabel3.height), nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_payLabel];
}

- (void)refreshFooter {
    NSArray *m_array = @[@"付款"];
    if ([self.data.receipt_state integerValue] == RECEIPT_STATE_TYPE_3) {
        m_array = @[@"取消付款"];
    }
    [self.footerView updateDataSourceWithArray:m_array];
}

#pragma mark - setter
- (void)setData:(AppNeedReceiptWayBillInfo *)data {
    _data = data;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@：%@", _data.route, _data.goods_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
    
    if (isTrue(_data.is_urgent)) {
        self.urgentLabel.hidden = NO;
        self.urgentLabel.left = self.titleLabel.right + kEdgeMiddle;
    }
    else {
        self.urgentLabel.hidden = YES;
    }
    self.statusLabel.text = _data.receipt_state_text;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"货物：%@", _data.goods];
    self.bodyLabel2.text = [NSString stringWithFormat:@"发货人：%@", _data.shipper];
    self.bodyLabel3.text = [NSString stringWithFormat:@"回单：%@", [_data showReceiptSignTypeString]];
    [AppPublic adjustLabelWidth:self.bodyLabel3];
    
    self.payLabel.text = [NSString stringWithFormat:@"回单付：%@", _data.pay_on_receipt_amount];
    [self refreshFooter];
}

@end
