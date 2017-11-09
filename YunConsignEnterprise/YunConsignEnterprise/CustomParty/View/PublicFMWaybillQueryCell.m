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
}

#pragma mark - setter
- (void)setData:(AppWayBillDetailInfo *)data {
    _data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"货号：%@/%@", data.goods_number, data.waybill_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
    
    self.bodyLabelRight1.text = [NSString stringWithFormat:@"%@", data.goods];
    self.bodyLabel2.text = [NSString stringWithFormat:@"客户：%@", data.cust];
    self.bodyLabel3.text = [NSString stringWithFormat:@"运费：%@/%@/%@", data.rebate_fee, data.forklift_fee, data.pay_for_sb_fee];
}

@end
