//
//  DailyReimbursementCheckCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/6.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DailyReimbursementCheckCell.h"

@implementation DailyReimbursementCheckCell

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
}

- (void)refreshFooter {
    NSArray *m_array = @[@"查看凭证", @"报销历史", @"审核通过", @"驳回"];
    if (self.indextag == 0) {
        
    }
    else {
        m_array = @[@"查看凭证", @"报销历史"];
    }
    [self.footerView updateDataSourceWithArray:m_array];
}

#pragma mark - setter
- (void)setData:(AppDailyReimbursementCheckInfo *)data {
    _data = data;
    self.titleLabel.text = data.daily_name;
    self.statusLabel.text = dateStringWithTimeString(data.daily_fee);
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"申请时间：%@", data.apply_time];
    self.bodyLabelRight2.text = [NSString stringWithFormat:@"%@", [data showWaybillInfoString]];
    self.bodyLabel3.text = [NSString stringWithFormat:@"报销备注：%@", data.note];
    if (self.indextag == 2) {
        self.bodyLabel3.text = [NSString stringWithFormat:@"驳回原因：%@", data.check_note];
    }
    [self refreshFooter];
}

- (void)setIndextag:(NSInteger)indextag {
    _indextag = indextag;
    if (indextag == 0) {
        
    }
    else {
        if (indextag == 2) {
            self.bodyLabel3.textColor = WarningColor;
        }
    }
}

@end
