//
//  PublicRoundPointView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/23.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicRoundPointView.h"

@interface PublicRoundPointView ()

@property (strong, nonatomic) UIView *secondaryView;

@end

@implementation PublicRoundPointView

- (instancetype)initWithFrame:(CGRect)frame baseColor:(UIColor *)baseColor secondaryColor:(UIColor *)secondaryColor {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = baseColor;
        [AppPublic roundCornerRadius:self];
        if (secondaryColor) {
            _secondaryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5 * self.width, 0.5 * self.height)];
            _secondaryView.center = CGPointMake(0.5 * self.width, 0.5 * self.height);
            _secondaryView.backgroundColor = secondaryColor;
            [AppPublic roundCornerRadius:_secondaryView];
            [self addSubview:_secondaryView];
        }
    }
    return self;
}

- (void)updateBaseColor:(UIColor *)baseColor secondaryColor:(UIColor *)secondaryColor {
    self.backgroundColor = baseColor;
    if (secondaryColor) {
        self.secondaryView.backgroundColor = secondaryColor;
    }
}

@end
