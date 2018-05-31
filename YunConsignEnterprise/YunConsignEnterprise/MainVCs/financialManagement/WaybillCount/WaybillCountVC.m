//
//  WaybillCountVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/5/31.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "WaybillCountVC.h"
#import "WaybillCountDetailVC.h"
#import "PublicSelectionVC.h"

static NSString *waybillTypeKey = @"waybill_type";
static NSString *startServiceKey = @"start_service";
static NSString *endServiceKey = @"end_service";

@interface WaybillCountVC ()

@property (strong, nonatomic) NSMutableDictionary *townDic;

@end

@implementation WaybillCountVC

- (void)dealloc {
    [self.condition removeObserver:self forKeyPath:waybillTypeKey];
    [self.condition removeObserver:self forKeyPath:startServiceKey];
    [self.condition removeObserver:self forKeyPath:endServiceKey];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = QueryConditionType_WaybillCount;
        NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:@"waybill_type_count"];
        if (dicArray.count) {
            self.condition.waybill_type = dicArray[0];
        }
        [self.condition addObserver:self forKeyPath:waybillTypeKey options:NSKeyValueObservingOptionNew context:NULL];
        [self.condition addObserver:self forKeyPath:startServiceKey options:NSKeyValueObservingOptionNew context:NULL];
        [self.condition addObserver:self forKeyPath:endServiceKey options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.accessInfo.menu_name;
}

//初始化数据
- (void)initializeData {
    [self updateShowArray];
    NSArray *m_array = [[UserPublic getInstance].dataMapDic objectForKey:@"show_column_waybill_count"];
    if (m_array.count > 1) {
        self.condition.show_column = [m_array copy];
    }
    [self initialDataDictionaryForCodeArray:@[@"query_column"]];
}

- (void)updateShowArray {
    [self updateShowArrayForWaybillType:[self.condition.waybill_type.item_val integerValue] realStationCityNameSelectOrInput:[self judgeRealStationCityNameSelectOrInput]];
}

- (void)updateShowArrayForWaybillType:(NSInteger)type realStationCityNameSelectOrInput:(BOOL)select {
    if (select) {
        [self.inputValidSet removeObject:@"real_station_city_name"];
    }
    else {
        [self.inputValidSet addObject:@"real_station_city_name"];
    }
    
    self.showArray = type == 1 ? @[
                         @{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
                         @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
                         @{@"title":@"运单类型",@"subTitle":@"请选择",@"key":@"waybill_type"},
                         @{@"title":@"到站网点",@"subTitle":@"请选择",@"key":@"end_service"},
                         @{@"title":@"中转站",@"subTitle":select?@"请选择":@"请输入",@"key":@"real_station_city_name"},
                         @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
                         @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"},
                         @{@"title":@"显示字段",@"subTitle":@"请选择",@"key":@"show_column"}]
    :
    @[
      @{@"title":@"开始时间",@"subTitle":@"必填，请选择",@"key":@"start_time"},
      @{@"title":@"结束时间",@"subTitle":@"必填，请选择",@"key":@"end_time"},
      @{@"title":@"运单类型",@"subTitle":@"请选择",@"key":@"waybill_type"},
      @{@"title":@"开单网点",@"subTitle":@"请选择",@"key":@"start_service"},
      @{@"title":@"中转站",@"subTitle":select?@"请选择":@"请输入",@"key":@"real_station_city_name"},
      @{@"title":@"查询项目",@"subTitle":@"请选择",@"key":@"query_column"},
      @{@"title":@"查询内容",@"subTitle":@"请输入",@"key":@"query_val"},
      @{@"title":@"显示字段",@"subTitle":@"请选择",@"key":@"show_column"}];
}

- (void)searchButtonAction {
    WaybillCountDetailVC *vc = [[WaybillCountDetailVC alloc] initWithStyle:UITableViewStylePlain];
    vc.type = PublicResultWithScrollTableType_WaybillCount;
    vc.condition = self.condition;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"waybill_type"]) {
        NSString *m_key = @"waybill_type_count";
        NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:m_key];
        if (dicArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dicArray.count];
            for (AppDataDictionary *m_data in dicArray) {
                [m_array addObject:m_data.item_name];
            }
            QKWEAKSELF;
            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                if (buttonIndex > 0 && (buttonIndex - 1) < dicArray.count) {
                    [weakself.condition setValue:dicArray[buttonIndex - 1] forKey:key];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            } otherButtonTitlesArray:m_array];
            [sheet showInView:self.view];
        }
        else {
            //本地数据，不存在else的情况
        }
        return;
    }
    else if ([key isEqualToString:@"show_column"]) {
        NSString *m_key = @"show_column_waybill_count";
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
    else if ([key isEqualToString:@"real_station_city_name"]) {
        AppServiceInfo *info = [self currentServiceInfo];
        if (info) {
            NSArray *townArray = self.townDic[info.service_id];
            if (townArray) {
                if (!townArray.count) {
                    return;
                }
                NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:townArray.count];
                for (AppTownInfo *item in townArray) {
                    [m_array addObject:item.town_name];
                }
                QKWEAKSELF;
                BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                    if (buttonIndex > 0 && (buttonIndex - 1) < townArray.count) {
                        [weakself.condition setValue:m_array[buttonIndex - 1] forKey:key];
                        [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                } otherButtonTitlesArray:m_array];
                [sheet showInView:self.view];
            }
            else {
                [self pullServiceTownArrayFunction:info.service_id atIndexPath:nil];
            }
        }
        return;
    }
    [super selectRowAtIndexPath:indexPath];
}

- (void)pullServiceTownArrayFunction:(NSString *)service_id atIndexPath:(NSIndexPath *)indexPath {
    if (!service_id) {
        return;
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_base_queryTownListById" Parm:@{@"service_id" : service_id} completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            NSArray *m_array = [AppTownInfo mj_objectArrayWithKeyValuesArray:[responseBody valueForKey:@"items"]];
            if (!m_array) {
                m_array = [NSArray new];
            }
            [weakself.townDic setObject:m_array forKey:service_id];
            [weakself updateShowArray];
            [weakself.tableView reloadData];
            if (indexPath) {
                [self selectRowAtIndexPath:indexPath];
            }
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (BOOL)judgeRealStationCityNameSelectOrInput {
    AppServiceInfo *info = [self currentServiceInfo];
    if (info) {
        NSArray *townArray = self.townDic[info.service_id];
        return townArray.count > 0;
    }
    return NO;
}

- (AppServiceInfo *)currentServiceInfo {
    AppServiceInfo *info = nil;
    if ([self.condition.waybill_type.item_val isEqualToString:@"1"]) {
        info = self.condition.end_service;
    }
    else {
        info = self.condition.start_service;
    }
    return info;
}

#pragma mark - getter
- (NSMutableDictionary *)townDic {
    if (!_townDic) {
        _townDic = [NSMutableDictionary new];
    }
    return _townDic;
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:waybillTypeKey]) {
        [self updateShowArray];
        [self.tableView reloadData];
    }
    else if ([keyPath isEqualToString:startServiceKey] || [keyPath isEqualToString:endServiceKey]) {
        [self updateShowArray];
        [self.tableView reloadData];
        AppServiceInfo *info = [self currentServiceInfo];
        if (info) {
            self.condition.real_station_city_name = nil;
            NSArray *townArray = self.townDic[info.service_id];
            if (!townArray) {
                [self pullServiceTownArrayFunction:info.service_id atIndexPath:nil];
            }
        }
    }
}

@end
