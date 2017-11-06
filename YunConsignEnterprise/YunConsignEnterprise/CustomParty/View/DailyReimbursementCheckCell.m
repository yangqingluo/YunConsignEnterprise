//
//  DailyReimbursementCheckCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/6.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "DailyReimbursementCheckCell.h"

@implementation DailyReimbursementCheckCell

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
    self.bodyLabel2.text = [NSString stringWithFormat:@"关联运单：%@", [data showWaybillInfoString]];
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
            self.bodyLabel3.textColor = baseRedColor;
        }
    }
}

@end
