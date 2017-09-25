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

@end
