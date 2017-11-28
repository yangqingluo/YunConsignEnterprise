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
    self.showArray = @[@{@"title":@"账号",@"subTitle":@"请输入",@"key":@"login_code", @"need" : @YES},
                       @{@"title":@"密码",@"subTitle":@"请输入",@"key":@"login_pass", @"need" : @YES},
                       @{@"title":@"姓名",@"subTitle":@"请输入",@"key":@"user_name", @"need" : @YES},
                       @{@"title":@"电话",@"subTitle":@"请输入",@"key":@"telphone", @"need" : @YES},
                       @{@"title":@"所属网点",@"subTitle":@"请选择",@"key":@"service_name", @"need" : @YES},
                       @{@"title":@"所属岗位",@"subTitle":@"请选择",@"key":@"user_role", @"showKey":@"role_name", @"need" : @YES},
                       @{@"title":@"账目查看",@"subTitle":@"请选择",@"key":@"power_service_name", @"need" : @YES},
                       @{@"title":@"性别",@"subTitle":@"请选择",@"key":@"gender", @"showKey":@"gender_text", @"need" : @YES},];
    [self.selectorSet addObjectsFromArray:@[@"service_name", @"user_role", @"power_service_name", @"gender"]];
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
                weakself.toSaveData = [AppUserDetailInfo mj_objectWithKeyValues:item.items[0]];
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
        if ([key isEqualToString:@"open_city"]) {
            if (![self.toSaveData valueForKey:@"open_city_id"] || ![self.toSaveData valueForKey:@"open_city_name"]) {
                [self doShowHintFunction:[NSString stringWithFormat:@"请选择%@", dic[@"title"]]];
                return;
            }
            [m_dic setObject:[self.toSaveData valueForKey:@"open_city_id"] forKey:@"open_city_id"];
            [m_dic setObject:[self.toSaveData valueForKey:@"open_city_name"] forKey:@"open_city_name"];
        }
        else if ([key isEqualToString:@"location"]) {
            NSString *latitude = [self.toSaveData valueForKey:@"latitude"];
            NSString *longitude = [self.toSaveData valueForKey:@"longitude"];
            if (!latitude || !longitude) {
                [self doShowHintFunction:[NSString stringWithFormat:@"%@%@", [self.selectorSet containsObject:key] ? @"请选择" : @"请补全", dic[@"title"]]];
                return;
            }
            else {
                [m_dic setObject:latitude forKey:@"latitude"];
                [m_dic setObject:longitude forKey:@"longitude"];
            }
        }
        else {
            NSObject *value = [self.toSaveData valueForKey:key];
            if ([dic[@"need"] boolValue] && !value) {
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
            [m_dic setObject:[self.baseData valueForKey:@"service_id"] forKey:@"service_id"];
        }
        else {
            [self doShowHintFunction:@"未做修改"];
            return;
        }
    }
    
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:self.baseData ? @"hex_base_updateServiceById" : @"hex_base_saveServiceFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
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
//                if ([[self.condition valueForKey:key] containsObject:item]) {
//                    [selected_array addObject:@(i)];
//                }
            }
            QKWEAKSELF;
            PublicSelectionVC *vc = [[PublicSelectionVC alloc] initWithDataSource:source_array selectedArray:selected_array maxSelectCount:dataArray.count back:^(NSObject *object){
                if ([object isKindOfClass:[NSArray class]]) {
                    NSMutableArray *name_array = [NSMutableArray new];
                    NSMutableArray *id_array = [NSMutableArray new];
                    for (AppDataDictionary *item in (NSArray *)object) {
                        [name_array addObject:item.item_name];
                        [id_array addObject:item.item_val];
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
    else if ([key isEqualToString:@"open_city"]) {
        NSArray *dataArray = [[UserPublic getInstance].dataMapDic objectForKey:key];
        if (dataArray.count) {
            NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:dataArray.count];
            for (AppCityInfo *m_data in dataArray) {
                [m_array addObject:m_data.open_city_name];
            }
            QKWEAKSELF;
            BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@", m_dic[@"title"]] delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
                if (buttonIndex > 0 && (buttonIndex - 1) < dataArray.count) {
                    AppCityInfo *city = dataArray[buttonIndex - 1];
                    [weakself.toSaveData setValue:city.open_city_id forKey:@"open_city_id"];
                    [weakself.toSaveData setValue:city.open_city_name forKey:@"open_city_name"];
                    [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            } otherButtonTitlesArray:m_array];
            [sheet showInView:self.view];
        }
        else {
            [self pullCityArrayFunctionForCode:key selectionInIndexPath:indexPath];
        }
    }
}

@end
