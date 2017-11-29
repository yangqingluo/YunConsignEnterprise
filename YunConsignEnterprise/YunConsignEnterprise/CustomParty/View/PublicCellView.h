//
//  PublicCellView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicCellView : UIView

@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIView *lineView;

//使用时实现，备用
@property (strong, nonatomic) UILabel *subTextLabel;
- (void)showSubTextLabel;

@end
