//
//  SaveCodLoanApplySecondCell.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/9.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SaveCodLoanApplySecondCell.h"

@implementation SaveCodLoanApplySecondCell

- (void)setupBody {
    [super setupBody];
    [self.bodyLabel3 removeFromSuperview];
    _bodyLabelRight1 = NewLabel(CGRectMake(kEdge + 0.5 * self.bodyView.width, self.bodyLabel1.top, 0.5 * self.bodyView.width - 1 * kEdge, self.bodyLabel1.height), nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_bodyLabelRight1];
    
    _bodyLabelRight2 = NewLabel(CGRectMake(kEdge + 0.5 * self.bodyView.width, self.bodyLabel2.top, 0.5 * self.bodyView.width - 1 * kEdge, self.bodyLabel2.height), nil, nil, NSTextAlignmentLeft);
    [self.bodyView addSubview:_bodyLabelRight2];
}

@end
