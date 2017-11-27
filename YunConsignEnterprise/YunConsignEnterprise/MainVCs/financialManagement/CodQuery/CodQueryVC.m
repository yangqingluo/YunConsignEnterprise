//
//  CodQueryVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/31.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodQueryVC.h"
#import "CodQueryDetailVC.h"

@interface CodQueryVC ()

@end

@implementation CodQueryVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_CodQuery;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"代收款综合查询";
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"时间类型",@"subTitle":@"请选择",@"key":@"search_time_type"},
                       @{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                       @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                       @{@"title":@"代收方式",@"subTitle":@"请选择",@"key":@"cash_on_delivery_type"},
                       @{@"title":@"收款状态",@"subTitle":@"请选择",@"key":@"cod_payment_state"},
                       @{@"title":@"放款状态",@"subTitle":@"请选择",@"key":@"cod_loan_state"},
                       @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                       @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
    [self initialDataDictionaryForCodeArray:@[@"search_time_type", @"query_column"]];
}

- (void)searchButtonAction {
    if (!self.condition.search_time_type) {
        [self showHint:@"请选择时间类型"];
        return;
    }
    CodQueryDetailVC *vc = [CodQueryDetailVC new];
    vc.condition = [self.condition copy];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
