//
//  PublicUserHeaderView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/11.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicUserHeaderView.h"

@implementation PublicUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TYBANG"]];
        _logoImageView.centerX = 0.5 * self.width;
        [self addSubview:_logoImageView];
        
        _logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.logoImageView.bottom + 12, self.width, 20)];
        _logoLabel.font = [AppPublic appFontOfSize:20];
        _logoLabel.textAlignment = NSTextAlignmentCenter;
        _logoLabel.textColor = [UIColor whiteColor];
        _logoLabel.text = @"托运邦";
        [AppPublic adjustLabelHeight:_logoLabel];
        [self addSubview:_logoLabel];
    }
    return self;
}

@end
