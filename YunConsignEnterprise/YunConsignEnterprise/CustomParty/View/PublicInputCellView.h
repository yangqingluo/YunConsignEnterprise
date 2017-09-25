//
//  PublicInputCellView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicCellView.h"
#import "AppResponder.h"

@interface PublicInputCellView : PublicCellView

@property (strong, nonatomic) IndexPathTextField *textField;
@property (strong, nonatomic) UIView *rightView;

- (void)addRightView:(UIView *)view;

@end
