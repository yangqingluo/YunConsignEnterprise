//
//  PublicSlideTableVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/2.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppBasicTableViewController.h"
#import "MJRefresh.h"

@interface PublicResultTableVC : AppBasicTableViewController

@property (strong, nonatomic) AppQueryConditionInfo *condition;
@property (assign, nonatomic) BOOL isResetCondition;
@property (assign, nonatomic) NSInteger indextag;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSString *dateKey;

- (instancetype)initWithStyle:(UITableViewStyle)style andIndexTag:(NSInteger)index;
- (instancetype)initWithStyle:(UITableViewStyle)style parentVC:(AppBasicViewController *)pVC andIndexTag:(NSInteger)index;
- (void)becomeListed;
- (void)becomeUnListed;
- (void)loadFirstPageData;
- (void)loadMoreData;
- (void)pullBaseListData:(BOOL)isReset;
- (void)updateTableViewHeader;
- (void)updateTableViewFooter;
- (void)endRefreshing;
- (void)updateSubviews;

@end
