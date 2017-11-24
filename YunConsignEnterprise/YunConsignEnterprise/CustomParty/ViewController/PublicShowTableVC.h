//
//  PublicShowTableVC.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/8.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppBasicTableViewController.h"
#import "BlockActionSheet.h"
#import "SingleInputCell.h"
#import "PublicDatePickerView.h"
#import "MJRefresh.h"

@interface PublicShowTableVC : AppBasicTableViewController

@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) id showData;
@property (assign, nonatomic) BOOL isResetCondition;
@property (strong, nonatomic) NSString *dateKey;
@property (assign, nonatomic) NSInteger indextag;

- (void)cancelButtonAction;
- (void)goBackWithDone:(BOOL)done;
- (void)doDoneAction;
- (void)updateTableViewHeader;
- (void)updateTableViewFooter;
- (void)beginRefreshing;
- (void)endRefreshing;
- (void)updateSubviews;
- (void)loadFirstPageData;
- (void)loadMoreData;
- (void)pullBaseListData:(BOOL)isReset;

@end
