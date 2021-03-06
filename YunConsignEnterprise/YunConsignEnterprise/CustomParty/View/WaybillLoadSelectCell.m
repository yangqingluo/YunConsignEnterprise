//
//  WaybillLoadSelectCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillLoadSelectCell.h"

@implementation WaybillLoadSelectCell

- (void)setupHeader {
    [super setupHeader];
    _urgentLabel = NewLabel(CGRectMake(self.titleLabel.right + kEdgeMiddle, self.titleLabel.top, 30, self.titleLabel.height), WarningColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    _urgentLabel.text = @"[送]";
    [AppPublic adjustLabelWidth:_urgentLabel];
    [self.headerView addSubview:_urgentLabel];
}

- (void)setupBody {
    [super setupBody];
    _payStyleLabel = NewLabel(self.bodyLabel3.frame, secondaryTextColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    [self.bodyView addSubview:_payStyleLabel];
}

#pragma mark - setter
- (void)setData:(AppCanLoadWayBillInfo *)data {
    _data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"%@：%@", data.route, data.goods_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
    
    if (isTrue(_data.is_deliver_goods)) {
        self.urgentLabel.hidden = NO;
        self.urgentLabel.left = self.titleLabel.right + kEdgeMiddle;
    }
    else {
        self.urgentLabel.hidden = YES;
    }
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"货物：%@", _data.goods_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"客户：%@", _data.cust_info];
    NSInteger lines = 2;
    self.bodyLabel3.hidden = YES;
    self.payStyleLabel.hidden = YES;
    if ([data.cash_on_delivery_amount integerValue] > 0) {
        lines++;
        [self showLabel:self.bodyLabel3 conten:[NSString stringWithFormat:@"代收款：%@", _data.cash_on_delivery_amount]];
        [AppPublic adjustLabelWidth:self.bodyLabel3];
        
        [self showLabel:self.payStyleLabel conten:[data payStyleStringForState]];
        [AppPublic adjustLabelWidth:self.payStyleLabel];
        self.payStyleLabel.left = self.bodyLabel3.right;
    }
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
}

@end
