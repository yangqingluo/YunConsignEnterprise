//
//  WaybillChangeApplyCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/1/10.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "WaybillChangeApplyCell.h"

@implementation WaybillChangeApplyCell

- (void)setupBody {
    [super setupBody];
    self.bodyLabel2.text = @"审核：";
    [AppPublic adjustLabelWidth:self.bodyLabel2];
    
    _changeLabel = NewLabel(self.bodyLabel3.frame, nil, nil, NSTextAlignmentLeft);
    _changeLabel.numberOfLines = 0;
    [self.bodyView addSubview:_changeLabel];
    self.bodyLabel3.text = @"修改：";
    [AppPublic adjustLabelWidth:self.bodyLabel3];
    _changeLabel.left = self.bodyLabel3.right;
    _changeLabel.width = self.bodyView.width - kEdgeMiddle - _changeLabel.left;
    
    _rejectNoteLabel = NewLabel(self.bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _rejectNoteLabel.top = self.bodyLabel3.bottom + kEdge;
    _rejectNoteLabel.textColor = WarningColor;
    [self.bodyView addSubview:_rejectNoteLabel];
}

- (void)refreshFooter {
    NSArray *m_array = @[@"运单详情"];
//    if ([self.data.loan_apply_state integerValue] == LOAN_APPLY_STATE_1) {
//        m_array = @[@"驳回"];
//        self.footerView.hidden = NO;
//    }
//    else {
//        self.footerView.hidden = YES;
//    }
    [self.footerView updateDataSourceWithArray:m_array];
}

#pragma mark - setter
- (void)setData:(AppWaybillChangeApplyInfo *)data {
    _data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"货号：%@", data.goods_number];
    [AppPublic adjustLabelWidth:self.titleLabel];
    self.statusLabel.text = data.change_state_text;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"申请：%@", _data.apply];
    self.changeLabel.text = _data.change_note;
    [AppPublic adjustLabelHeight:self.changeLabel];
    
    NSUInteger lines = 2;
    self.bodyLabel3.text = @"";
    if ([_data.change_state integerValue] == WAYBILL_CHANGE_APPLY_STATE_2) {
        lines++;
        self.bodyLabel2.text = [NSString stringWithFormat:@"审核：%@", _data.check];
        self.bodyLabel2.width = self.bodyLabel1.width;
        
        self.bodyLabel3.text = [NSString stringWithFormat:@"修改："];
        [AppPublic adjustLabelWidth:self.bodyLabel3];
        self.changeLabel.left = self.bodyLabel3.right;
        self.changeLabel.top = self.bodyLabel3.top;
    }
    else {
        self.bodyLabel2.text = [NSString stringWithFormat:@"修改："];
        [AppPublic adjustLabelWidth:self.bodyLabel2];
        self.changeLabel.left = self.bodyLabel2.right;
        self.changeLabel.top = self.bodyLabel2.top;
    }
    
//    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
    [self refreshFooter];
}
@end
