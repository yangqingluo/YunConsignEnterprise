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

- (void)endRefreshing{
    //记录刷新时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.dateKey];
    [self doHideHudFunction];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)updateSubviews {
    [self.tableView reloadData];
}

- (void)showFromVC:(AppBasicViewController *)fromVC {
    [fromVC.navigationController pushViewController:self animated:YES];
    //    MainTabNavController *nav = [[MainTabNavController alloc] initWithRootViewController:self];
    //    [fromVC presentViewController:nav animated:NO completion:^{
    //
    //    }];
}

- (void)editAtIndex:(NSUInteger )row andContent:(NSString *)content {
    
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - getter
- (NSString *)dateKey{
    if (!_dateKey) {
        _dateKey = [NSString stringWithFormat:@"%@_dateKey_%d", [self class], (int)self.indextag];
    }
    return _dateKey;
}

#pragma  mark - TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return (range.location < kInputLengthMax);
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[IndexPathTextField class]]) {
        NSIndexPath *indexPath = [(IndexPathTextField *)textField indexPath];
        [self editAtIndex:indexPath.row andContent:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
