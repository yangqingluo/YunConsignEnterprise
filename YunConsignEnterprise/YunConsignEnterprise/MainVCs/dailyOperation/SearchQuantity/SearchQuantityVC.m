//
//  SearchQuantityVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/17.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SearchQuantityVC.h"
#import "SearchQuantityResultVC.h"

@interface SearchQuantityVC ()

@end

@implementation SearchQuantityVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_SearchQuantity;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.accessInfo.menu_name;
}

//初始化数据
- (void)initializeData{
    self.showArray = @[@{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                   @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                   @{@"title":@"始发站",@"subTitle":@"请选择",@"key":@"start_station_city"},
                   @{@"title":@"终点站",@"subTitle":@"请选择",@"key":@"end_station_city"}];
}

- (void)searchButtonAction {
    SearchQuantityResultVC *vc = [SearchQuantityResultVC new];
    vc.condition = self.condition;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
