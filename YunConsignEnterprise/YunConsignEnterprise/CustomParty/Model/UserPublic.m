//
//  UserPublic.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "UserPublic.h"

@implementation UserPublic

__strong static UserPublic *_singleManger = nil;
+ (UserPublic *)getInstance {
    _singleManger = [[UserPublic alloc] init];
    return _singleManger;
}

- (instancetype)init {
    if (_singleManger) {
        return _singleManger;
    }
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)saveUserData:(AppUserInfo *)data{
    if (data) {
        _userData = data;
        [self generateRootAccesses];
    }
    
    if (_userData) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[_userData mj_keyValues] forKey:kUserData];
    }
}

- (void)clear{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kUserData];
    
    _singleManger = nil;
}

+ (NSString *)stringForType:(NSInteger)type key:(NSString *)key {
    NSString *m_string = @"";
    NSArray *m_array = [[UserPublic getInstance].dataMapDic objectForKey:key];
    NSInteger index = type - 1;
    if (index >= 0 && index < m_array.count) {
        AppDataDictionary *item = m_array[index];
        m_string = item.item_name;
    }
    
    if (!m_string.length && index < m_array.count) {
        m_string = m_array[index];
    }
    return m_string;
}

- (void)generateRootAccesses {
    NSMutableDictionary *rootAccess = [NSMutableDictionary new];
    for (AppAccessInfo *accessItem in _userData.access_list) {
        if (!accessItem.parent_id) {
            continue;
        }
        if ([accessItem.parent_id isEqualToString:@"0"]) {
            [rootAccess setObject:accessItem forKey:accessItem.menu_id];
        }
    }
    
    [self.dailyOperationAccesses removeAllObjects];
    [self.financialManagementAccesses removeAllObjects];
    [self.systemConfigAccesses removeAllObjects];
    for (AppAccessInfo *accessItem in _userData.access_list) {
        if (!accessItem.parent_id) {
            continue;
        }
        if (![accessItem.parent_id isEqualToString:@"0"]) {
            AppAccessInfo *parentAccess = rootAccess[accessItem.parent_id];
            if (parentAccess) {
                if ([parentAccess.menu_code isEqualToString:@"DAILY_OPERATION"]) {
                    [self.dailyOperationAccesses addObject:accessItem];
                }
                else if ([parentAccess.menu_code isEqualToString:@"FINANCIAL_MANAGE"]) {
                    [self.financialManagementAccesses addObject:accessItem];
                }
                else if ([parentAccess.menu_code isEqualToString:@"SYSTEM_SET"]) {
                    [self.systemConfigAccesses addObject:accessItem];
                }
            }
        }
    }
}

#pragma mark - getter
- (AppUserInfo *)userData{
    if (!_userData) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *data = [ud objectForKey:kUserData];
        if (data) {
            _userData = [AppUserInfo mj_objectWithKeyValues:data];
            [self generateRootAccesses];
        }
    }
    return _userData;
}

- (NSMutableArray *)dailyOperationAccesses {
    if (!_dailyOperationAccesses) {
        _dailyOperationAccesses = [NSMutableArray new];
    }
    return _dailyOperationAccesses;
}

- (NSMutableArray *)financialManagementAccesses {
    if (!_financialManagementAccesses) {
        _financialManagementAccesses = [NSMutableArray new];
    }
    return _financialManagementAccesses;
}

- (NSMutableArray *)systemConfigAccesses {
    if (!_systemConfigAccesses) {
        _systemConfigAccesses = [NSMutableArray new];
    }
    return _systemConfigAccesses;
}

- (NSMutableDictionary *)dataMapDic {
    if (!_dataMapDic) {
        _dataMapDic = [NSMutableDictionary new];
        NSArray *m_array = @[@"daily_name", @"show_column"];
        for (NSString *key in m_array) {
            NSString *path = [[NSBundle mainBundle] pathForResource:key ofType:@"txt"];
            if (path) {
                NSArray *keyValuesArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:nil];
                NSArray *objectArray = [AppDataDictionary mj_objectArrayWithKeyValuesArray:keyValuesArray];
                if (objectArray) {
                    [_dataMapDic setObject:objectArray forKey:key];
                }
            }
        }
    }
    return _dataMapDic;
}

NSString *serviceDataMapKeyForCity(NSString *open_city_id) {
    return [NSString stringWithFormat:@"key_service_for_city_%@", open_city_id];
}

NSString *serviceDataMapKeyForTruck(NSString *transport_truck_id) {
    return [NSString stringWithFormat:@"key_service_for_truck_%@", transport_truck_id];
}

@end
