//
//  SaveOpenCityVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/21.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "SaveOpenCityVC.h"

@interface SaveOpenCityVC ()

@end

@implementation SaveOpenCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"城市详情";
    if (!self.baseData) {
        self.toSaveData = [AppCityDetailInfo new];
    }
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"城市",@"subTitle":@"请输入",@"key":@"open_city_name", @"need" : @YES},
                       @{@"title":@"拼音",@"subTitle":@"请输入",@"key":@"open_city_py", @"need" : @YES},
                       @{@"title":@"排序",@"subTitle":@"请输入",@"key":@"sort"}];
}

- (void)pullDetailData {
    [self doShowHudFunction];
    NSDictionary *m_dic = @{@"open_city_id" : [self.baseData valueForKey:@"open_city_id"]};
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:@"hex_base_queryOpenCityById" Parm:m_dic completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            ResponseItem *item = (ResponseItem *)responseBody;
            if (item.items.count) {
                weakself.toSaveData = [AppCityDetailInfo mj_objectWithKeyValues:item.items[0]];
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
            [self showHint:[NSString stringWithFormat:@"%@%@", [self.selectorSet containsObject:key] ? @"请选择" : @"请补全", dic[@"title"]]];
            return;
        }
        
        if (value) {
            [m_dic setObject:value forKey:key];
        }
    }
    if (self.baseData) {
//        [m_dic setObject:[self.baseData valueForKey:@"open_city_id"] forKey:@"open_city_id"];
    }
    
    [self doShowHudFunction];
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] commonSoapPost:self.baseData ? @"hex_base_updateOpenCityById" : @"hex_base_saveOpenCityFunction" Parm:m_dic completion:^(id responseBody, NSError *error){
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
