//
//  CodCheckVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/1.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "CodCheckVC.h"
#import "CodCheckDetailVC.h"
#import "PublicSelectionVC.h"

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
                       @{@"title":@"收款网点",@"subTitle":@"请选择",@"key":@"power_service_array"},
                       @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column_s"},
                       @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"}];
    AppServiceInfo *serviceInfo = [AppServiceInfo mj_objectWithKeyValues:[[UserPublic getInstance].userData mj_keyValues]];
    self.condition.power_service_array = @[serviceInfo];
    [self initialDataDictionaryForCodeArray:@[@"search_time_type", @"query_column_s"]];
}

- (void)searchButtonAction {
    if (!self.condition.search_time_type) {
        [self showHint:@"请选择时间类型"];
        return;
    }
    CodCheckDetailVC *vc = [[CodCheckDetailVC alloc] initWithStyle:UITableViewStylePlain];
    vc.condition = self.condition;
    vc.condition.show_column = [[UserPublic getInstance].dataMapDic objectForKey:@"show_column_cod_check"];
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
//                    PublicSelectionVC *vc = [[PublicSelectionVC alloc] initWithDataSource:source_array selectedArray:selected_array maxSelectCount:dataArray.count back:^(NSObject *object){
//                        if ([object isKindOfClass:[NSArray class]]) {
//                            NSMutableArray *m_array = [NSMutableArray new];
//                            for (NSNumber *number in (NSArray *)object) {
//                                NSInteger index = [number integerValue];
//                                if (index < dataArray.count && index >= 0) {
//                                    [m_array addObject:dataArray[index]];
//                                }
//                            }
//                            [weakself.condition setValue:[NSArray arrayWithArray:m_array] forKey:key];
//                            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                        }
//                    }];
//                    vc.title = [NSString stringWithFormat:@"选择%@", m_dic[@"title"]];
//                    [self doPushViewController:vc animated:YES];
                    BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                        if (buttonIndex > 0 && (buttonIndex - 1) < dataArray.count) {
                            [weakself.condition setValue:@[dataArray[buttonIndex - 1]] forKey:key];
                            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    } otherButtonTitlesArray:source_array];
                    [sheet showInView:self.view];
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
    
    [super selectRowAtIndexPath:indexPath];
}

@end
