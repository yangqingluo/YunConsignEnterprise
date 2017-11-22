//
//  PublicSlideTableVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/2.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicShowTableVC.h"

@interface PublicResultTableVC : PublicShowTableVC

@property (strong, nonatomic) AppQueryConditionInfo *condition;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableSet *selectSet;

- (instancetype)initWithStyle:(UITableViewStyle)style andIndexTag:(NSInteger)index;
- (instancetype)initWithStyle:(UITableViewStyle)style parentVC:(AppBasicViewController *)pVC andIndexTag:(NSInteger)index;
- (void)becomeListed;
- (void)becomeUnListed;

- (void)confirmRemovingDataAtIndexPath:(NSIndexPath *)indexPath;
- (void)doRemovingDataAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeItemSuccessAtIndexPath:(NSIndexPath *)indexPath;

@end
