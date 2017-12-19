//
//  FreightCheckVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/10/27.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "FreightCheckVC.h"
#import "FreightCheckDetailVC.h"
#import "PublicSelectionVC.h"

static NSString *searchTimeTypeKey = @"search_time_type";

@interface FreightCheckVC () {
    BOOL canSelectShowColumns;
}

@end

@implementation FreightCheckVC

- (void)dealloc {
    [self.condition removeObserver:self forKeyPath:searchTimeTypeKey];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_FreightCheck;
        [self.condition addObserver:self forKeyPath:searchTimeTypeKey options:NSKeyValueObservingOptionNew context:NULL];
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
                       @{@"title":@"收款网点",@"subTitle":@"请选择",@"key":@"power_service_array"},
                       @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                       @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"},
                       @{@"title":@"显示字段",@"subTitle":@"请选择",@"key":@"show_column"}];
    AppServiceInfo *serviceInfo = [AppServiceInfo mj_objectWithKeyValues:[[UserPublic getInstance].userData mj_keyValues]];
    self.condition.power_service_array = @[serviceInfo];
    [self initialDataDictionaryForCodeArray:@[@"search_time_type", @"query_column"]];
}

- (void)searchButtonAction {
    if (!self.condition.search_time_type) {
        [self showHint:@"请选择时间类型"];
        return;
    }
    
    FreightCheckDetailVC *vc = [[FreightCheckDetailVC alloc] initWithStyle:UITableViewStylePlain];
    vc.type = PublicResultWithScrollTableType_FreightCheck;
    vc.condition = self.condition;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"power_service_array"]) {
        if ([UserPublic getInstance].financeData) {
            if (!isTrue([UserPublic getInstance].financeData.is_finance)) {
                [self showHint:@"只有财务才能选择收款网点"];
            }
            else {
                NSString *m_key = @"power_service";
                NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:m_key];
                if (dataArray.count) {
                    NSMutableArray *source_array = [NSMutableArray new];
                    NSMutableArray *selected_array = [NSMutableArray new];
                    NSArray *power_array = self.condition.IDArrayForPowerServiceArray;
                    for (NSUInteger i = 0; i < dataArray.count; i++) {
                        AppServiceInfo *item = dataArray[i];
                        [source_array addObject:item.showCityAndServiceName];
                        if ([power_array containsObject:item.service_id]) {
                            [selected_array addObject:@(i)];
                        }
                    }
                    QKWEAKSELF;
                    PublicSelectionVC *vc = [[PublicSelectionVC alloc] initWithDataSource:source_array selectedArray:selected_array maxSelectCount:dataArray.count back:^(NSObject *object){
                        if ([object isKindOfClass:[NSArray class]]) {
                            NSMutableArray *m_array = [NSMutableArray new];
                            for (NSNumber *number in (NSArray *)object) {
                                NSInteger index = [number integerValue];
                                if (index < dataArray.count && index >= 0) {
                                    [m_array addObject:dataArray[index]];
                                }
                            }
                            [weakself.condition setValue:[NSArray arrayWithArray:m_array] forKey:key];
                            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }];
                    vc.title = [NSString stringWithFormat:@"选择%@", m_dic[@"title"]];
                    [self doPushViewController:vc animated:YES];
                }
                else {
                    [self pullServiceArrayFunctionForCode:m_key selectionInIndexPath:indexPath];
                }
            }
        }
        else {
            [self doCheckUserIsOrNotFinanceFunction:indexPath];
        }
        return;
    }
    else if ([key isEqualToString:@"show_column"]) {
        NSString *m_key = @"show_column_FreightCheck2";
        if (!canSelectShowColumns) {
            m_key = @"show_column_FreightCheck1";
        }
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:m_key];
        if (dataArray.count) {
            NSMutableArray *source_array = [NSMutableArray new];
            NSMutableArray *selected_array = [NSMutableArray new];
            for (NSUInteger i = 0; i < dataArray.count; i++) {
                AppDataDictionary *item = dataArray[i];
                [source_array addObject:item.item_name];
                if ([[self.condition valueForKey:key] containsObject:item]) {
                    [selected_array addObject:@(i)];
                }
            }
            QKWEAKSELF;
            PublicSelectionVC *vc = [[PublicSelectionVC alloc] initWithDataSource:source_array selectedArray:selected_array maxSelectCount:dataArray.count back:^(NSObject *object){
                if ([object isKindOfClass:[NSArray class]]) {
                    NSMutableArray *m_array = [NSMutableArray new];
                    for (NSNumber *number in (NSArray *)object) {
                        NSInteger index = [number integerValue];
                        if (index < dataArray.count && index >= 0) {
                            [m_array addObject:dataArray[index]];
                        }
                    }
                    [weakself.condition setValue:[NSArray arrayWithArray:m_array] forKey:key];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            vc.title = [NSString stringWithFormat:@"选择%@", m_dic[@"title"]];
            [self doPushViewController:vc animated:YES];
        }
        else {
            //本地数据，不存在else的情况
        }
        return;
    }
    [super selectRowAtIndexPath:indexPath];
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:searchTimeTypeKey]) {
        NSString *m_key = @"show_column_FreightCheck2";
        if ([self.condition.search_time_type.item_val integerValue] == 1) {
            canSelectShowColumns = NO;
            m_key = @"show_column_FreightCheck1";
        }
        else {
            canSelectShowColumns = YES;
        }
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:m_key];
        self.condition.show_column = dataArray;
        [self.tableView reloadData];
    }
}

@end
