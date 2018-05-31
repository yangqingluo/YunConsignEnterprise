//
//  PublicCommonInputCellView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/5/31.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "PublicCommonInputCellView.h"

@implementation PublicCommonInputCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _commonBtn = [[IndexPathButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
        [_commonBtn setImage:[UIImage imageNamed:@"list_icon_common"] forState:UIControlStateNormal];
        _commonBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addRightView:_commonBtn];
    }
    return self;
}

@end
