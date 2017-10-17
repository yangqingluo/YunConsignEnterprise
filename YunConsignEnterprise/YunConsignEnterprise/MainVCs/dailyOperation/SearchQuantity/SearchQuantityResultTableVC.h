//
//  SearchQuantityResultTableVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchQuantityResultTableVC : UITableViewController

@property (copy, nonatomic) AppSearchQuantityInfo *data;

- (instancetype)initWithStyle:(UITableViewStyle)style andIndexTag:(NSInteger)index;
- (void)becomeListed;
- (void)becomeUnListed;

@end
