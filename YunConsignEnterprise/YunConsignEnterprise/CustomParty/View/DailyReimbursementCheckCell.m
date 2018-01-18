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
    
    _bodyLabel4 = NewLabel(self.bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _bodyLabel4.top = self.bodyLabel3.bottom + kEdge;
    [self.bodyView addSubview:_bodyLabel4];
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
    self.titleLabel.text = [NSString stringWithFormat:@"%@/%@", data.daily_name, data.service_name];
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = data.daily_fee;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"申请人：　%@", data.apply_name];
    
    NSUInteger lines = 2;
    self.bodyLabel3.hidden = YES;
    self.bodyLabel4.hidden = YES;
    BOOL isNote = data.note.length;
    if (self.indextag == 0) {
        self.bodyLabel2.text = [NSString stringWithFormat:@"关联运单：%@", [data showWaybillInfoString]];
        if (isNote) {
            lines++;
            [self showLabel:self.bodyLabel3 conten:[NSString stringWithFormat:@"报销备注：%@", data.note]];
        }
    }
    else {
        lines = 3;
        self.bodyLabel2.text = [NSString stringWithFormat:@"审核人：　%@", data.check_name];
        [self showLabel:self.bodyLabel3 conten:[NSString stringWithFormat:@"关联运单：%@", [data showWaybillInfoString]]];
        if (self.indextag == 2) {
            lines++;
            [self showLabel:self.bodyLabel4 conten:[NSString stringWithFormat:@"驳回原因：%@", data.check_note]];
        }
        else {
            if (isNote) {
                lines++;
                [self showLabel:self.bodyLabel4 conten:[NSString stringWithFormat:@"报销备注：%@", data.note]];
            }
        }
    }
    [self refreshFooter];
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
}

- (void)setIndextag:(NSInteger)indextag {
    _indextag = indextag;
    if (indextag == 0) {
        
    }
    else {
        if (indextag == 2) {
            self.bodyLabel4.textColor = WarningColor;
        }
    }
}

@end
