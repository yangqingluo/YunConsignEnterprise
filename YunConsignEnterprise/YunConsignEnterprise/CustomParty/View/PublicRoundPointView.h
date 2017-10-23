//
//  PublicRoundPointView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/23.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicRoundPointView : UIView

- (instancetype)initWithFrame:(CGRect)frame baseColor:(UIColor *)baseColor secondaryColor:(UIColor *)secondaryColor;

- (void)updateBaseColor:(UIColor *)baseColor secondaryColor:(UIColor *)secondaryColor;

@end
