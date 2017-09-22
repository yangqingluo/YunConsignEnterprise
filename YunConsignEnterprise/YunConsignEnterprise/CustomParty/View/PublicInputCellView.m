//
//  PublicInputCellView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicInputCellView.h"

@implementation IndexPathButton



@end

@implementation PublicInputCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = NewLabel(self.bounds, nil, nil, NSTextAlignmentLeft);
        [self addSubview:_textLabel];
        
        _textField = [[IndexPathTextField alloc]initWithFrame:CGRectMake(cellDetailLeft, 0, self.width - cellDetailLeft, self.height)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.font = [UIFont systemFontOfSize:appLabelFontSize];
        _textField.textAlignment = NSTextAlignmentRight;
        [self addSubview:_textField];
        
        UIView *lineView = NewSeparatorLine(CGRectMake(0, self.height - appSeparaterLineSize, self.width, appSeparaterLineSize));
        [self addSubview:lineView];
        
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (void)showRightButtonWithImage:(UIImage *)image {
    _rightButton = [[IndexPathButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_rightButton setImage:image forState:UIControlStateNormal];
    _rightButton.centerY = _textField.centerY;
    _rightButton.right = self.width;
    [self addSubview:_rightButton];
    
    _rightButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _textField.width -= _rightButton.width;
}

- (void)showRightImageWithImage:(UIImage *)image {
    _rightImageView = [[UIImageView alloc] initWithImage:image];
    _rightImageView.centerY = _textField.centerY;
    _rightImageView.right = self.width;
    [self addSubview:_rightImageView];
    
    _rightImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _textField.width -= _rightImageView.width;
}
@end
