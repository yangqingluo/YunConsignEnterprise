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
    
    _bodyLabel4 = NewLabel(self.bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
}

- (void)refreshFooter {
    NSArray *m_array = @[@"取消申请"];
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
    self.statusLabel.text = dateStringWithTimeString(data.daily_fee);
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"申请时间：%@", data.apply_time];
    self.bodyLabel2.text = [NSString stringWithFormat:@"关联运单：%@", data.waybill_info];
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
            self.bodyLabel4.textColor = baseRedColor;
        }
    }
}

@end
