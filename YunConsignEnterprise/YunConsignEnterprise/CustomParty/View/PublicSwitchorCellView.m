//
//  PublicSwitchorCellView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicSwitchorCellView.h"

@implementation PublicSwitchorCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _switchor = [IndexPathSwitch new];
        _switchor.onTintColor = MainColor;
        _switchor.centerY = 0.5 * self.height;
        _switchor.right = self.width;
        [self addSubview:_switchor];
        
        self.switchor.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

@end
