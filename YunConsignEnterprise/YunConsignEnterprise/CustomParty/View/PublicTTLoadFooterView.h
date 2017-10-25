//
//  PublicTTLoadFooterView.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/25.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicFooterSummaryView.h"
#import "UDImageLabelButton.h"

@interface PublicTTLoadFooterView : UIView

@property (strong, nonatomic) PublicFooterSummaryView *summaryView;
@property (strong, nonatomic) UDImageLabelButton *selectBtn;//全选按钮
@property (strong, nonatomic) UIButton *actionBtn;//动作按钮

@end
