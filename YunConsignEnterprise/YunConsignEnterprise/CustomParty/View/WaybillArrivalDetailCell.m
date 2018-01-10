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
    _urgentLabel.text = @"[送]";
    [AppPublic adjustLabelWidth:_urgentLabel];
    [self.headerView addSubview:_urgentLabel];
}

- (void)setupBody {
    [super setupBody];
    self.bodyLabel2.top = self.bodyLabel1.bottom;
    self.bodyLabel2.height = self.bodyLabel3.top - self.bodyLabel2.top;
    
    _bodyLabelRight2 = NewLabel(self.bodyLabel2.frame, self.bodyLabel2.textColor, self.bodyLabel2.font, NSTextAlignmentLeft);
    _bodyLabelRight2.numberOfLines = 0;
    _bodyLabelRight2.lineBreakMode = NSLineBreakByCharWrapping;
    [self.bodyView addSubview:_bodyLabelRight2];
    
    self.bodyLabel2.text = @"收货客户：";
    [AppPublic adjustLabelWidth:self.bodyLabel2];
    self.bodyLabelRight2.left = self.bodyLabel2.right;
    self.bodyLabelRight2.width = self.bodyView.width - kEdgeMiddle - self.bodyLabelRight2.left;
}

#pragma mark - setter
- (void)setData:(AppCanArrivalWayBillInfo *)data {
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
    self.statusLabel.text = data.total_amount;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"货物信息：%@", _data.goods_info];
    self.bodyLabelRight2.text = [NSString stringWithFormat:@"%@", _data.cust_info];
    
    NSDictionary *dic1 = @{NSFontAttributeName:self.bodyLabel3.font, NSForegroundColorAttributeName:baseTextColor};
    NSDictionary *dic2 = @{NSFontAttributeName:self.bodyLabel3.font, NSForegroundColorAttributeName:MainColor};
    
    NSMutableAttributedString *m_string = [NSMutableAttributedString new];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"交接情况："] attributes:dic1]];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _data.handover_state_text] attributes:isTrue(_data.handover_state) ? dic1 : dic2]];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/"] attributes:dic1]];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _data.print_state_text] attributes:isTrue(_data.print_state) ? dic1 : dic2]];
    
    self.bodyLabel3.attributedText = m_string;
}


@end
