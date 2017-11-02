//
//  PublicSlideVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/2.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppBasicViewController.h"
#import "QCSlideSwitchView.h"

@interface PublicSlideVC : AppBasicViewController<QCSlideSwitchViewDelegate>

@property (strong, nonatomic) QCSlideSwitchView *slidePageView;
@property (strong, nonatomic) NSMutableArray *viewArray;
@property (strong, nonatomic) AppQueryConditionInfo *condition;

- (void)setupNav;
- (void)updateQueryCondition;

@end
