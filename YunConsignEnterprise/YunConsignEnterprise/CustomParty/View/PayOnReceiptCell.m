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
    _urgentLabel.text = @"[送]";
    [AppPublic adjustLabelWidth:_urgentLabel];
    [self.headerView addSubview:_urgentLabel];
}

- (void)setupBody {
    [super setupBody];
    _payLabel = NewLabel(CGRectMake(kEdge + 0.5 * self.bodyView.width, self.bodyLabel3.top, 0.5 * self.bodyView.width - 1 * kEdge, self.bodyLabel3.height), nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_payLabel];
}

- (void)refreshFooter {
    NSInteger receipt_state = [self.data.receipt_state integerValue];
    switch (receipt_state) {
        case RECEIPT_STATE_TYPE_3:
        case RECEIPT_STATE_TYPE_4:{
            self.footerView.hidden = NO;
            NSArray *m_array = @[@"付款"];
            if (receipt_state == RECEIPT_STATE_TYPE_4) {
                m_array = @[@"取消付款"];
            }
            [self.footerView updateDataSourceWithArray:m_array];
        }
            break;
            
        default:{
            self.footerView.hidden = YES;
        }
            break;
    }
}

#pragma mark - setter
- (void)setData:(AppNeedReceiptWayBillInfo *)data {
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
    self.statusLabel.text = _data.receipt_state_text;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"货物：%@", _data.goods_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"发货人：%@", _data.cust_info];
    self.bodyLabel3.text = [NSString stringWithFormat:@"回单：%@", _data.receipt_sign_type_text];
    [AppPublic adjustLabelWidth:self.bodyLabel3];
    
    self.payLabel.text = [NSString stringWithFormat:@"回单付：%@", _data.pay_on_receipt_amount];
    
//    NSUInteger lines = 3;
//    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
    [self refreshFooter];
}

@end
