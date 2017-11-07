//
//  PublicInputHeaderView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicInputCellView.h"

@interface PublicInputHeaderView : UIView

@property (strong, nonatomic) PublicInputCellView *baseView;
@property (strong, nonatomic) UIButton *searchBtn;

@end
