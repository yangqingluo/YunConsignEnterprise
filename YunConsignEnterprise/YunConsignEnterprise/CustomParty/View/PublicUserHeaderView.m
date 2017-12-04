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
        _logoLabel.textColor = [UIColor whiteColor];
        _logoLabel.textAlignment = NSTextAlignmentCenter;
        _logoLabel.text = @"托运邦";
        [AppPublic adjustLabelHeight:_logoLabel];
        [self addSubview:_logoLabel];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _logoLabel.bottom + kEdgeMiddle, self.width, 24)];
        _textLabel.font = [AppPublic appFontOfSize:14];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = AuxiliaryColor;
        _textLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _textLabel.layer.borderWidth = 1.0;
        [AppPublic roundCornerRadius:_textLabel cornerRadius:0.5 * _textLabel.height];
        [self addSubview:_textLabel];
        
        _detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdge, _textLabel.bottom + 12, self.width - 2 * kEdge, 20)];
        _detailTextLabel.font = [AppPublic appFontOfSize:12];
        _detailTextLabel.textColor = AuxiliaryColor;
        _detailTextLabel.textAlignment = NSTextAlignmentCenter;
        _detailTextLabel.text = @"  ";
        [AppPublic adjustLabelHeight:_detailTextLabel];
        [self addSubview:_detailTextLabel];
    }
    return self;
}

#pragma mark - setter
- (void)setUserData:(AppUserInfo *)userData {
    _userData = userData;
    
    self.textLabel.text = [NSString stringWithFormat:@"%@-%@-%@", userData.open_city_name, userData.service_name, userData.user_name];
    [AppPublic adjustLabelWidth:self.textLabel];
    self.textLabel.width += self.textLabel.height;
    self.textLabel.centerX = 0.5 * self.width;
    
//    self.detailTextLabel.text = userData.role_name.length ? userData.role_name : @"";
}

@end
