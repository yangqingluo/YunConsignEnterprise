//
//  UserPublic.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/7.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "UserPublic.h"
#import "JPUSHService.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

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
        
        [self bindJPushTag];
    }
}

- (void)clear{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kUserData];
    
    [JPUSHService cleanTags:nil seq:0];
    
    _singleManger = nil;
}

- (void)bindJPushTag {
    if (_userData) {
        [JPUSHService setTags:[NSSet setWithObject:_userData.user_id] completion:nil seq:0];
    }
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
            [JPUSHService validTag:_userData.user_id completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq, BOOL isBind){
                if (!isBind) {
                    [[UserPublic getInstance] bindJPushTag];
                }
            } seq:0];
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
        NSArray *m_array = @[@"daily_name", @"show_column", @"show_column_cod_check", @"show_column_FreightCheck1", @"show_column_FreightCheck2", @"query_column_waybill", @"waybill_type"];
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

#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4 {
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0 || [ipAddress hasPrefix:@"192.168."]) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
//            NSRange resultRange = [firstMatch rangeAtIndex:0];
//            NSString *result=[ipAddress substringWithRange:resultRange];
//            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}
+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

@end
