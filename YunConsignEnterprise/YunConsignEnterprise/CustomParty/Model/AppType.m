//
//  AppType.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/5.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppType.h"

@implementation AppType

/*!
 @brief 服务器返回的数据布尔值判断
 */
BOOL isTrue(NSString *string) {
    if ([string isEqualToString:@"1"]) {
        return YES;
    }
    
    return NO;
}

- (instancetype)copyWithZone:(NSZone *)zone{
    return [[self class] mj_objectWithKeyValues:[self mj_keyValues]];
}

@end

@implementation AppDataDictionary



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

@implementation APPEndStationInfo



@end


@implementation AppSendReceiveInfo



@end

@implementation AppHistoryGoodsInfo



@end

@implementation AppGoodsInfo



@end

@implementation AppWaybillItemInfo



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
            BOOL yn = isTrue(value);
            [edit_dic setValue:yn ? @"1" : @"2" forKey:key];
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


@implementation AppWayBillDetailInfo

- (instancetype)init{
    self = [super init];
    if (self) {
        [[self class] mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"waybill_items" : [AppWaybillItemInfo class],
                     };
        }];
    }
    return self;
}

@end

@implementation AppCanReceiveWayBillInfo

- (NSString *)payStyleStringForState {
    NSMutableString *m_string = [NSMutableString new];
    if (isTrue(self.is_cash_on_delivery)) {
        [m_string appendString:@"[现金代收]"];
    }
    if (isTrue(self.is_deduction_freight)) {
        [m_string appendString:@"[运费代扣]"];
    }
    
    return m_string;
}

@end

@implementation AppNeedReceiptWayBillInfo

- (NSString *)showReceiptSignTypeString {
    NSString *m_String = @"未知回单类型";
    NSInteger index = [self.receipt_sign_type integerValue];
    if (index >= 0 && index < [UserPublic getInstance].receptSignTypeArray.count) {
        m_String = [UserPublic getInstance].receptSignTypeArray[index];
    }
    
    return m_String;
}

@end

@implementation AppTruckInfo


@end

@implementation AppTransportTruckInfo


@end

@implementation AppTransportTruckDetailInfo

- (instancetype)init{
    self = [super init];
    if (self) {
        [[self class] mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"end_station" : [APPEndStationInfo class],
                     };
        }];
    }
    return self;
}

@end

@implementation AppSaveTransportTruckInfo

- (NSMutableArray *)end_station {
    if (!_end_station) {
        _end_station = [NSMutableArray new];
    }
    return _end_station;
}

- (NSString *)saveStringForEndStationServices {
    NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:self.end_station.count];
    for (AppServiceInfo *service in self.end_station) {
        [m_array addObject:service.service_id];
        
    }
    return [m_array componentsJoinedByString:@","];
}

@end

@implementation AppQueryTransportTruckInfo


@end

@implementation AppCanLoadTransportTruckInfo


@end

@implementation AppCanArrivalTransportTruckInfo



@end


@implementation AppGoodsQuantityInfo



@end

@implementation AppRouteGoodsQuantityInfo



@end


@implementation AppServiceGoodsQuantityInfo



@end


@implementation AppServiceGoodsDetailInfo



@end

@implementation AppWaybillChangeDetailItemInfo

- (NSArray *)showStringListForChangeDetail {
    NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:3];
    [m_array addObject:self.field_name];
    if ([self.field hasPrefix:@"is_"] && ![self.field isEqualToString:@"is_load"]) {
        [m_array addObject:isTrue(self.prev_value) ? @"是" : @"否"];
        [m_array addObject:isTrue(self.cur_value) ? @"是" : @"否"];
    }
    else {
        [m_array addObject:self.prev_value];
        [m_array addObject:self.cur_value];
    }
    return [NSArray arrayWithArray:m_array];
}

@end

@implementation AppWaybillChangeInfo

- (instancetype)init{
    self = [super init];
    if (self) {
        [[self class] mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"detail_list" : [AppWaybillChangeDetailItemInfo class],
                     };
        }];
    }
    return self;
}

@end

@implementation AppWaybillLogInfo



@end

@implementation AppTransportTruckLoadInfo

- (NSArray *)showStringListForDetail {
    NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:3];
    [m_array addObject:self.load_service_name];
    [m_array addObject:self.load_quantity];
    [m_array addObject:self.load_count];
    return [NSArray arrayWithArray:m_array];
}

@end












@implementation AppQueryConditionInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDate *date_now = [NSDate date];
        self.start_time = [date_now dateByAddingTimeInterval:defaultAddingTimeInterval];
        self.end_time = date_now;
    }
    return self;
}

- (NSString *)showStartTimeString {
    return stringFromDate(self.start_time, @"yyyy-MM-dd");
}
- (NSString *)showEndTimeString {
    return stringFromDate(self.end_time, @"yyyy-MM-dd");
}
- (NSString *)showStartStationString {
    return self.start_station_city ? self.start_station_city.open_city_name : @"全部";
}
- (NSString *)showEndStationString {
    return self.end_station_city ? self.end_station_city.open_city_name : @"全部";
}

@end
