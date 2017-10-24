//
//  PublicFooterSummaryView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/24.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicFooterSummaryView.h"

@implementation PublicFooterSummaryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = baseFooterBarColor;
        _textLabel = NewLabel(CGRectMake(kEdgeMiddle, 0, self.width - 2 * kEdgeMiddle, self.height), secondaryTextColor, nil, NSTextAlignmentLeft);
        [self addSubview:_textLabel];
    }
    return self;
}

@end
