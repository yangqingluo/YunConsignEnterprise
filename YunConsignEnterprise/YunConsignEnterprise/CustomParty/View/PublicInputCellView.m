//
//  PublicInputCellView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicInputCellView.h"

@interface PublicInputCellView ()

@end

@implementation PublicInputCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textField = [[IndexPathTextField alloc]initWithFrame:CGRectMake(cellDetailLeft, 0, self.width - cellDetailLeft, self.height)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.font = [UIFont systemFontOfSize:appLabelFontSize];
        _textField.textAlignment = NSTextAlignmentRight;
        [self addSubview:_textField];
        
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
    _rightView.centerY = _textField.centerY;
    _rightView.right = self.width;
    [self addSubview:_rightView];
    _rightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _textField.width = self.rightView.left - cellDetailLeft;
}

@end
