//
//  WaybillTitleView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/20.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "WaybillTitleView.h"

@implementation WaybillTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *leftColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kEdgeSmall, self.height)];
        leftColorView.backgroundColor = MainColor;
        leftColorView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubview:leftColorView];
        
        UIView *lineView = NewSeparatorLine(CGRectMake(0, self.height - appSeparaterLineSize, screen_width, appSeparaterLineSize));
        lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:lineView];
        
        _textLabel = NewLabel(CGRectMake(kEdgeMiddle, 0, self.width - 2 * kEdgeMiddle, self.height), baseTextColor, [UIFont boldSystemFontOfSize:appLabelFontSizeMiddle], NSTextAlignmentLeft);
        [self addSubview:_textLabel];
        
        _subTextLabel = NewLabel(CGRectMake(kEdgeMiddle, 0, self.width - 2 * kEdgeMiddle, self.height), nil, nil, NSTextAlignmentRight);
        [self addSubview:_subTextLabel];
        
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.subTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

@end
