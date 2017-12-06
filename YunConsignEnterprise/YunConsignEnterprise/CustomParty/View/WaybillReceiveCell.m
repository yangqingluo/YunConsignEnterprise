//
//  WaybillReceiveCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/18.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillReceiveCell.h"

@implementation WaybillReceiveCell

- (void)setupHeader {
    [super setupHeader];
    _urgentLabel = NewLabel(CGRectMake(self.titleLabel.right + kEdgeMiddle, self.titleLabel.top, 30, self.titleLabel.height), WarningColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    _urgentLabel.text = @"[送]";
    [AppPublic adjustLabelWidth:_urgentLabel];
    [self.headerView addSubview:_urgentLabel];
}

- (void)setupFooter {
    [super setupFooter];
    NSArray *m_array = @[@"原货返回", @"打印", @"自提"];
    [self.footerView updateDataSourceWithArray:m_array];
}

- (void)setupBody {
    [super setupBody];
    _payStyleLabel = NewLabel(self.bodyLabel3.frame, secondaryTextColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    [self.bodyView addSubview:_payStyleLabel];
}

#pragma mark - setter
- (void)setData:(AppCanReceiveWayBillInfo *)data {
    _data = data;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@：%@", _data.route, _data.goods_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
    
    if (isTrue(_data.is_deliver_goods)) {
        self.urgentLabel.hidden = NO;
        self.urgentLabel.left = self.titleLabel.right + kEdgeMiddle;
    }
    else {
        self.urgentLabel.hidden = YES;
    }
    self.statusLabel.text = _data.total_amount;

    self.bodyLabel1.text = [NSString stringWithFormat:@"货物：%@", _data.goods];
    self.bodyLabel2.text = [NSString stringWithFormat:@"客户：%@", _data.cust];
    self.bodyLabel3.text = [NSString stringWithFormat:@"代收款：%@", _data.cash_on_delivery_amount];
    [AppPublic adjustLabelWidth:self.bodyLabel3];

    self.payStyleLabel.text = [data payStyleStringForState];
    [AppPublic adjustLabelWidth:self.payStyleLabel];
    self.payStyleLabel.left = self.bodyLabel3.right;
    
    BOOL is_cash_on_delivery = isTrue(data.is_cash_on_delivery);
    self.bodyView.height = [[self class] heightForBodyWithLabelLines: is_cash_on_delivery ? 3 : 2];
    self.bodyLabel3.hidden = !is_cash_on_delivery;
    self.payStyleLabel.hidden = !is_cash_on_delivery;
}

@end
