//
//  CodLoanApplyWaybillQueryCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/9.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodLoanApplyWaybillQueryCell.h"

@implementation CodLoanApplyWaybillQueryCell

- (void)setupBody {
    [super setupBody];
    _bodyLabel5 = NewLabel(self.bodyLabel1.frame, nil, nil, NSTextAlignmentLeft);
    _bodyLabel5.textColor = WarningColor;
    _bodyLabel5.top = self.bodyLabel4.bottom + kEdge;
    _bodyLabel5.height += 2 * kEdge;
    _bodyLabel5.numberOfLines = 0;
    [self.bodyView addSubview:_bodyLabel5];
}

#pragma mark - setter
- (void)setData:(AppWayBillDetailInfo *)data {
    super.data = data;
    
    NSUInteger lines = 2;
    BOOL is_cash_on_delivery_real = data.cash_on_delivery_real_time.length > 0;
    if (is_cash_on_delivery_real) {
        lines++;
    }
    
    BOOL is_cash_on_delivery_causes = [data.cash_on_delivery_causes_amount intValue] > 0;
    if (is_cash_on_delivery_causes) {
        lines++;
    }
    
//    if (isTrue(data.is_can_apply)) {
//        self.statusLabel.textColor = MainColor;
//        self.statusLabel.text = [NSString stringWithFormat:@"(%@)", data.print_check_code];
//        self.bodyLabel5.text = @"";
//    }
//    else {
        lines++;
    if (isTrue(data.is_can_apply)) {
        self.bodyLabel5.textColor = MainColor;
        self.bodyLabel5.text = [NSString stringWithFormat:@"验证码：%@", data.print_check_code];
    }
    else {
        self.bodyLabel5.textColor = WarningColor;
        self.bodyLabel5.text = [NSString stringWithFormat:@"%@", data.not_can_apply_note];
    }
    
        if (lines == 3) {
            self.bodyLabel5.top = self.bodyLabel2.bottom;
        }
        else if (lines == 4) {
            self.bodyLabel5.top = self.bodyLabel3.bottom;
        }
        else if (lines == 5) {
            self.bodyLabel5.top = self.bodyLabel4.bottom;
        }
//    }
    
    self.bodyView.height = [[self class] heightForBodyWithLabelLines:lines];
}

@end
