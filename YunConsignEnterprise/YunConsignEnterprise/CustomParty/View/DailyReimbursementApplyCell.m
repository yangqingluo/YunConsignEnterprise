//
//  DailyReimbursementApplyCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/6.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DailyReimbursementApplyCell.h"

@implementation DailyReimbursementApplyCell

- (void)setupFooter {
    [super setupFooter];
    [self refreshFooter];
}

- (void)setupBody {
    [super setupBody];
    self.bodyLabel2.top = self.bodyLabel1.bottom;
    self.bodyLabel2.height = self.bodyLabel3.top - self.bodyLabel2.top;
    
    _bodyLabelRight2 = NewLabel(self.bodyLabel2.frame, self.bodyLabel2.textColor, self.bodyLabel2.font, NSTextAlignmentLeft);
    _bodyLabelRight2.numberOfLines = 0;
    [self.bodyView addSubview:_bodyLabelRight2];
    
    self.bodyLabel2.text = @"关联运单：";
    [AppPublic adjustLabelWidth:self.bodyLabel2];
    self.bodyLabelRight2.left = self.bodyLabel2.right;
    self.bodyLabelRight2.width = self.bodyView.width - kEdgeMiddle - self.bodyLabelRight2.left;
    
    _bodyLabel4 = NewLabel(self.bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
}

- (void)refreshFooter {
    NSArray *m_array = @[@"查看凭证", @"取消申请"];
    if (self.indextag == 0) {
        
    }
    else {
        m_array = @[@"查看凭证"];
    }
    [self.footerView updateDataSourceWithArray:m_array];
}

#pragma mark - setter
- (void)setData:(AppDailyReimbursementApplyInfo *)data {
    _data = data;
    self.titleLabel.text = data.daily_name;
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = data.daily_fee;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"申请时间：%@", data.apply_time];
    self.bodyLabelRight2.text = [NSString stringWithFormat:@"%@", [data showWaybillInfoString]];
    self.bodyLabel3.text = [NSString stringWithFormat:@"申请备注：%@", data.note];
    if (self.indextag == 1) {
        self.bodyLabel4.text = [NSString stringWithFormat:@"审核人：%@（%@）", data.check_name, data.check_time];
    }
    else if (self.indextag == 2) {
        self.bodyLabel4.text = [NSString stringWithFormat:@"驳回原因：%@", data.check_note];
    }
    [self refreshFooter];
}

- (void)setIndextag:(NSInteger)indextag {
    _indextag = indextag;
    if (indextag == 0) {
        
    }
    else {
        if (!self.bodyLabel4.superview) {
            self.bodyLabel4.top = self.bodyLabel3.bottom + kEdge;
            [self.bodyView addSubview:self.bodyLabel4];
        }
        if (indextag == 2) {
            self.bodyLabel4.textColor = WarningColor;
        }
    }
}

@end
