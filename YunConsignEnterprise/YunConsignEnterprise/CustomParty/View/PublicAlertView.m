//
//  PublicAlertView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/12/20.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicAlertView.h"

@interface PublicAlertView ()

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIView *baseView;
@property (copy, nonatomic) ActionAlertBlock block;

@end

@implementation PublicAlertView

- (instancetype)initWithContentView:(UIView *)contentView andTitle:(NSString *)title callBlock:(ActionAlertBlock)block {
    self = [super init];
    if (self) {
        self.title = [title copy];
        self.block = block;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
//        self.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
//        [self addGestureRecognizer:tapGesture];
        [self updateSubviews:contentView];
    }
    return self;
}

- (void)updateSubviews:(UIView *)showView {
    CGFloat barHeight = TAB_BAR_HEIGHT;
    
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, showView.width, showView.height + (barHeight + kEdgeMiddle) * 2)];
    self.baseView.backgroundColor = [UIColor whiteColor];
    self.baseView.center = CGPointMake(0.5 * self.width, 0.45 * self.height);
    [self addSubview:self.baseView];
    
    [AppPublic roundCornerRadius:self.baseView cornerRadius:kViewCornerRadius * 2];
    
    UILabel *titleLabel = NewLabel(CGRectMake(0, 0, self.baseView.width, barHeight), [UIColor whiteColor], [AppPublic appFontOfSize:appLabelFontSizeMiddle], NSTextAlignmentCenter);
    titleLabel.text = self.title;
    titleLabel.backgroundColor = MainColor;
    [self.baseView addSubview:titleLabel];
    
    showView.top = titleLabel.bottom + kEdgeMiddle;
    [self.baseView addSubview:showView];
    
    [self.baseView addSubview:NewSeparatorLine(CGRectMake(0, self.baseView.height - barHeight, self.baseView.width, appSeparaterLineSize))];
    
    UIButton *button1 = NewTextButton(@"保存", MainColor);
    button1.frame = CGRectMake(0, self.baseView.height - barHeight, 0.5 * self.baseView.width, barHeight);
    [button1 addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:button1];
    
    UIButton *button2 = NewTextButton(@"取消", baseTextColor);
    button2.frame = CGRectMake(0.5 * self.baseView.width, self.baseView.height - barHeight, 0.5 * self.baseView.width, barHeight);
    [button2 addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:button2];
    
    [self.baseView addSubview:NewSeparatorLine(CGRectMake(0.5 * self.baseView.width, self.baseView.height - barHeight, appSeparaterLineSize, barHeight))];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)show {
    [[self topViewController].view addSubview:self];
}

- (void)tappedCancel{
    [self dismiss];
}

- (void)cancelClick{
    self.block(self, 0);
    [self dismiss];
}

- (void)doneClick{
    self.block(self, 1);
    [self dismiss];
}

#pragma getter
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return vc;
}

@end
