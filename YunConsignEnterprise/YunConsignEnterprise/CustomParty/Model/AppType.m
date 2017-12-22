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

- (instancetype)copyWithZone:(NSZone *)zone {
    //to fix 此种方式copy后，NSDate类型如果为nil，copy后会new为当前时间
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


@implementation AppUserDetailInfo



@end


@implementation AppPasswordInfo



@end


@implementation AppCustomerInfo



@end

@implementation AppCustomerDetailInfo



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

@implementation AppServiceDetailInfo

@end


@implementation AppGoodInfo



@end

@implementation AppGoodDetailInfo



@end

@implementation AppPackageInfo



@end

@implementation AppPackageDetailInfo



@end

@implementation AppCityInfo



@end

@implementation AppCityDetailInfo



@end

@implementation AppVoucherInfo



@end

@implementation AppLocationInfo



@end



@implementation AppEndStationInfo



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
    self.shipper_id_card = [info.customer.id_card copy];
}

- (void)appendReceiverInfo:(AppSendReceiveInfo *)info {
    self.consignee_name = [info.customer.freight_cust_name copy];
    self.consignee_phone = [info.customer.phone copy];
    self.end_station_service_id = info.service.service_id;
}

- (NSDictionary *)app_keyValues {
    NSMutableDictionary *m_dic = [self mj_keyValues];
    NSMutableDictionary *edit_dic = [NSMutableDictionary new];
    
    NSSet *set_bool = [NSSet setWithObjects:@"is_deduction_freight", @"is_deliver_goods", @"is_pay_now", @"is_pay_on_delivery", @"is_pay_on_receipt", nil];
    for (NSString *key in m_dic.allKeys) {
        NSString *value = m_dic[key];
        if ([set_bool containsObject:key]) {
            BOOL yn = isTrue(value);
            [edit_dic setValue:boolString(yn) forKey:key];
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

    long long pay_now_amount = [self.pay_now_amount longLongValue];
    long long pay_on_receipt_amount = [self.pay_on_receipt_amount longLongValue];
    long long pay_on_delivery_amount = amount - pay_now_amount - pay_on_receipt_amount;
    if (isTrue(self.is_pay_on_delivery)) {
        if (pay_on_delivery_amount > 0) {
            self.pay_on_delivery_amount = [NSString stringWithFormat:@"%lld", pay_on_delivery_amount];
        }
    }
    self.total_amount = [NSString stringWithFormat:@"%lld", amount];
}

- (NSArray *)defaultKVOArray {
    return @[@"freight", @"insurance_fee", @"take_goods_fee", @"deliver_goods_fee", @"rebate_fee", @"forklift_fee", @"transfer_fee", @"pay_for_sb_fee"];
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSArray *m_array = [self defaultKVOArray];
    if([m_array containsObject:keyPath]){
        [self calculateTotalAmount];
    }
}

@end

@implementation AppSaveReturnWayBillInfo

//比父类多了原返费
- (NSArray *)defaultKVOArray {
    return @[@"freight", @"insurance_fee", @"take_goods_fee", @"deliver_goods_fee", @"rebate_fee", @"forklift_fee", @"transfer_fee", @"pay_for_sb_fee", @"return_fee"];
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

- (NSString *)payStyleStringForState {
    NSMutableString *m_string = [NSMutableString new];
    if (self.cash_on_delivery_type_text) {
        [m_string appendString:self.cash_on_delivery_type_text];
    }
    
    return m_string;
}

- (NSString *)payStyleStringForStateOld {
    NSMutableString *m_string = [NSMutableString new];
    if (isTrue(self.is_cash_on_delivery)) {
        [m_string appendString:@"（现金代收）"];
    }
    if (isTrue(self.is_deduction_freight)) {
        [m_string appendString:@"（运费代扣）"];
    }
    
    return m_string;
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


@end

@implementation AppCanLoadWayBillInfo



@end

@implementation AppCanArrivalWayBillInfo



@end


@implementation AppPaymentWaybillInfo



@end


@implementation AppNeedReceiptWayBillInfo


@end



@implementation AppCashOnDeliveryWayBillInfo



@end

@implementation AppLoanApplyCheckWaybillInfo



@end

@implementation WaybillToCustReceiveInfo



@end


@implementation AppTruckInfo


@end

@implementation AppTruckDetailInfo



@end


@implementation AppTransportTruckInfo


@end

@implementation AppTransportTruckDetailInfo

- (instancetype)init{
    self = [super init];
    if (self) {
        [[self class] mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"end_station" : [AppEndStationInfo class],
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
    [m_array addObject:self.prev_value];
    [m_array addObject:self.cur_value];
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

@implementation AppCheckUserFinanceInfo



@end

@implementation AppCodLoanApplyInfo



@end

@implementation AppCodLoanApplyWaitLoanInfo



@end

@implementation AppDailyReimbursementApplyInfo

- (BOOL)judgeWaybillInfoValidity {
    return (self.waybill_info.length && ![self.waybill_info isEqualToString:@"/"]);
}

- (NSString *)showWaybillInfoString {
    return self.judgeWaybillInfoValidity ? self.waybill_info : @"无";
}

@end

@implementation AppDailyReimbursementCheckInfo



@end
















@implementation AppQueryConditionInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDate *date_now = [NSDate date];
        self.start_time = [date_now dateByAddingTimeInterval:0];
        self.end_time = date_now;
        [[self class] mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"show_column" : [AppDataDictionary class],
                     @"user_role" : [AppDataDictionary class],
                     @"power_service_array" : [AppServiceInfo class],
                     };
        }];
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

- (NSString *)showShowColumnString {
    NSMutableString *m_string = [NSMutableString new];
    for (AppDataDictionary *item in self.show_column) {
        [m_string appendString:item.item_val];
    }
    return m_string;
}

- (NSString *)showArrayValStringWithKey:(NSString *)key {
    NSMutableArray *m_array = [NSMutableArray new];
    for (AppDataDictionary *item in [self valueForKey:key]) {
        [m_array addObject:item.item_val];
    }
    return [m_array componentsJoinedByString:@","];
}

- (NSString *)showArrayNameStringWithKey:(NSString *)key {
    NSMutableArray *m_array = [NSMutableArray new];
    for (NSObject *item in [self valueForKey:key]) {
        if ([item isKindOfClass:[AppDataDictionary class]]) {
            [m_array addObject:[item valueForKey:@"item_name"]];
        }
        else if ([item isKindOfClass:[AppServiceInfo class]]) {
            [m_array addObject:[item valueForKey:@"service_name"]];
        }
    }
    return [m_array componentsJoinedByString:@","];
}

- (NSArray *)IDArrayForPowerServiceArray {
    NSMutableArray *m_power_array = [NSMutableArray arrayWithCapacity:self.power_service_array.count];
    for (AppServiceInfo *item in self.power_service_array) {
        [m_power_array addObject:item.service_id];
    }
    return [NSArray arrayWithArray:m_power_array];
}

@end
