//
//  PublicSwitchedInputCellView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicSwitchedInputCellView.h"

@implementation PublicSwitchedInputCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _checkBtn = [[IndexPathButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
        [_checkBtn setImage:[UIImage imageNamed:@"list_icon_checkbox_normal"] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"list_icon_checkbox_selcted"] forState:UIControlStateSelected];
        _checkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addRightView:_checkBtn];
    }
    return self;
}

@end
