//
//  SaveTownVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2018/4/12.
//  Copyright © 2018年 yangqingluo. All rights reserved.
//

#import "SaveTownVC.h"

@interface SaveTownVC ()

@end

@implementation SaveTownVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.baseData) {
        self.title = @"中转站详情";
        self.toSaveData = [AppTownInfo mj_objectWithKeyValues:[self.baseData mj_keyValues]];
    }
    else {
        self.title = @"添加中转站";
        self.toSaveData = [AppTownInfo new];
    }
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"中转站",@"subTitle":@"请输入",@"key":@"town_name", @"need" : @YES},
                       @{@"title":@"联系电话",@"subTitle":@"请输入",@"key":@"town_phone"},
                       @{@"title":@"排序",@"subTitle":@"请输入",@"key":@"sort", @"need" : @YES}];
}

- (void)pullDetailData {
    self.detailData = [self.baseData copy];
//    [self doShowHudFunction];
//    NSDictionary *m_dic = @{@"town_id" : [self.baseData valueForKey:@"town_id"]};
//    QKWEAKSELF;
//    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_base_queryTownById" Parm:m_dic completion:^(id responseBody, NSError *error){
//        [weakself doHideHudFunction];
//        if (!error) {
//            ResponseItem *item = (ResponseItem *)responseBody;
//            if (item.items.count) {
//                AppCityDetailInfo *detailData = [AppCityDetailInfo mj_objectWithKeyValues:item.items[0]];
//                self.detailData = [detailData copy];
//                weakself.toSaveData = detailData;
//            }
//            [weakself updateSubviews];
//        }
//        else {
//            [weakself showHint:error.userInfo[@"message"]];
//        }
//    }];
}

- (void)pushUpdateData {
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    [m_dic setObject:self.service.service_id forKey:@"service_id"];
    for (NSDictionary *dic in self.showArray) {
        NSString *key = dic[@"key"];
        NSObject *value = [self.toSaveData valueForKey:key];
        if ([dic[@"need"] boolValue] && !value) {
            [self showHint:[NSString stringWithFormat:@"%@%@", [self.selectorSet containsObject:key] ? @"请选择" : @"请补全", dic[@"title"]]];
            return;
        }
        
        if (value) {
            [m_dic setObject:value forKey:key];
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
            [m_dic setObject:[self.baseData valueForKey:@"town_id"] forKey:@"town_id"];
        }
        else {
            [self doShowHintFunction:@"未做修改"];
            return;
        }
    }
    
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:self.baseData ? @"hex_base_updateTownById" : @"hex_base_saveTown" Parm:m_dic completion:^(id responseBody, NSError *error){
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


@end
