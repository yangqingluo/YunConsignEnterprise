//
//  WayBillCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WayBillCell.h"

@implementation WayBillCell

- (void)setupHeader {
    [super setupHeader];
    _urgentLabel = NewLabel(CGRectMake(self.titleLabel.right + kEdgeMiddle, self.titleLabel.top, 30, self.titleLabel.height), WarningColor, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentLeft);
    _urgentLabel.text = @"[急]";
    [AppPublic adjustLabelWidth:_urgentLabel];
    [self.headerView addSubview:_urgentLabel];
    
    _statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    [AppPublic roundCornerRadius:_statusImageView];
    _statusImageView.backgroundColor = [UIColor lightGrayColor];
    _statusImageView.centerY = self.statusLabel.centerY;
    _statusImageView.right = self.statusLabel.left + kEdge;
//    [self.headerView addSubview:_statusImageView];
}

//- (void)setupFooter {
//    [super setupFooter];
//    NSArray *m_array = @[@"作废", @"修改", @"打印", @"物流"];
//    [self.footerView updateDataSourceWithArray:m_array];
//}

- (void)refreshFooter {
    NSArray *m_array = @[@"作废", @"修改", @"打印", @"物流"];
    if ([self.data.waybill_state intValue] == WAYBILL_STATE_5) {
        m_array = @[@"打印", @"物流"];
    }
    [self.footerView updateDataSourceWithArray:m_array];
}

- (void)setupBody {
    [super setupBody];
    _payNowLabel = NewLabel(self.bodyLabel3.frame, nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_payNowLabel];
    
    _payOnReceiptLabel = NewLabel(self.bodyLabel3.frame, nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_payOnReceiptLabel];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter
- (void)setData:(AppWayBillInfo *)data {
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
    
    self.statusLabel.text = [_data statusStringForState];
    [AppPublic adjustLabelWidth:self.statusLabel];
    self.statusLabel.right = self.headerView.right - kEdge;
    self.statusImageView.right = self.statusLabel.left - kEdge;
    self.statusImageView.backgroundColor = [_data statusColorForState];
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"货物：%@", _data.goods];
    self.bodyLabel2.text = [NSString stringWithFormat:@"客户：%@", _data.cust];
    self.bodyLabel3.text = [NSString stringWithFormat:@"提付：%d", [_data.pay_on_delivery_amount intValue]];
    [AppPublic adjustLabelWidth:self.bodyLabel3];
    
    self.payNowLabel.text = [NSString stringWithFormat:@"现付：%d", [_data.pay_now_amount intValue]];
    [AppPublic adjustLabelWidth:self.payNowLabel];
    self.payNowLabel.left = self.bodyLabel3.right + kEdgeBig;
    
    self.payOnReceiptLabel.text = [NSString stringWithFormat:@"回单付：%d", [_data.pay_on_receipt_amount intValue]];
    [AppPublic adjustLabelWidth:self.payOnReceiptLabel];
    self.payOnReceiptLabel.left = self.payNowLabel.right +
    kEdgeBig;
    
    [self refreshFooter];
}

@end
