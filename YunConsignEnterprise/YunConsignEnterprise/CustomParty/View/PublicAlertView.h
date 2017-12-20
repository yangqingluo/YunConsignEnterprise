//
//  PublicAlertView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/12/20.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicAlertView : UIView

typedef void(^ActionAlertBlock)(PublicAlertView *view, NSInteger index);

- (instancetype)initWithContentView:(UIView *)contentView andTitle:(NSString *)title callBlock:(ActionAlertBlock)block;
- (void)show;

@end
