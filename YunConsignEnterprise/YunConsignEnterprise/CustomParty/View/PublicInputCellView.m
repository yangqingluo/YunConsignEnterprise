//
//  PublicInputCellView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicInputCellView.h"

@implementation PublicInputCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = NewLabel(self.bounds, nil, nil, NSTextAlignmentLeft);
        [self addSubview:_textLabel];
        
        _textField = [[IndexPathTextField alloc]initWithFrame:self.bounds];
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

@end
