//
//  PublicShowTableVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/8.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicShowTableVC.h"

@interface PublicShowTableVC ()

@end

@implementation PublicShowTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - public
- (void)cancelButtonAction {
    [self goBackWithDone:NO];
}
- (void)goBackWithDone:(BOOL)done {
    if (done) {
        [self doDoneAction];
    }
    [self.navigationController popViewControllerAnimated:YES];
    //    QKWEAKSELF;
    //    [self.navigationController dismissViewControllerAnimated:NO completion:^{
    //        if (done) {
    //            [weakself doDoneAction];
    //        }
    //    }];
}

- (void)doDoneAction {
    if (self.doneBlock) {
        self.doneBlock(nil);
    }
}

- (void)loadFirstPageData {
    [self pullBaseListData:YES];
}

- (void)loadMoreData {
    [self pullBaseListData:NO];
}

- (void)pullBaseListData:(BOOL)isReset {
    
}

- (void)updateTableViewHeader {
    QKWEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstPageData];
    }];
}

- (void)updateTableViewFooter {
    QKWEAKSELF;
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakself loadMoreData];
        }];
    }
}

- (void)beginRefreshing {
    self.needRefresh = NO;
    self.isResetCondition = NO;
    [self.tableView.mj_header beginRefreshing];
}

- (void)endRefreshing {
    //记录刷新时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.dateKey];
    [self doHideHudFunction];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)updateSubviews {
    [self.tableView reloadData];
}

#pragma mark - getter
- (NSString *)dateKey{
    if (!_dateKey) {
        _dateKey = [NSString stringWithFormat:@"%@_dateKey_%d", [self class], (int)self.indextag];
    }
    return _dateKey;
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kEdgeSmall;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kEdgeSmall;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end
