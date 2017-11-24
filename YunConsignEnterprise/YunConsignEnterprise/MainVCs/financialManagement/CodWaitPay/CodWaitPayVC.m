//
//  CodWaitPayVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/1.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodWaitPayVC.h"
#import "CodWaitPayDetailVC.h"

@interface CodWaitPayVC ()

@end

@implementation CodWaitPayVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_CodWaitPay;
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
                       @{@"title":@"开单网点",@"subTitle":@"请选择",@"key":@"start_service"},
                       @{@"title":@"代收方式",@"subTitle":@"请选择",@"key":@"cash_on_delivery_type"},
                       @{@"title":@"是否收货",@"subTitle":@"请选择",@"key":@"waybill_receive_state"},
                       @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                       @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
    [self checkDataMapExistedForCode:@"search_time_type"];
    [self checkDataMapExistedForCode:@"query_column"];
}

- (void)searchButtonAction {
    if (!self.condition.search_time_type) {
        [self showHint:@"请选择时间类型"];
        return;
    }
    CodWaitPayDetailVC *vc = [CodWaitPayDetailVC new];
    vc.condition = [self.condition copy];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
