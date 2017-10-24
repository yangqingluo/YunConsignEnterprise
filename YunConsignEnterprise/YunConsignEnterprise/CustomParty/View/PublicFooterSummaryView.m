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
        
        _subTextLabel = NewLabel(CGRectMake(kEdgeMiddle, 0, self.width - 2 * kEdgeMiddle, self.height), secondaryTextColor, nil, NSTextAlignmentRight);
        [self addSubview:_subTextLabel];
        
        [self addSubview:NewSeparatorLine(CGRectMake(0, 0, self.width, appSeparaterLineSize))];
    }
    return self;
}

@end
