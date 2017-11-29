//
//  PublicCellView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicCellView.h"

@implementation PublicCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = NewLabel(self.bounds, nil, nil, NSTextAlignmentLeft);
        [self addSubview:_textLabel];
        
        _lineView = NewSeparatorLine(CGRectMake(0, self.height - appSeparaterLineSize, self.width, appSeparaterLineSize));
        [self addSubview:_lineView];
        
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (void)showSubTextLabel {
    _textLabel.frame = CGRectMake(0, 0, self.width, 0.5 * self.height);
    _subTextLabel = NewLabel(CGRectMake(0, self.textLabel.bottom, self.width, 0.5 * self.height), nil, nil, NSTextAlignmentLeft);
    [self addSubview:_subTextLabel];
    
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight;
    self.subTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

@end
