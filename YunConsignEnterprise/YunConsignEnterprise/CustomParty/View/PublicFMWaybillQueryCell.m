//
//  PublicFMWaybillQueryCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicFMWaybillQueryCell.h"

@implementation PublicFMWaybillQueryCell

- (void)setupBody {
    [super setupBody];
    self.bodyLabel1.top = 0;
    self.bodyLabel1.height = self.bodyLabel2.top;
    
    _bodyLabelRight1 = NewLabel(self.bodyLabel1.frame, self.bodyLabel1.textColor, self.bodyLabel1.font, NSTextAlignmentLeft);
    _bodyLabelRight1.numberOfLines = 0;
    [self.bodyView addSubview:_bodyLabelRight1];
    
    self.bodyLabel1.text = @"货物：";
    [AppPublic adjustLabelWidth:self.bodyLabel1];
    self.bodyLabelRight1.left = self.bodyLabel1.right;
    self.bodyLabelRight1.width = self.bodyView.width - kEdgeMiddle - self.bodyLabelRight1.left;
    
    _bodyLabelMiddle3 = NewLabel(self.bodyLabel3.frame, nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_bodyLabelMiddle3];
    
    _bodyLabelRight3 = NewLabel(self.bodyLabel3.frame, nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_bodyLabelRight3];
    
    CGFloat width = (self.bodyView.width - 2 * self.bodyLabel3.left ) / 3.0;
    self.bodyLabel3.width = width;
    self.bodyLabelMiddle3.width = width;
    self.bodyLabelMiddle3.left = self.bodyLabel3.right;
    self.bodyLabelRight3.width = width;
    self.bodyLabelRight3.left = self.bodyLabelMiddle3.right;
}

#pragma mark - setter
- (void)setData:(AppWayBillDetailInfo *)data {
    _data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"货号：%@/%@", data.goods_number, data.waybill_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
    
    self.bodyLabelRight1.text = [NSString stringWithFormat:@"%@", data.goods];
    self.bodyLabel2.text = [NSString stringWithFormat:@"客户：%@", data.cust];
    self.bodyLabel3.text = [NSString stringWithFormat:@"回扣：%@", data.rebate_fee];
//    [AppPublic adjustLabelWidth:self.bodyLabel3];
    
    self.bodyLabelMiddle3.text = [NSString stringWithFormat:@"叉车：%@", data.forklift_fee];
//    [AppPublic adjustLabelWidth:self.bodyLabelMiddle3];
//    self.bodyLabelMiddle3.left = self.bodyLabel3.right + kEdgeBig;
    
    self.bodyLabelRight3.text = [NSString stringWithFormat:@"垫付费：%@", data.pay_for_sb_fee];
//    [AppPublic adjustLabelWidth:self.bodyLabelRight3];
//    self.bodyLabelRight3.left = self.bodyLabelMiddle3.right +
    kEdgeBig;
}

@end
