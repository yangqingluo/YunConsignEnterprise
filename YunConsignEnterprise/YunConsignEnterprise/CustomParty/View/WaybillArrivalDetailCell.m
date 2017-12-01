//
//  WaybillArrivalDetailCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillArrivalDetailCell.h"

@implementation WaybillArrivalDetailCell

- (void)setupHeader {
    [super setupHeader];
    _urgentLabel = NewLabel(CGRectMake(self.titleLabel.right + kEdgeMiddle, self.titleLabel.top, 30, self.titleLabel.height), WarningColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    _urgentLabel.text = @"[急]";
    [AppPublic adjustLabelWidth:_urgentLabel];
    [self.headerView addSubview:_urgentLabel];
}

#pragma mark - setter
- (void)setData:(AppCanArrivalWayBillInfo *)data {
    _data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"%@：%@", data.route, data.goods_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
    
    if (isTrue(_data.is_urgent)) {
        self.urgentLabel.hidden = NO;
        self.urgentLabel.left = self.titleLabel.right + kEdgeMiddle;
    }
    else {
        self.urgentLabel.hidden = YES;
    }
    self.statusLabel.text = data.total_amount;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"货物信息：%@", _data.goods_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"收货客户：%@", _data.cust_info];
    self.bodyLabel3.text = [NSString stringWithFormat:@"交接情况：%@/%@", _data.handover_state_text, _data.print_state_text];
}


@end
