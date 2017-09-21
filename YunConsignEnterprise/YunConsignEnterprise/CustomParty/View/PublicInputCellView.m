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
        _textLabel = NewLabel(CGRectMake(kEdge, 0, self.width - 2 * kEdge, self.height), nil, nil, NSTextAlignmentLeft);
        [self addSubview:_textLabel];
        
        _textField = [[IndexPathTextField alloc]initWithFrame:CGRectMake(kEdgeMiddle, 0, self.width - 2 * kEdgeMiddle, self.height)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.font = [UIFont systemFontOfSize:appLabelFontSize];
        [self addSubview:_textField];
        
        UIView *lineView = NewSeparatorLine(CGRectMake(kEdge, self.height - appSeparaterLineSize, self.width - 2 * kEdge, appSeparaterLineSize));
        [self addSubview:lineView];
        
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

@end
