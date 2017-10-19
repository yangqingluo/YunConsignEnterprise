//
//  TransportTruckTableVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/27.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransportTruckTableVC : UITableViewController

@property (strong, nonatomic) AppQueryConditionInfo *condition;
@property (assign, nonatomic) BOOL isResetCondition;

- (instancetype)initWithStyle:(UITableViewStyle)style andIndexTag:(NSInteger)index;
- (void)becomeListed;
- (void)becomeUnListed;

@end
