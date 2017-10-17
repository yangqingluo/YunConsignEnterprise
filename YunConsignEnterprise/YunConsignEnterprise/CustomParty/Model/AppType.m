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

@implementation AppCityInfo



@end

@implementation AppSendReceiveInfo



@end

@implementation AppHistoryGoodsInfo



@end

@implementation AppGoodsInfo



@end

@implementation AppSaveWayBillInfo

- (void) dealloc {
    for (NSString *keyPath in [self defaultKVOArray]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        for (NSString *keyPath in [self defaultKVOArray]) {
            [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        }
    }
    return self;
}

- (void)appendSenderInfo:(AppSendReceiveInfo *)info {
    self.shipper_name = [info.customer.freight_cust_name copy];
    self.shipper_phone = [info.customer.phone copy];
}

- (void)appendReceiverInfo:(AppSendReceiveInfo *)info {
    self.consignee_name = [info.customer.freight_cust_name copy];
    self.consignee_phone = [info.customer.phone copy];
    self.end_station_service_id = info.service.service_id;
}

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

- (void)calculateTotalAmount {
    long long amount = 0;
    for (NSString *keyPath in [self defaultKVOArray]) {
        NSString *value = [self valueForKey:keyPath];
        amount += [value longLongValue];
    }
    
    self.total_amount = [NSString stringWithFormat:@"%lld", amount];
}

#pragma mark - getter
- (NSArray *)defaultKVOArray {
    return @[@"freight", @"insurance_fee", @"take_goods_fee", @"deliver_goods_fee", @"rebate_fee", @"forklift_fee", @"pay_for_sb_fee"];
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSArray *m_array = [self defaultKVOArray];
    if([m_array containsObject:keyPath]){
        [self calculateTotalAmount];
    }
}

@end

@implementation AppSaveBackWayBillInfo



@end

@implementation AppWayBillInfo

- (NSString *)statusStringForState {
    return self.waybill_state_text.length ? self.waybill_state_text : @"未知状态";
}
- (UIColor *)statusColorForState {
    UIColor *m_color = [UIColor clearColor];
    NSArray *m_array = @[RGBA(0xec, 0xda, 0x60, 1), appLightGreenColor, appLightBlueColor, appLightRedColor, appDarkOrangeColor, [UIColor lightGrayColor]];
    NSInteger index = [self.waybill_state integerValue] - 1;
    if (index >= 0 && index < m_array.count) {
        m_color = m_array[index];
    }
    
    return m_color;
}

@end


@implementation AppTransportTrunkInfo



@end
