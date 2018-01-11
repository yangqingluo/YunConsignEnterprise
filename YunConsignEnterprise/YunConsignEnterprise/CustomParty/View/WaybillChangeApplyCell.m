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
    
    _changeLabel = NewLabel(self.bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _changeLabel.numberOfLines = 0;
//    _changeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.bodyView addSubview:_changeLabel];
    self.bodyLabel3.text = @"修改：";
    [AppPublic adjustLabelWidth:self.bodyLabel3];
    _changeLabel.left = self.bodyLabel3.right;
    _changeLabel.width = self.bodyLabel1.right - _changeLabel.left;
    
    _rejectNoteLabel = NewLabel(self.bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _rejectNoteLabel.top = self.bodyLabel3.bottom + kEdge;
    _rejectNoteLabel.textColor = WarningColor;
    [self.bodyView addSubview:_rejectNoteLabel];
}

- (void)refreshFooter {
    NSArray *m_array = @[@"运单详情"];
    if ([self.data.change_state integerValue] == WAYBILL_CHANGE_APPLY_STATE_1) {
        m_array = @[@"取消", @"运单详情"];
//        self.footerView.hidden = NO;
    }
    [self.footerView updateDataSourceWithArray:m_array];
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath data:(AppWaybillChangeApplyInfo *)data {
    CGFloat titleLabelWidth = ceil([AppPublic textSizeWithString:@"修改：" font:[AppPublic appFontOfSize:appLabelFontSize] constantHeight:height_body_label].width);
    CGFloat changeLabelHight = ceil([AppPublic textSizeWithString:data.change_note font:[AppPublic appFontOfSize:appLabelFontSize] constantWidth:screen_width - 2 * kEdgeSmall - 2 * kEdge - titleLabelWidth].height);//根据苹果官方文档介绍，计算出来的值比实际需要的值略小，故需要对其向上取整，这样子获取的高度才是我们所需要的。
    return [super tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:(2 + ([data.change_state integerValue] == WAYBILL_CHANGE_APPLY_STATE_2 || [data.change_state integerValue] == WAYBILL_CHANGE_APPLY_STATE_3))] + MAX(changeLabelHight - height_body_label, 0.0);
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
    self.rejectNoteLabel.hidden = YES;
    if ([_data.change_state integerValue] == WAYBILL_CHANGE_APPLY_STATE_2) {
        lines++;
        self.bodyLabel2.text = [NSString stringWithFormat:@"审核：%@", _data.check];
        self.bodyLabel2.width = self.bodyLabel1.width;
        
        self.bodyLabel3.text = [NSString stringWithFormat:@"修改："];
        [AppPublic adjustLabelWidth:self.bodyLabel3];
        self.changeLabel.left = self.bodyLabel3.right;
        self.changeLabel.top = self.bodyLabel3.top + 1;
    }
    else {
        self.bodyLabel2.text = [NSString stringWithFormat:@"修改："];
        [AppPublic adjustLabelWidth:self.bodyLabel2];
        self.changeLabel.left = self.bodyLabel2.right;
        self.changeLabel.top = self.bodyLabel2.top + 1;
        if ([_data.change_state integerValue] == WAYBILL_CHANGE_APPLY_STATE_3) {
            lines++;
            self.rejectNoteLabel.top = self.changeLabel.bottom + kEdge;
            [self showLabel:self.rejectNoteLabel conten:[NSString stringWithFormat:@"驳回原因：%@", _data.check_note]];
        }
    }
    
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines] + MAX(self.changeLabel.height - height_body_label, 0.0);
    [self refreshFooter];
}
@end
