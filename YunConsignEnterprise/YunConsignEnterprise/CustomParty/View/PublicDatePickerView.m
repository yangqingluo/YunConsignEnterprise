//
//  PublicDatePickerView.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicDatePickerView.h"

#define default_windowView_height 320

@interface PublicDatePickerView()

@property (assign, nonatomic) PublicDatePickerType type;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIView *topBar;
@property (strong, nonatomic) UIView *baseView;
@property (copy, nonatomic) ActionDatePickerBlock block;

@end

@implementation PublicDatePickerView

- (instancetype)initWithStyle:(PublicDatePickerType)type andTitle:(NSString *)title callBlock:(ActionDatePickerBlock)block{
    self = [super init];
    if (self) {
        self.type = type;
        self.title = [title copy];
        self.block = block;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        switch (self.type) {
            case PublicDatePicker_Date:{
                self.datePicker = [[UIDatePicker alloc] init];
                self.datePicker.datePickerMode = UIDatePickerModeDate;
                self.datePicker.backgroundColor = [UIColor whiteColor];
                //                self.datePicker.maximumDate = [NSDate date];
                
                [self updateSubviews:self.datePicker];
            }
                break;
                
            case PublicDatePicker_DateAndTime:{
                self.datePicker = [[UIDatePicker alloc] init];
                self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
                self.datePicker.backgroundColor = [UIColor whiteColor];
                //                self.datePicker.maximumDate = [NSDate date];
                
                [self updateSubviews:self.datePicker];
            }
                break;
                
            default:{
                
            }
                break;
        }
    }
    
    return self;
}

- (void)updateSubviews:(UIView *)showView{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    
    UIBarButtonItem *lefttem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    
    UIBarButtonItem *centerSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    toolbar.items = @[lefttem, centerSpace, right];
    
    toolbar.frame = CGRectMake(0, 0, self.bounds.size.width, 40);
    showView.frame = CGRectMake(0, toolbar.frame.origin.y + toolbar.frame.size.height, self.bounds.size.width, showView.bounds.size.height);
    
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, toolbar.bounds.size.height + showView.bounds.size.height)];
    self.baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.baseView];
    
    [self.baseView addSubview:toolbar];
    [self.baseView addSubview:showView];
}

- (void)dismiss{
    [UIView animateWithDuration:0.25 animations:^{
        [self.baseView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)show{
    [[self topViewController].view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        [self.baseView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.baseView.bounds.size.height, self.baseView.bounds.size.width,  self.baseView.bounds.size.height)];
    } completion:^(BOOL finished) {
        
    }];
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
