//
//  PublicSlideTableVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/2.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicResultTableVC.h"

@interface PublicResultTableVC ()

@end

@implementation PublicResultTableVC

- (instancetype)initWithStyle:(UITableViewStyle)style parentVC:(AppBasicViewController *)pVC andIndexTag:(NSInteger)index {
    self = [super initWithStyle:style];
    if (self) {
        self.indextag = index;
        self.parentVC = pVC;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style andIndexTag:(NSInteger)index{
    self = [super initWithStyle:style];
    if (self) {
        self.indextag = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)becomeListed {
    NSDate *lastRefreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
    if (self.isResetCondition || self.needRefresh || !self.dataSource.count || !lastRefreshTime || [lastRefreshTime timeIntervalSinceNow] < -appRefreshTime) {
        [self beginRefreshing];
    }
}

- (void)becomeUnListed {
    
}

- (void)pullBaseTotalData:(BOOL)isReset parm:(NSDictionary *)parm {
    
}

- (void)confirmRemovingDataAtIndexPath:(NSIndexPath *)indexPath {
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定删除吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakself doRemovingDataAtIndexPath:indexPath];
        }
    } otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)doRemovingDataAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.dataSource.count - 1) {
        [self doShowHintFunction:@"数据越界"];
        return;
    }
    
}

- (void)removeItemSuccessAtIndexPath:(NSIndexPath *)indexPath {
//    [self.tableView beginUpdates];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
//    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView endUpdates];
}

#pragma mark - getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (NSMutableSet *)selectSet {
    if (!_selectSet) {
        _selectSet = [NSMutableSet new];
    }
    return _selectSet;
}

- (AppQueryConditionInfo *)condition {
    if (!_condition) {
        _condition = [AppQueryConditionInfo new];
    }
    return _condition;
}

#pragma mark - UITableView
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self confirmRemovingDataAtIndexPath:indexPath];
    }
}

@end
