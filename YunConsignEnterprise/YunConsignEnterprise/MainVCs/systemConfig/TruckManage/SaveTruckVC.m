//
//  SaveTruckVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/29.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SaveTruckVC.h"

@interface SaveTruckVC ()

@end

@implementation SaveTruckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.baseData) {
        self.title = @"车辆详情";
        self.toSaveData = [AppTruckDetailInfo mj_objectWithKeyValues:[self.baseData mj_keyValues]];
    }
    else {
        self.title = @"添加车辆";
        self.toSaveData = [AppTruckDetailInfo new];
    }
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"车牌号",@"subTitle":@"请输入",@"key":@"truck_number_plate", @"need" : self.baseData ? @NO : @YES},
                       @{@"title":@"司机",@"subTitle":@"请输入",@"key":@"truck_driver_name", @"need" : self.baseData ? @NO : @YES},
                       @{@"title":@"电话",@"subTitle":@"请输入",@"key":@"truck_driver_phone", @"need" : self.baseData ? @NO : @YES},
                       @{@"title":@"开户行",@"subTitle":@"请输入",@"key":@"driver_account_bank", @"need" : self.baseData ? @NO : @YES},
                       @{@"title":@"银行卡号",@"subTitle":@"请输入",@"key":@"driver_account", @"need" : self.baseData ? @NO : @YES},
                       @{@"title":@"户主",@"subTitle":@"请输入",@"key":@"driver_account_name", @"need" : self.baseData ? @NO : @YES},
                       @{@"title":@"备注",@"subTitle":@"请输入",@"key":@"note", @"need":@NO},];
}

- (void)pullDetailData {
    [self doShowHudFunction];
    NSDictionary *m_dic = @{@"truck_id" : [self.baseData valueForKey:@"truck_id"]};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_base_queryTruckDetailById" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = (ResponseItem *)responseBody;
            if (item.items.count) {
                AppTruckDetailInfo *detailData = [AppTruckDetailInfo mj_objectWithKeyValues:item.items[0]];
                self.detailData = [detailData copy];
                weakself.toSaveData = detailData;
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
        NSObject *value = [self.toSaveData valueForKey:key];
        if ([dic[@"need"] boolValue] && !value) {
            [self doShowHintFunction:[NSString stringWithFormat:@"%@%@", [self.selectorSet containsObject:key] ? @"请选择" : @"请补全", dic[@"title"]]];
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
            [m_dic setObject:[self.baseData valueForKey:@"truck_id"] forKey:@"truck_id"];
        }
        else {
            [self doShowHintFunction:@"未做修改"];
            return;
        }
    }
    
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:self.baseData ? @"hex_base_updateTruckById" : @"hex_base_saveTruck" Parm:m_dic completion:^(id responseBody, NSError *error){
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
