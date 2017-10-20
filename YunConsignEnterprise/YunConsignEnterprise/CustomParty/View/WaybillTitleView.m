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
        
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)addRightView:(UIView *)view {
    if (!view) {
        return;
    }
    
    if (self.rightView) {
        [self.rightView removeFromSuperview];
    }
    
    _rightView = view;
    _rightView.centerY = self.textLabel.centerY;
    _rightView.right = self.width;
    [self addSubview:_rightView];
    _rightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.textLabel.width = _rightView.left - 2 * kEdgeMiddle;
}

@end
