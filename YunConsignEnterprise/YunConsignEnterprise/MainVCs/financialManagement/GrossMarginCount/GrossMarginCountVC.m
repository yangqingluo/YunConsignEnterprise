//
//  GrossMarginCountVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/2/8.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "GrossMarginCountVC.h"
#import "GrossMarginCountDetailVC.h"

@interface GrossMarginCountVC ()

@end

@implementation GrossMarginCountVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_GrossMarginCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"毛利统计";
}

- (void)initializeData {
    self.showArray = @[
                       @{@"title":@"开始时间",@"subTitle":@"请选择",@"key":@"start_time"},
                       @{@"title":@"结束时间",@"subTitle":@"请选择",@"key":@"end_time"},
                       @{@"title":@"发站城市",@"subTitle":@"请选择",@"key":@"start_station_city"},
                       @{@"title":@"到站城市",@"subTitle":@"请选择",@"key":@"end_station_city"}];
    self.condition.start_time = [self.condition.end_time dateByAddingTimeInterval:-7 * defaultDayTimeInterval];
}

- (void)searchButtonAction {
    GrossMarginCountDetailVC *vc = [[GrossMarginCountDetailVC alloc] initWithStyle:UITableViewStylePlain];
    vc.condition = self.condition;
    vc.type = PublicResultWithScrollTableType_GrossMarginCount;
    vc.condition.show_column = [[UserPublic getInstance].dataMapDic objectForKey:@"show_column_gross_margin"];
    [self doPushViewController:vc animated:YES];
}

@end
