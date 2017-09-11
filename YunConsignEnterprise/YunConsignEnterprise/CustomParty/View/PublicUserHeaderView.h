//
//  PublicUserHeaderView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/11.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicUserHeaderView : UIView

@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *logoLabel;

@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UILabel *detailTextLabel;

@property (copy, nonatomic) AppUserInfo *userData;

@end
