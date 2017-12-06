//
//  CodCheckVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/1.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodCheckVC.h"
#import "CodCheckDetailVC.h"

@interface CodCheckVC ()

@end

@implementation CodCheckVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_CodQuery;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"代收款已收对账";
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"时间类型",@"subTitle":@"请选择",@"key":@"search_time_type"},
                       @{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                       @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                       @{@"title":@"代收方式",@"subTitle":@"请选择",@"key":@"cash_on_delivery_type"},
                       @{@"title":@"收款网点",@"subTitle":@"请选择",@"key":@"power_service"},
                       @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                       @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
    AppServiceInfo *serviceInfo = [AppServiceInfo mj_objectWithKeyValues:[[UserPublic getInstance].userData mj_keyValues]];
    self.condition.power_service = serviceInfo;
    [self initialDataDictionaryForCodeArray:@[@"search_time_type", @"query_column"]];
}

- (void)searchButtonAction {
    if (!self.condition.search_time_type) {
        [self showHint:@"请选择时间类型"];
        return;
    }
    CodCheckDetailVC *vc = [[CodCheckDetailVC alloc] initWithStyle:UITableViewStylePlain];
    vc.condition = [self.condition copy];
    vc.condition.show_column = [[UserPublic getInstance].dataMapDic objectForKey:@"show_column_cod_check"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"power_service"]) {
        if ([UserPublic getInstance].financeData) {
            if (!isTrue([UserPublic getInstance].financeData.is_finance)) {
                [self showHint:@"只有财务才能选择收款网点"];
                return;
            }
        }
        else {
            [self doCheckUserIsOrNotFinanceFunction:indexPath];
            return;
        }
    }
    
    [super selectRowAtIndexPath:indexPath];
}

@end
