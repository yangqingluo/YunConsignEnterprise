//
//  FreightCheckVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/27.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "FreightCheckVC.h"

@interface FreightCheckVC ()

@end

@implementation FreightCheckVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_FreightCheck;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.accessInfo.menu_name;
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"时间类型",@"subTitle":@"请选择",@"key":@"search_time_type"},
                       @{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                       @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                       @{@"title":@"收款网点",@"subTitle":@"请选择",@"key":@"power_service"},
                       @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                       @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"},
                       @{@"title":@"显示字段",@"subTitle":@"现付、提付、回单付",@"key":@"show_column"}];
    [self checkDataMapExistedFor:@"search_time_type"];
    [self checkDataMapExistedFor:@"query_column"];
}

@end
