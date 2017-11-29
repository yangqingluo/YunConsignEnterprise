//
//  SaveJsonUserVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/28.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SaveJsonUserVC.h"
#import "PublicSelectionVC.h"

@interface SaveJsonUserVC ()

@end

@implementation SaveJsonUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.baseData) {
        self.title = [NSString stringWithFormat:@"%@的详细信息", [self.baseData valueForKey:@"user_name"]];
        self.toSaveData = [AppUserDetailInfo mj_objectWithKeyValues:[self.baseData mj_keyValues]];
        [self.toSaveData setValue:nil forKey:@"login_pass"];
    }
    else {
        self.title = @"添加员工";
        self.toSaveData = [AppUserDetailInfo new];
    }
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"账号",@"subTitle":@"请输入",@"key":@"login_code", @"need" : self.baseData ? @NO : @YES},
                       @{@"title":@"密码",@"subTitle":@"请输入密码",@"key":@"login_pass", @"need" : self.baseData ? @NO : @YES},
                       @{@"title":@"姓名",@"subTitle":@"请输入",@"key":@"user_name", @"need" : self.baseData ? @NO : @YES},
                       @{@"title":@"电话",@"subTitle":@"请输入",@"key":@"telphone", @"need" : self.baseData ? @NO : @YES},
                       @{@"title":@"所属网点",@"subTitle":@"请选择",@"key":@"service", @"showKey":@"service_name", @"need" : self.baseData ? @NO : @YES},
                       @{@"title":@"所属岗位",@"subTitle":@"请选择",@"key":@"user_role", @"showKey":@"role_name", @"need" : self.baseData ? @NO : @YES},
                       @{@"title":@"账目查看",@"subTitle":@"请选择",@"key":@"power_service", @"showKey":@"power_service_name", @"need" : @NO},
                       @{@"title":@"性别",@"subTitle":@"请选择",@"key":@"gender", @"showKey":@"gender_text", @"need" : self.baseData ? @NO : @YES},];
    [self.selectorSet addObjectsFromArray:@[@"service", @"user_role", @"power_service", @"gender"]];
//    [self.numberKeyBoardTypeSet addObjectsFromArray:@[@"telphone"]];
}

- (void)pullDetailData {
    if (!self.baseData) {
        return;
    }
    [self doShowHudFunction];
    NSDictionary *m_dic = @{@"user_id" : [self.baseData valueForKey:@"user_id"]};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_base_queryJoinUserByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = (ResponseItem *)responseBody;
            if (item.items.count) {
                AppUserDetailInfo *detailData = [AppUserDetailInfo mj_objectWithKeyValues:item.items[0]];
                weakself.detailData = detailData;
                weakself.toSaveData = [detailData copy];
                [weakself.toSaveData setValue:nil forKey:@"login_pass"];
            }
            [weakself updateSubviews];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)pushUpdateData {
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    for (NSDictionary *dic in self.showArray) {
        NSString *key = dic[@"key"];
        BOOL need = [dic[@"need"] boolValue];
        if ([key isEqualToString:@"service"] || [key isEqualToString:@"power_service"] || [key isEqualToString:@"user_role"]) {
            NSString *key_id = [NSString stringWithFormat:@"%@_id", key];
            NSString *key_name = [NSString stringWithFormat:@"%@_name", key];
            if ([key isEqualToString:@"user_role"]) {
                key_id = [NSString stringWithFormat:@"%@_id", @"role"];
                key_name = [NSString stringWithFormat:@"%@_name", @"role"];
            }
            if (need && (![self.toSaveData valueForKey:key_id] || ![self.toSaveData valueForKey:key_name])) {
                [self doShowHintFunction:[NSString stringWithFormat:@"请选择%@", dic[@"title"]]];
                return;
            }
            if ([self.toSaveData valueForKey:key_id]) {
                [m_dic setObject:[self.toSaveData valueForKey:key_id] forKey:key_id];
            }
            if ([self.toSaveData valueForKey:key_name]) {
                [m_dic setObject:[self.toSaveData valueForKey:key_name] forKey:key_name];
            }
        }
        else {
            NSObject *value = [self.toSaveData valueForKey:key];
            if (need && !value) {
                [self doShowHintFunction:[NSString stringWithFormat:@"%@%@", [self.selectorSet containsObject:key] ? @"请选择" : @"请补全", dic[@"title"]]];
                return;
            }
            
            if (value) {
                [m_dic setObject:value forKey:key];
            }
        }
    }
    if (self.baseData) {
        NSDictionary *baseDic = [self.detailData mj_keyValues];
        BOOL hasChange = NO;
        for (NSString *key in m_dic) {
            if (![m_dic[key] isEqualToString:baseDic[key]]) {
                hasChange = YES;
                break;
            }
        }
        if (hasChange) {
            [m_dic setObject:[self.baseData valueForKey:@"user_id"] forKey:@"user_id"];
        }
        else {
            [self doShowHintFunction:@"未做修改"];
            return;
        }
    }
    
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:self.baseData ? @"hex_base_updateJoinUserByIdFunction" : @"hex_base_saveJoinUserFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = responseBody;
            if (item.flag == 1) {
                [weakself saveDataSuccess];
            }
            else {
                [weakself doShowHintFunction:item.message.length ? item.message : @"数据出错"];
            }
        }
        else {
            [weakself doShowHintFunction:error.userInfo[@"message"]];
        }
    }];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    NSDictionary *m_dic = self.showArray[indexPath.row];
    NSString *key = m_dic[@"key"];
    if ([key isEqualToString:@"gender"]) {
        NSArray *dicArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
        if (dicArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dicArray.count];
            for (AppDataDictionary *m_data in dicArray) {
                [m_array addObject:m_data.item_name];
            }
            QKWEAKSELF;
            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                if (buttonIndex > 0 && (buttonIndex - 1) < dicArray.count) {
                    AppDataDictionary *dataDic = dicArray[buttonIndex - 1];
                    [weakself.toSaveData setValue:dataDic.item_val forKey:key];
                    [weakself.toSaveData setValue:dataDic.item_name forKey:[NSString stringWithFormat:@"%@_text", key]];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            } otherButtonTitlesArray:m_array];
            [sheet showInView:self.view];
        }
        else {
            [self pullDataDictionaryFunctionForCode:key selectionInIndexPath:indexPath];
        }
    }
    else if ([key isEqualToString:@"user_role"]) {
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
        if (dataArray.count) {
            NSMutableArray *source_array = [NSMutableArray new];
            NSMutableArray *selected_array = [NSMutableArray new];
            for (NSUInteger i = 0; i < dataArray.count; i++) {
                AppDataDictionary *item = dataArray[i];
                [source_array addObject:item.item_name];
                if ([[[self.toSaveData valueForKey:@"role_id"] componentsSeparatedByString:@","] containsObject:item.item_val]) {
                    [selected_array addObject:@(i)];
                }
            }
            QKWEAKSELF;
            PublicSelectionVC *vc = [[PublicSelectionVC alloc] initWithDataSource:source_array selectedArray:selected_array maxSelectCount:dataArray.count back:^(NSObject *object){
                if ([object isKindOfClass:[NSArray class]]) {
                    NSMutableArray *name_array = [NSMutableArray new];
                    NSMutableArray *id_array = [NSMutableArray new];
                    for (NSNumber *number in (NSArray *)object) {
                        NSInteger index = [number integerValue];
                        if (index < dataArray.count && index >= 0) {
                            AppDataDictionary *item = dataArray[index];
                            [name_array addObject:item.item_name];
                            [id_array addObject:item.item_val];
                        }
                    }
                    [weakself.toSaveData setValue:[name_array componentsJoinedByString:@","] forKey:@"role_name"];
                    [weakself.toSaveData setValue:[id_array componentsJoinedByString:@","] forKey:@"role_id"];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            vc.title = [NSString stringWithFormat:@"选择%@", m_dic[@"title"]];
            [self doPushViewController:vc animated:YES];
        }
        else {
            [self pullDataDictionaryFunctionForCode:key selectionInIndexPath:indexPath];
        }
    }
    else if ([key isEqualToString:@"service"]) {
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
        if (dataArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dataArray.count];
            for (AppServiceInfo *m_data in dataArray) {
                [m_array addObject:m_data.showCityAndServiceName];
            }
            QKWEAKSELF;
            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                if (buttonIndex > 0 && (buttonIndex - 1) < dataArray.count) {
                    AppServiceInfo *service = dataArray[buttonIndex - 1];
                    [weakself.toSaveData setValue:service.service_name forKey:@"service_name"];
                    [weakself.toSaveData setValue:service.service_id forKey:@"service_id"];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            } otherButtonTitlesArray:m_array];
            [sheet showInView:self.view];
        }
        else {
            [self pullServiceArrayFunctionForCode:key selectionInIndexPath:indexPath];
        }
    }
    else if ([key isEqualToString:@"power_service"]) {
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
        if (dataArray.count) {
            NSMutableArray *source_array = [NSMutableArray new];
            NSMutableArray *selected_array = [NSMutableArray new];
            for (NSUInteger i = 0; i < dataArray.count; i++) {
                AppServiceInfo *item = dataArray[i];
                [source_array addObject:item.showCityAndServiceName];
                if ([[[self.toSaveData valueForKey:@"power_service_id"] componentsSeparatedByString:@","] containsObject:item.service_id]) {
                    [selected_array addObject:@(i)];
                }
            }
            QKWEAKSELF;
            PublicSelectionVC *vc = [[PublicSelectionVC alloc] initWithDataSource:source_array selectedArray:selected_array maxSelectCount:dataArray.count back:^(NSObject *object){
                if ([object isKindOfClass:[NSArray class]]) {
                    NSMutableArray *name_array = [NSMutableArray new];
                    NSMutableArray *id_array = [NSMutableArray new];
                    for (NSNumber *number in (NSArray *)object) {
                        NSInteger index = [number integerValue];
                        if (index < dataArray.count && index >= 0) {
                            AppServiceInfo *item = dataArray[index];
                            [name_array addObject:item.service_name];
                            [id_array addObject:item.service_id];
                        }
                    }
                    [weakself.toSaveData setValue:[name_array componentsJoinedByString:@","] forKey:@"power_service_name"];
                    [weakself.toSaveData setValue:[id_array componentsJoinedByString:@","] forKey:@"power_service_id"];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            vc.title = [NSString stringWithFormat:@"选择%@", m_dic[@"title"]];
            [self doPushViewController:vc animated:YES];
            
            
            
//            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dataArray.count];
//            for (AppServiceInfo *m_data in dataArray) {
//                [m_array addObject:m_data.showCityAndServiceName];
//            }
//            QKWEAKSELF;
//            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
//                if (buttonIndex > 0 && (buttonIndex - 1) < dataArray.count) {
//                    AppServiceInfo *service = dataArray[buttonIndex - 1];
//                    [weakself.toSaveData setValue:service.service_name forKey:@"power_service_name"];
//                    [weakself.toSaveData setValue:service.service_id forKey:@"power_service_id"];
//                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                }
//            } otherButtonTitlesArray:m_array];
//            [sheet showInView:self.view];
        }
        else {
            [self pullServiceArrayFunctionForCode:key selectionInIndexPath:indexPath];
        }
    }
}

@end
