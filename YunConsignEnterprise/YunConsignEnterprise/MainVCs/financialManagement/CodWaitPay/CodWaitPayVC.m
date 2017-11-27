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
    
    self.title = @"代收款未收款查询";
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"时间类型",@"subTitle":@"请选择",@"key":@"cod_search_time_type"},
                       @{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                       @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                       @{@"title":@"开单网点",@"subTitle":@"请选择",@"key":@"start_service"},
                       @{@"title":@"代收方式",@"subTitle":@"请选择",@"key":@"cash_on_delivery_type"},
                       @{@"title":@"是否提货",@"subTitle":@"请选择",@"key":@"waybill_receive_state"},
                       @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                       @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
    [self initialDataDictionaryForCodeArray:@[@"cod_search_time_type", @"query_column"]];
}

- (void)searchButtonAction {
    if (!self.condition.cod_search_time_type) {
        [self showHint:@"请选择时间类型"];
        return;
    }
    CodWaitPayDetailVC *vc = [CodWaitPayDetailVC new];
    vc.condition = [self.condition copy];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pullServiceArrayFunctionForCode:(NSString *)dict_code selectionInIndexPath:(NSIndexPath *)indexPath {
    NSString *functionCode = nil;
    if ([dict_code isEqualToString:@"start_service"]) {
        functionCode = @"hex_waybill_getAllService";
    }
    
    if (!functionCode) {
        return;
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:functionCode Parm:nil completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            NSArray *m_array = [AppServiceInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            if (m_array.count) {
                [[UserPublic getInstance].dataMapDic setObject:m_array forKey:dict_code];
                if (indexPath) {
                    [weakself selectRowAtIndexPath:indexPath];
                }
            }
        }
        else {
            [weakself doShowHintFunction:error.userInfo[@"message"]];
        }
    }];
}

- (void)checkDataMapExistedForCode:(NSString *)key {
    NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
    if (dataArray.count) {
        if (![self.condition valueForKey:key] && [self.toCheckDataMapSet containsObject:key]) {
            [self.condition setValue:[key isEqualToString:@"cod_search_time_type"] ? dataArray[dataArray.count - 1] : dataArray[0] forKey:key];
            [self.tableView reloadData];
        }
    }
    else {
        [self pullDataDictionaryFunctionForCode:key selectionInIndexPath:nil];
    }
}

@end
