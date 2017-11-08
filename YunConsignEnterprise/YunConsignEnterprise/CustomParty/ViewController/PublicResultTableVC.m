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

@end
