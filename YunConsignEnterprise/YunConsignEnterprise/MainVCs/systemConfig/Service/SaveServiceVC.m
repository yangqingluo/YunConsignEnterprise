//
//  SaveServiceVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/22.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SaveServiceVC.h"
#import "ServiceLocationVC.h"

@interface SaveServiceVC ()

@end

@implementation SaveServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.baseData) {
        self.title = @"修改门店";
        self.toSaveData = [AppServiceDetailInfo mj_objectWithKeyValues:[self.baseData mj_keyValues]];
    }
    else {
        self.title = @"添加门店";
        self.toSaveData = [AppServiceDetailInfo new];
    }
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"所属城市",@"subTitle":@"请输入",@"key":@"open_city", @"need" : @YES},
                       @{@"title":@"门店名称",@"subTitle":@"请输入",@"key":@"service_name", @"need" : @YES},
                       @{@"title":@"门店地址",@"subTitle":@"请输入",@"key":@"service_address", @"need" : @YES},
                       @{@"title":@"门店代码",@"subTitle":@"请输入",@"key":@"service_code", @"need" : @YES},
                       @{@"title":@"门店电话",@"subTitle":@"请输入",@"key":@"service_phone", @"need" : @YES},
                       @{@"title":@"拼音简称",@"subTitle":@"请输入",@"key":@"service_pinyin", @"need" : @YES},
                       @{@"title":@"门店状态",@"subTitle":@"请选择",@"key":@"service_state", @"need" : @YES},
                       @{@"title":@"打印标签",@"subTitle":@"请输入",@"key":@"print_count", @"need" : @YES},
                       @{@"title":@"负责人",@"subTitle":@"请输入",@"key":@"responsible_name", @"need" : @YES},
                       @{@"title":@"联系电话",@"subTitle":@"请输入",@"key":@"responsible_phone", @"need" : @YES},
                       @{@"title":@"定位",@"subTitle":@"请定位",@"key":@"location", @"need" : @YES},];
    [self.selectorSet addObjectsFromArray:@[@"open_city", @"service_state", @"location"]];
    [self.numberKeyBoardTypeSet addObjectsFromArray:@[@"print_count"]];
}

- (void)pullDetailData {
    if (!self.baseData) {
        return;
    }
    [self doShowHudFunction];
    NSDictionary *m_dic = @{@"service_id" : [self.baseData valueForKey:@"service_id"]};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_base_queryServiceByIdFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = (ResponseItem *)responseBody;
            if (item.items.count) {
                AppServiceDetailInfo *detailData = [AppServiceDetailInfo mj_objectWithKeyValues:item.items[0]];
                if (detailData.longitude && detailData.latitude) {
                    detailData.location = @"已定位";
                }
                weakself.detailData = detailData;
                weakself.toSaveData = [detailData copy];
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
    if ([key isEqualToString:@"service_state"]) {
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
    else if ([key isEqualToString:@"location"]) {
        ServiceLocationVC *vc = [ServiceLocationVC new];
        NSString *latitude = [self.toSaveData valueForKey:@"latitude"];
        NSString *longitude = [self.toSaveData valueForKey:@"longitude"];
        if (latitude && longitude) {
            vc = [[ServiceLocationVC alloc] initWithLocation:CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]) andAddress:[self.toSaveData valueForKey:@"service_address"] isSend:YES];
        }
        QKWEAKSELF;
        vc.doneBlock = ^(NSObject *object){
            if ([object isKindOfClass:[AppLocationInfo class]]) {
                AppLocationInfo *location = (AppLocationInfo *)object;
                [weakself.toSaveData setValue:location.latitude forKey:@"latitude"];
                [weakself.toSaveData setValue:location.longitude forKey:@"longitude"];
                [weakself.toSaveData setValue:@"已定位" forKey:@"location"];
                [weakself.tableView reloadData];
            }
        };
        [vc showFromVC:self];
    }
}

#pragma  mark - TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    BOOL m_bool = YES;
    NSInteger length = kInputLengthMax;
    if ([textField isKindOfClass:[IndexPathTextField class]]) {
        NSIndexPath *indexPath = [(IndexPathTextField *)textField indexPath];
        id item = self.showArray[indexPath.row];
        NSString *key = @"";
        if ([item isKindOfClass:[NSDictionary class]]) {
            key = item[@"key"];
        }
        else if ([item isKindOfClass:[NSArray class]]) {
            NSDictionary *m_dic = item[textField.tag];
            key = m_dic[@"key"];
        }
        
        if (key.length) {
//            if ([key isEqualToString:@"responsible_phone"]) {
//                length = kPhoneNumberLength;
//            }
//            else if ([key isEqualToString:@"service_phone"]) {
//                length = kIDLengthMax;//固话长度
//                NSCharacterSet *notNumber=[[NSCharacterSet characterSetWithCharactersInString:NumberWithDash] invertedSet];
//                NSString *string1 = [[string componentsSeparatedByCharactersInSet:notNumber] componentsJoinedByString:@""];
//                m_bool = [string isEqualToString:string1];
//            }
//            else
                if ([self.numberKeyBoardTypeSet containsObject:key]) {
                length = kPriceLengthMax;
            }
        }
    }
    
    return m_bool && (range.location < length);
}

@end
