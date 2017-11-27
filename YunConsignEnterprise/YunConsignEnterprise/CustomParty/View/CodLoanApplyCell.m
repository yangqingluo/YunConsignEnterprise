//
//  CodLoanApplyCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/2.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodLoanApplyCell.h"

@implementation CodLoanApplyCell

- (void)setupBody {
    [super setupBody];
    
    _bodyLabel4 = NewLabel(self.bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _bodyLabel4.top = self.bodyLabel3.bottom + kEdge;
    [self.bodyView addSubview:_bodyLabel4];
}

- (void)refreshFooter {
    NSArray *m_array = @[@"运单明细"];
    if ([self.data.loan_apply_state intValue] == 1) {
        m_array = @[@"取消申请", @"运单明细"];
    }
    [self.footerView updateDataSourceWithArray:m_array];
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView heightForRowAtIndexPath:indexPath bodyLabelLines:4];
}

#pragma mark - setter
- (void)setData:(AppCodLoanApplyInfo *)data {
    _data = data;
    self.titleLabel.text = [NSString stringWithFormat:@"%@", _data.cust_info];
    self.statusLabel.text = _data.loan_apply_state_text;
    
    self.bodyLabel1.text = [NSString stringWithFormat:@"打款：%@", _data.bank_info];
    self.bodyLabel2.text = [NSString stringWithFormat:@"申请：%d（%@）", [_data.apply_amount intValue], _data.apply_time];
    NSUInteger lines = 3;
    if ([data.loan_apply_state integerValue] == 1) {
        self.bodyLabel3.text = [NSString stringWithFormat:@"备注：%@", _data.apply_note];
        self.bodyLabel4.text = @"";
    }
    else {
        lines++;
        self.bodyLabel3.text = [NSString stringWithFormat:@"审核：%d（%@）", [_data.audit_amount intValue], _data.audit_time];
        self.bodyLabel4.text = [NSString stringWithFormat:@"备注：%@", _data.apply_note];
    }
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
    [self refreshFooter];
}

@end
