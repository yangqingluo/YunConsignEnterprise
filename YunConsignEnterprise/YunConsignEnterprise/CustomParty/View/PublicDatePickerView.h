//
//  PublicDatePickerView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PublicDatePicker_Default = 0,
    PublicDatePicker_Date,
    PublicDatePicker_DateAndTime,
} PublicDatePickerType;

@interface PublicDatePickerView : UIView

typedef void(^ActionDatePickerBlock)(PublicDatePickerView *view, NSInteger index);
@property (strong, nonatomic) UIDatePicker *datePicker;

- (instancetype)initWithStyle:(PublicDatePickerType)type andTitle:(NSString *)title callBlock:(ActionDatePickerBlock)block;
- (void)show;

@end
