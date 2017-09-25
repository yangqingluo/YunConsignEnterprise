//
//  AppType.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/5.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppType.h"

@implementation AppType

- (instancetype)copyWithZone:(NSZone *)zone{
    return [[self class] mj_objectWithKeyValues:[self mj_keyValues]];
}

@end

@implementation Global



@end


@implementation ResponseItem



@end

@implementation AppResponse

- (instancetype)init{
    self = [super init];
    if (self) {
        [[self class] mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"responses" : [ResponseItem class],
                     };
        }];
    }
    
    
    return self;
}

@end

@implementation AppAccessInfo



@end

@implementation AppUserInfo

- (instancetype)init{
    self = [super init];
    if (self) {
        [[self class] mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"access_list" : [AppAccessInfo class],
                     };
        }];
    }
    
    
    return self;
}

@end


@implementation AppCustomerInfo



@end


@implementation AppServiceInfo

- (NSString *)showCityAndServiceName {
    NSString *connect_string = @"-";
    NSString *m_string = [NSString stringWithFormat:@"%@%@%@", self.open_city_name.length ? self.open_city_name : @"", connect_string, self.service_name.length ? self.service_name : @""];
    
    if ([m_string hasPrefix:connect_string]) {
        m_string = [m_string substringFromIndex:connect_string.length];
    }
    else if ([m_string hasSuffix:connect_string]){
        m_string = [m_string substringToIndex:m_string.length - connect_string.length];
    }
    return m_string;
}

@end

@implementation AppSendReceiveInfo



@end

@implementation AppHistoryGoodsInfo



@end

@implementation AppGoodsInfo



@end

@implementation AppWayBillInfo

- (NSDictionary *)app_keyValues {
    NSMutableDictionary *m_dic = [self mj_keyValues];
    NSMutableDictionary *edit_dic = [NSMutableDictionary new];
    
    NSSet *set_bool = [NSSet setWithObjects:@"is_deduction_freight", @"is_urgent", @"is_pay_now", @"is_pay_on_delivery", @"is_pay_on_receipt", nil];
    for (NSString *key in m_dic.allKeys) {
        NSString *value = m_dic[key];
        if ([set_bool containsObject:key]) {
            BOOL yn = [value boolValue];
            [edit_dic setValue:yn ? @"1" : @"0" forKey:key];
        }
        else {
            [edit_dic setValue:value forKey:key];
        }
    }
    return edit_dic;
}

@end
