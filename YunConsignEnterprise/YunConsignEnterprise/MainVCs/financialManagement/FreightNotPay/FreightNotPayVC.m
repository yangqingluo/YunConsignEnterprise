//
//  FreightNotPayVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/12/5.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "FreightNotPayVC.h"
#import "FreightNotPayDetailVC.h"

@interface FreightNotPayVC ()

@end

@implementation FreightNotPayVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_FreightNotPay;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.accessInfo.menu_name;
}

//初始化数据
- (void)initializeData {
    self.showArray = @[
                       @{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                       @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                       @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                       @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"},
                       @{@"title":@"显示字段",@"subTitle":@"请选择",@"key":@"show_column"}];
    [self initialDataDictionaryForCodeArray:@[@"query_column"]];
}

- (void)searchButtonAction {
    FreightNotPayDetailVC *vc = [[FreightNotPayDetailVC alloc] initWithStyle:UITableViewStylePlain];
    vc.type = PublicResultWithScrollTableType_FreightNotPay;
    vc.condition = self.condition;
//    if (!vc.condition.show_column) {
//        NSUInteger count = 3;
//        NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:count];
//        for (AppDataDictionary *item in [[UserPublic getInstance].dataMapDic objectForKey:@"show_column"]) {
//            if (count-- > 0) {
//                [m_array addObject:item];
//            }
//            else {
//                break;
//            }
//        }
//        vc.condition.show_column = [NSArray arrayWithArray:m_array];
//    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkDataMapExistedForCode:(NSString *)key {
    if ([key isEqualToString:@"query_column"]) {
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
        if (dataArray.count >= 4) {
            if (![self.condition valueForKey:key] && [self.toCheckDataMapSet containsObject:key]) {
                self.condition.query_column = dataArray[3];
                [self.tableView reloadData];
                return;
            }
        }
    }
    [super checkDataMapExistedForCode:key];
}


@end
