//
//  AppType.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/5.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PID_DAILY_OPERATION       @"1002321896911666177"
#define PID_FINANCIAL_MANAGE      @"1002321897106275329"
#define PID_SYSTEM_SET            @"1002321897253223425"

typedef NS_ENUM(NSInteger, USER_ROLE) {
    USER_ROLE_DEFAULT = 0,
    USER_ROLE_1 = 1,//网点操作员
    USER_ROLE_2 = 2,//调度员
    USER_ROLE_3 = 3,//财务
    USER_ROLE_4 = 4,//代收款收款员
    USER_ROLE_5 = 5,//代收款放款员
    USER_ROLE_6 = 6,//系统设置员
    USER_ROLE_7 = 7,//开单员
};

//回单签收方式
typedef enum : NSUInteger {
    RECEIPT_SIGN_TYPE_1 = 1,//签字
    RECEIPT_SIGN_TYPE_2 = 2,//盖章
    RECEIPT_SIGN_TYPE_3 = 3,//签字+盖章
    RECEIPT_SIGN_TYPE_4 = 4//无回单
} RECEIPT_SIGN_TYPE;

//回单状态
typedef enum : NSUInteger {
    RECEIPT_STATE_TYPE_1 = 1,//未到站
    RECEIPT_STATE_TYPE_2 = 2,//未付款
    RECEIPT_STATE_TYPE_3 = 3,//已付款
} RECEIPT_STATE_TYPE;

//代收款类型
typedef enum : NSUInteger {
    CASH_ON_DELIVERY_TYPE_1 = 1,//现金代收
    CASH_ON_DELIVERY_TYPE_2 = 2,//一般代收
    CASH_ON_DELIVERY_TYPE_3 = 3//没有代收款
} CASH_ON_DELIVERY_TYPE;

@interface AppType : NSObject

/*!
 @brief 服务器返回的数据布尔值判断
 */
BOOL isTrue(NSString *string);

@end

//数据字典
@interface AppDataDictionary : AppType

@property (strong, nonatomic) NSString *dict_id;//字典编号
@property (strong, nonatomic) NSString *item_id;//项目编号
@property (strong, nonatomic) NSString *item_name;//项目名称
@property (strong, nonatomic) NSString *item_val;//项目值
@property (strong, nonatomic) NSString *item_note;//项目备注
@property (assign, nonatomic) int item_sort;//排序

@end

@interface Global : AppType

@property (assign, nonatomic) int flag;
@property (strong, nonatomic) NSString *message;

@end

@interface ResponseItem : Global

@property (assign, nonatomic) int length;
@property (assign, nonatomic) int total;
@property (strong, nonatomic) NSArray *items;

@end

@interface AppResponse : AppType

@property (strong, nonatomic) Global *global;
@property (strong, nonatomic) NSArray<ResponseItem *> *responses;

@end

@interface AppAccessInfo : AppType

@property (strong, nonatomic) NSString *menu_id;//菜单编号
@property (strong, nonatomic) NSString *menu_name;//菜单名称
@property (strong, nonatomic) NSString *menu_code;//菜单代码
@property (strong, nonatomic) NSString *menu_icon;//菜单图标地址
@property (strong, nonatomic) NSString *parent_id;//父级编号，0为最初级
@property (assign, nonatomic) int is_display;//是否显示
@property (assign, nonatomic) int is_leaf;//是否枝叶
@property (assign, nonatomic) int sort;//排序

@end

@interface AppUserInfo : AppType

@property (strong, nonatomic) NSArray *access_list;
@property (strong, nonatomic) NSString *gender;//性别，数据字典，GENDER，1男、2女、3未知
@property (strong, nonatomic) NSString *gender_text;
@property (strong, nonatomic) NSString *head_img;
@property (strong, nonatomic) NSString *join_id;//加盟商编号
@property (strong, nonatomic) NSString *join_name;
@property (strong, nonatomic) NSString *login_token;
@property (strong, nonatomic) NSString *login_type;//登录设备类型，LOGIN_TYPE，1安卓手机、2安卓平板、3苹果手机、4苹果平板、5电脑
@property (strong, nonatomic) NSString *login_type_text;
@property (strong, nonatomic) NSString *open_city_id;// 	所属城市
@property (strong, nonatomic) NSString *open_city_name;
@property (strong, nonatomic) NSString *role_id;//岗位编号，多个用逗号隔开
@property (strong, nonatomic) NSString *role_name;
@property (strong, nonatomic) NSString *service_id;//所属门店
@property (strong, nonatomic) NSString *service_name;
@property (strong, nonatomic) NSString *telphone;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *user_state;//用户状态，USER_STATE，1正常、2禁用、3删除
@property (strong, nonatomic) NSString *user_state_text;

@end

@interface AppCustomerInfo : AppType

@property (strong, nonatomic) NSString *freight_cust_id;//客户编号
@property (strong, nonatomic) NSString *freight_cust_name;//客户姓名
@property (strong, nonatomic) NSString *phone;//电话
@property (strong, nonatomic) NSString *last_deliver_time;//最后发货时间
@property (strong, nonatomic) NSString *last_deliver_goods;//最后发货内容
@property (strong, nonatomic) NSString *belong_city_name;//所属城市
@property (strong, nonatomic) NSString *note;//备注

@end

@interface AppServiceInfo : AppType

@property (strong, nonatomic) NSString *open_city_id;//所在城市编号
@property (strong, nonatomic) NSString *open_city_name;//所在城市名称
@property (strong, nonatomic) NSString *service_id;//所属门店编号
@property (strong, nonatomic) NSString *service_name;//所属门店名称
@property (strong, nonatomic) NSString *service_code;//开单代码

- (NSString *)showCityAndServiceName;

@end

@interface AppCityInfo : AppType

@property (strong, nonatomic) NSString *open_city_id;//所在城市编号
@property (strong, nonatomic) NSString *open_city_name;//所在城市名称

@end

@interface APPEndStationInfo : AppType

@property (strong, nonatomic) NSString *arrival_time;
@property (strong, nonatomic) NSString *end_station_city_id;
@property (strong, nonatomic) NSString *end_station_city_name;
@property (strong, nonatomic) NSString *end_station_service_id;
@property (strong, nonatomic) NSString *end_station_service_name;
@property (strong, nonatomic) NSString *start_station_city_id;
@property (strong, nonatomic) NSString *start_station_city_name;
@property (strong, nonatomic) NSString *transport_truck_id;
@property (strong, nonatomic) NSString *transport_truck_route_id;

@end

@interface AppSendReceiveInfo : AppType

@property (strong, nonatomic) AppCustomerInfo *customer;
@property (strong, nonatomic) AppServiceInfo *service;

@end

@interface AppHistoryGoodsInfo : AppType

@property (strong, nonatomic) NSString *waybill_id;//运单内部编号
@property (strong, nonatomic) NSString *waybill_number;//运单号
@property (strong, nonatomic) NSString *goods_number;//货物编号
@property (strong, nonatomic) NSString *waybill_state;//运单状态
@property (strong, nonatomic) NSString *service_info;//开单门店信息
@property (strong, nonatomic) NSString *goods_info;//货物信息
@property (strong, nonatomic) NSString *total_amount;//总费用
@property (strong, nonatomic) NSString *consignment_time;//托运时间

@end

@interface AppGoodsInfo : AppType

@property (strong, nonatomic) NSString *goods_name;//货名
@property (strong, nonatomic) NSString *packge;//包装
@property (assign, nonatomic) int number;//数量，件
@property (assign, nonatomic) double weight;//重量，吨
@property (assign, nonatomic) double volume;//体积，方
@property (assign, nonatomic) long long freight;//运费

@end

@interface AppWaybillItemInfo : AppType

@property (strong, nonatomic) NSString *waybill_id;
@property (strong, nonatomic) NSString *waybill_item_id;
@property (strong, nonatomic) NSString *waybill_item_name;
@property (strong, nonatomic) NSString *freight;//运费
@property (strong, nonatomic) NSString *number;//数量，件
@property (strong, nonatomic) NSString *packge;//包装
@property (strong, nonatomic) NSString *volume;//体积，方
@property (strong, nonatomic) NSString *weight;//重量，吨

@end

//下单数据
@interface AppSaveWayBillInfo : AppType

@property (strong, nonatomic) NSString *end_station_service_id;//到站门店编号
@property (strong, nonatomic) NSString *shipper_name;//发货人名称
@property (strong, nonatomic) NSString *shipper_phone;//发货人电话
@property (strong, nonatomic) NSString *consignee_name;//收货人名称
@property (strong, nonatomic) NSString *consignee_phone;//收货人电话
@property (strong, nonatomic) NSString *insurance_amount;//保价金额
@property (strong, nonatomic) NSString *insurance_fee;//保价费
@property (strong, nonatomic) NSString *take_goods_fee;//接货费
@property (strong, nonatomic) NSString *deliver_goods_fee;//送货费
@property (strong, nonatomic) NSString *rebate_fee;//回扣费
@property (strong, nonatomic) NSString *forklift_fee;//叉车费
@property (strong, nonatomic) NSString *return_fee;//原货返回费
@property (strong, nonatomic) NSString *pay_for_sb_fee;//垫付费
@property (strong, nonatomic) NSString *cash_on_delivery_amount;//代收款金额
@property (assign, nonatomic) NSString *is_deduction_freight;//是否运费代扣
@property (assign, nonatomic) NSString *is_urgent;//是否急货
@property (strong, nonatomic) NSString *total_amount;//总费用
@property (assign, nonatomic) NSString *is_pay_now;//是否现付
@property (strong, nonatomic) NSString *pay_now_amount;//现付金额
@property (assign, nonatomic) NSString *is_pay_on_delivery;//是否提付
@property (strong, nonatomic) NSString *pay_on_delivery_amount;//提付金额
@property (assign, nonatomic) NSString *is_pay_on_receipt;//是否回单付
@property (strong, nonatomic) NSString *pay_on_receipt_amount;//回单付金额
@property (strong, nonatomic) NSString *note;//运单内部
@property (strong, nonatomic) NSString *inner_note;//运单内部备注
@property (strong, nonatomic) NSString *return_waybill_number;//原货返货运单号
@property (strong, nonatomic) NSString *consignment_time;//托运日期
@property (strong, nonatomic) NSString *waybill_items;//运单货物明细（JSON格式）
@property (strong, nonatomic) NSString *receipt_sign_type;//回单签收方式
@property (strong, nonatomic) NSString *cash_on_delivery_type;//代收款类型
@property (strong, nonatomic) NSString *freight;//运费
@property (strong, nonatomic) NSString *goods_packge;//包装
@property (strong, nonatomic) NSString *goods_total_count;//物品总件数
@property (strong, nonatomic) NSString *goods_total_weight;//物品总重量
@property (strong, nonatomic) NSString *goods_total_volume;//物品总体积
@property (strong, nonatomic) NSString *change_cause;//修改原因

- (void)appendSenderInfo:(AppSendReceiveInfo *)info;
- (void)appendReceiverInfo:(AppSendReceiveInfo *)info;
- (NSDictionary *)app_keyValues;

@end

//下单返回
@interface AppSaveBackWayBillInfo : AppType

@property (strong, nonatomic) NSString *waybill_id;//运单内部编号
@property (strong, nonatomic) NSString *waybill_number;//运单号
@property (strong, nonatomic) NSString *goods_number;//货号
@property (strong, nonatomic) NSString *print_check_code;//运单验证码

@end

@interface AppWayBillInfo : AppType

@property (strong, nonatomic) NSString *waybill_id;//运单内部编号
@property (strong, nonatomic) NSString *waybill_number;//运单号
@property (strong, nonatomic) NSString *waybill_state;//运单状态
@property (strong, nonatomic) NSString *waybill_state_text;//运单状态文本
@property (strong, nonatomic) NSString *route;//线路信息
@property (strong, nonatomic) NSString *cust;//客户信息
@property (strong, nonatomic) NSString *total_amount;//总费用
//代收款
@property (strong, nonatomic) NSString *is_cash_on_delivery;
@property (strong, nonatomic) NSString *cash_on_delivery_amount;
@property (strong, nonatomic) NSString *cash_on_delivery_type;
@property (strong, nonatomic) NSString *cash_on_delivery_type_text;
//现付
@property (strong, nonatomic) NSString *is_pay_now;
@property (strong, nonatomic) NSString *pay_now_amount;
//提付
@property (strong, nonatomic) NSString *is_pay_on_delivery;
@property (strong, nonatomic) NSString *pay_on_delivery_amount;
//回单付
@property (strong, nonatomic) NSString *is_pay_on_receipt;
@property (strong, nonatomic) NSString *pay_on_receipt_amount;

@property (strong, nonatomic) NSString *is_deduction_freight;//是否运费代扣
@property (strong, nonatomic) NSString *is_urgent;//是否急货
@property (strong, nonatomic) NSString *is_receipt;//是否有回单
@property (strong, nonatomic) NSString *start_station_city_id;//发站城市编号
@property (strong, nonatomic) NSString *start_station_city_name;//发站城市名称
@property (strong, nonatomic) NSString *start_station_service_id;//发站网点编号
@property (strong, nonatomic) NSString *start_station_service_name ;//发站网点名称
@property (strong, nonatomic) NSString *end_station_city_id;//到站城市编号
@property (strong, nonatomic) NSString *end_station_city_name;//到站城市名称
@property (strong, nonatomic) NSString *end_station_service_id;//到站网点编号
@property (strong, nonatomic) NSString *end_station_service_name;//到站网点名称
@property (strong, nonatomic) NSString *shipper_name;//发货人名称
@property (strong, nonatomic) NSString *shipper_phone;//发货人电话
@property (strong, nonatomic) NSString *consignee_name;//收货人名称
@property (strong, nonatomic) NSString *consignee_phone;//收货人电话
@property (strong, nonatomic) NSString *goods;//货物信息
@property (strong, nonatomic) NSString *goods_name;//品名
@property (strong, nonatomic) NSString *goods_packge;//包装
@property (strong, nonatomic) NSString *goods_total_count;//物品总件数
@property (strong, nonatomic) NSString *goods_total_weight;//物品总重量
@property (strong, nonatomic) NSString *goods_total_volume;//物品总体积
@property (strong, nonatomic) NSString *goods_number;//货物编号

- (NSString *)statusStringForState;
- (UIColor *)statusColorForState;
- (NSString *)payStyleStringForState;

@end

@interface AppWayBillDetailInfo : AppWayBillInfo

@property (strong, nonatomic) NSString *receipt_state;//回单状态 RECEIPT_STATE 未到站、未付款、已付款
@property (strong, nonatomic) NSString *cash_on_delivery_state;//代收款状态 CASH_ON_DELIVERY_STATE 未收款、已收款、已申请、已审核、已放款
@property (strong, nonatomic) NSString *consignment_time;//托运时间
@property (strong, nonatomic) NSString *location_type;//当前位置类型 LOCATION_TYPE 固定门店、专线车辆、已送达客户
@property (strong, nonatomic) NSString *location_id;//当前位置编号
@property (strong, nonatomic) NSString *location_time;//位置变更时间
@property (strong, nonatomic) NSString *freight;//运费
@property (strong, nonatomic) NSString *is_insured;//是否保价 YES_NO
@property (strong, nonatomic) NSString *insurance_amount;//保价金额
@property (strong, nonatomic) NSString *insurance_fee;//保价费
@property (strong, nonatomic) NSString *is_take_goods;//是否上门接货 YES_NO
@property (strong, nonatomic) NSString *take_goods_fee;//接货费
@property (strong, nonatomic) NSString *is_deliver_goods;//是否送货上门 YES_NO
@property (strong, nonatomic) NSString *deliver_goods_fee;//送货费
@property (strong, nonatomic) NSString *receipt_sign_type;//回单签收方式 RECEIPT_SIGN_TYPE 无回单、签字、盖章、签字+盖章
@property (strong, nonatomic) NSString *rebate_fee;//回扣费
@property (strong, nonatomic) NSString *forklift_fee;//叉车费
@property (strong, nonatomic) NSString *return_fee;//原货返回费
@property (strong, nonatomic) NSString *pay_for_sb_fee;//垫付款
@property (strong, nonatomic) NSString *operator_id;//开单人编号
@property (strong, nonatomic) NSString *operator_name;//开单人名称
@property (strong, nonatomic) NSString *operate_time;//开单时间
@property (strong, nonatomic) NSString *join_id;//加盟商编号
@property (strong, nonatomic) NSString *join_short_name;//加盟商简称
@property (strong, nonatomic) NSString *service_id;//门店编号
@property (strong, nonatomic) NSString *service_name;//门店名称
@property (strong, nonatomic) NSString *note;//备注
@property (strong, nonatomic) NSString *inner_note;//内部备注
@property (strong, nonatomic) NSString *is_return_waybill;//是否原货返货 YES_NO
@property (strong, nonatomic) NSString *return_waybill_number ;//原货返回运单号
@property (strong, nonatomic) NSString *waybill_change_count;//运单修改次数
@property (strong, nonatomic) NSArray *waybill_items;//货物信息
@end

@interface AppCanReceiveWayBillInfo : AppWayBillInfo


@end

@interface AppCanLoadWayBillInfo : AppWayBillInfo

@property (strong, nonatomic) NSString *goods_info;//货物
@property (strong, nonatomic) NSString *cust_info;//客户

@end

@interface AppCanArrivalWayBillInfo : AppWayBillInfo

@property (strong, nonatomic) NSString *goods_info;//货物
@property (strong, nonatomic) NSString *cust_info;//客户
@property (strong, nonatomic) NSString *handover_state;//交接状态，YES_NO，1是，2否
@property (strong, nonatomic) NSString *print_state;//打印状态，YES_NO，1是，2否

@end

@interface AppPaymentWaybillInfo : AppWayBillInfo

@property (strong, nonatomic) NSString *goods_total;//件吨方

@end

@interface AppNeedReceiptWayBillInfo : AppWayBillInfo

@property (strong, nonatomic) NSString *shipper;//发货人
@property (strong, nonatomic) NSString *receipt_sign_type;//回单类型 RECEIPT_SIGN_TYPE 签字、盖章、签字+盖章
@property (strong, nonatomic) NSString *receipt_state;//回单状态 RECEIPT_STATE 未到站、未付款、已付款
@property (strong, nonatomic) NSString *receipt_state_text;//回单状态

- (NSString *)showReceiptSignTypeString;

@end

//运输款对账运单信息
@interface AppCheckFreightWayBillInfo : AppWayBillInfo

@property (strong, nonatomic) NSString *goods_info;//货物

@end

//代收款综合信息
@interface AppCashOnDeliveryWayBillInfo : AppWayBillInfo

@property (strong, nonatomic) NSString *cash_on_delivery_real_amount;//实收代收款
@property (strong, nonatomic) NSString *cash_on_delivery_real_time;//收款时间
@property (strong, nonatomic) NSString *cash_on_delivery_causes_amount;//少款金额，没有收款，显示未收款
@property (strong, nonatomic) NSString *cash_on_delivery_causes_note ;//少款原因
@property (strong, nonatomic) NSString *remitter_name;//放款人，没有放款，显示未放款
@property (strong, nonatomic) NSString *remittance_time;//放款时间
@property (strong, nonatomic) NSString *cash_on_delivery_state;
@property (strong, nonatomic) NSString *cash_on_delivery_state_text;
@property (strong, nonatomic) NSString *cust_info;
@property (strong, nonatomic) NSString *is_get_cash_on_delivery;
@property (strong, nonatomic) NSString *loan_apply_state;

@end

//代收款对账运单信息
@interface AppCheckCodWayBillInfo : AppWayBillInfo

@property (strong, nonatomic) NSString *goods_info;//货物
@property (strong, nonatomic) NSString *cash_on_delivery_real_amount;//实收代收款
@property (strong, nonatomic) NSString *cash_on_delivery_real_time;//收款时间
@property (strong, nonatomic) NSString *cash_on_delivery_causes_amount;//少款金额，没有收款，显示未收款
@property (strong, nonatomic) NSString *cash_on_delivery_causes_note ;//少款原因

@end

//进行自提提交数据
@interface WaybillToCustReceiveInfo : AppType

@property (strong, nonatomic) NSString *waybill_id;//运单内部编号
@property (strong, nonatomic) NSString *consignee_name;//提货人
@property (strong, nonatomic) NSString *consignee_phone;//提货电话
@property (strong, nonatomic) NSString *cash_on_delivery_causes_type;//代收款少款类型，CASH_ON_DELIVERY_CAUSES_TYPE，1不少款、2运费代扣、3其他，默认1不少款
@property (strong, nonatomic) NSString *consignee_id_card;//提货人身份证
@property (strong, nonatomic) NSString *cash_on_delivery_real_amount;//实收代收款，0表示没有收到代收款
@property (strong, nonatomic) NSString *cash_on_delivery_causes_amount;//少款金额
@property (strong, nonatomic) NSString *cash_on_delivery_causes_note;//代收款减少原因备注
@property (strong, nonatomic) NSString *waybill_receive_note;//自提备注
@property (strong, nonatomic) NSString *less_indemnity_amount;//少款
@property (strong, nonatomic) NSString *payment_indemnity_amount;//赔款
@property (strong, nonatomic) NSString *deliver_indemnity_amount;//包送
@property (strong, nonatomic) NSString *receipt_form_voucher;//签收单留底

@end


@interface AppTruckInfo : AppType

@property (strong, nonatomic) NSString *transport_truck_id;//登记派车编号
@property (strong, nonatomic) NSString *end_station_city_id;
@property (strong, nonatomic) NSString *end_station_city_name;
@property (strong, nonatomic) NSString *start_station_city_id;
@property (strong, nonatomic) NSString *start_station_city_name;
@property (strong, nonatomic) NSString *route;//线路
@property (strong, nonatomic) NSString *truck_info;//车辆信息
@property (strong, nonatomic) NSString *load_quantity;//装车货量
@property (strong, nonatomic) NSString *cost_register;//登记运费
@property (strong, nonatomic) NSString *cost_check;//结算运费
@property (strong, nonatomic) NSString *operate_time;
@property (strong, nonatomic) NSString *operator_id;
@property (strong, nonatomic) NSString *operator_name;
@property (strong, nonatomic) NSString *truck_driver_name;//
@property (strong, nonatomic) NSString *truck_driver_phone;//
@property (strong, nonatomic) NSString *truck_number_plate;//

@end

@interface AppTransportTruckInfo : AppTruckInfo


@end

@interface AppTransportTruckDetailInfo : AppType

@property (strong, nonatomic) NSString *transport_truck_id;//登记派车编号
@property (strong, nonatomic) NSString *register_time;//登记日期
@property (strong, nonatomic) NSString *start_station_city_id;
@property (strong, nonatomic) NSString *start_station_city_name;//始发站
@property (strong, nonatomic) NSArray *end_station;//终点站
@property (strong, nonatomic) NSString *truck_number_plate;//车牌
@property (strong, nonatomic) NSString *truck_driver_name;//司机
@property (strong, nonatomic) NSString *truck_driver_phone;//电话
@property (strong, nonatomic) NSString *cost_register;//登记运费
@property (strong, nonatomic) NSString *cost_check;//结算运费
@property (strong, nonatomic) NSString *check_time;//结算时间
@property (strong, nonatomic) NSString *driver_account;//打款账号
@property (strong, nonatomic) NSString *driver_account_name;//户主
@property (strong, nonatomic) NSString *driver_account_bank;//开户行
@property (strong, nonatomic) NSString *load_quantity;//装车货量
@property (strong, nonatomic) NSString *check_id;
@property (strong, nonatomic) NSString *check_name;
@property (strong, nonatomic) NSString *end_station_city_id;
@property (strong, nonatomic) NSString *end_station_city_name;
@property (strong, nonatomic) NSString *end_station_service_id;
@property (strong, nonatomic) NSString *end_station_service_name;
@property (strong, nonatomic) NSString *join_id;
@property (strong, nonatomic) NSString *note;
@property (strong, nonatomic) NSString *operate_time;
@property (strong, nonatomic) NSString *operator_id;
@property (strong, nonatomic) NSString *operator_name;
@property (strong, nonatomic) NSString *start_car_time;
@property (strong, nonatomic) NSString *transport_truck_state;

@end

@interface AppSaveTransportTruckInfo : AppType

@property (strong, nonatomic) NSString *start_station_city_id;
@property (strong, nonatomic) NSString *start_station_city_name;//始发站
@property (strong, nonatomic) NSString *truck_number_plate;//车牌
@property (strong, nonatomic) NSString *truck_driver_name;//司机
@property (strong, nonatomic) NSString *truck_driver_phone;//电话
@property (strong, nonatomic) NSString *cost_register;//登记运费
@property (strong, nonatomic) NSString *truck_id;//常用车辆编号，如果存在，保存时，会自动获取司机银行账号信息
@property (strong, nonatomic) NSString *end_station_service_id;//终点门店，多个用逗号隔开
@property (strong, nonatomic) NSString *note;//备注
@property (strong, nonatomic) NSMutableArray *end_station;//终点站

- (NSString *)saveStringForEndStationServices;

@end

@interface AppQueryTransportTruckInfo : AppTruckInfo

@property (strong, nonatomic) NSString *register_time;//登记时间
@property (strong, nonatomic) NSString *transport_truck_state;//车辆状态
@property (strong, nonatomic) NSString *transport_truck_state_text;//车辆状态文本
@property (strong, nonatomic) NSString *check_id;
@property (strong, nonatomic) NSString *check_name;
@property (strong, nonatomic) NSString *check_time;
@property (strong, nonatomic) NSString *driver_account;
@property (strong, nonatomic) NSString *driver_account_bank;
@property (strong, nonatomic) NSString *driver_account_name;
@property (strong, nonatomic) NSString *end_station_service_id;
@property (strong, nonatomic) NSString *end_station_service_name;
@property (strong, nonatomic) NSString *join_id;
@property (strong, nonatomic) NSString *note;
@property (strong, nonatomic) NSString *start_car_time;

@end


@interface AppCanLoadTransportTruckInfo : AppQueryTransportTruckInfo


@end

@interface AppCanArrivalTransportTruckInfo : AppQueryTransportTruckInfo

@property (strong, nonatomic) NSString *arrival_time;//到车时间
@property (strong, nonatomic) NSString *nohandover_count;//未交接运单数量

@end


@interface AppGoodsQuantityInfo : AppType

@property (strong, nonatomic) NSString *quantity;//货量

@end

@interface AppRouteGoodsQuantityInfo : AppGoodsQuantityInfo

@property (strong, nonatomic) NSString *end_station_city_id;
@property (strong, nonatomic) NSString *end_station_city_name;
@property (strong, nonatomic) NSString *route;
@property (strong, nonatomic) NSString *start_station_city_id;
@property (strong, nonatomic) NSString *start_station_city_name;

@end

@interface AppServiceGoodsQuantityInfo : AppGoodsQuantityInfo

@property (strong, nonatomic) NSString *service_id;//所属门店编号
@property (strong, nonatomic) NSString *service_name;//所属门店名称

@end

@interface AppServiceGoodsDetailInfo : AppType

@property (strong, nonatomic) NSString *goods_number;//货号
@property (strong, nonatomic) NSString *goods_name;//货物
@property (strong, nonatomic) NSString *total_amount;//运费
@property (strong, nonatomic) NSString *is_load;//装车次数，0表示没有装车，一般为1，如果存在拆分多次装车，则为大于1的数字

@end

@interface AppWaybillChangeDetailItemInfo : AppType

@property (strong, nonatomic) NSString *change_field_id;
@property (strong, nonatomic) NSString *change_id;
@property (strong, nonatomic) NSString *field;
@property (strong, nonatomic) NSString *field_name;//修改字段名称
@property (strong, nonatomic) NSString *prev_value;//修改前
@property (strong, nonatomic) NSString *cur_value;//修改后

- (NSArray *)showStringListForChangeDetail;

@end

@interface AppWaybillChangeInfo : AppType

@property (strong, nonatomic) NSString *change_id;//运单修改编号
@property (strong, nonatomic) NSString *service_id;//门店id
@property (strong, nonatomic) NSString *service_name;//门店名称
@property (strong, nonatomic) NSString *operator_name;//修改人
@property (strong, nonatomic) NSString *operate_time;//修改时间
@property (strong, nonatomic) NSString *change_cause;//修改原因
@property (strong, nonatomic) NSArray *detail_list;//修改详情
@property (strong, nonatomic) NSString *open_city_name;
@property (strong, nonatomic) NSString *operator_id;
@property (strong, nonatomic) NSString *waybill_id;

@end

@interface AppWaybillLogInfo : AppType

@property (strong, nonatomic) NSString *follow_note;
@property (strong, nonatomic) NSString *follow_time;
@property (strong, nonatomic) NSString *waybill_cod_log_id;
@property (strong, nonatomic) NSString *waybill_id;
@property (strong, nonatomic) NSString *waybill_transport_log_id;

@end

//装车货量
@interface AppTransportTruckLoadInfo : AppType

@property (strong, nonatomic) NSString *load_service_id;//门店编号
@property (strong, nonatomic) NSString *load_service_name;//门店名称
@property (strong, nonatomic) NSString *load_quantity;//装车货量
@property (strong, nonatomic) NSString *load_count;//票数/件数
@property (strong, nonatomic) NSString *start_time;
@property (strong, nonatomic) NSString *end_time;
@property (strong, nonatomic) NSString *transport_load_id;
@property (strong, nonatomic) NSString *transport_truck_id;

- (NSArray *)showStringListForDetail;

@end

//用户财务身份检查
@interface AppCheckUserFinanceInfo : AppType

@property (strong, nonatomic) NSString *is_finance;

@end



//查询条件
@interface AppQueryConditionInfo : AppType

@property (strong, nonatomic) NSDate *start_time;//开始时间
@property (strong, nonatomic) NSDate *end_time;//结束时间

/*订单相关*/
@property (strong, nonatomic) AppDataDictionary *query_column;//查询字段
@property (strong, nonatomic) NSString *query_val;//查询内容
@property (strong, nonatomic) AppDataDictionary *show_column;//显示字段
@property (strong, nonatomic) AppServiceInfo *start_service;
@property (strong, nonatomic) AppServiceInfo *end_service;
@property (strong, nonatomic) NSString *is_cancel;//是否作废
@property (strong, nonatomic) AppServiceInfo *power_service;//收款网点
@property (strong, nonatomic) AppServiceInfo *load_service;//装车网点

/*车辆相关*/
@property (strong, nonatomic) AppCityInfo *start_station_city;
@property (strong, nonatomic) AppCityInfo *end_station_city;
@property (strong, nonatomic) NSString *truck_number_plate;//车辆牌照
@property (strong, nonatomic) AppDataDictionary *transport_truck_state;//车辆状态
@property (strong, nonatomic) NSString *transport_truck_id;//车辆id

/*财务管理相关*/
@property (strong, nonatomic) AppDataDictionary *search_time_type;//时间类型
@property (strong, nonatomic) AppDataDictionary *cash_on_delivery_type;//代收方式
@property (strong, nonatomic) AppDataDictionary *cod_payment_state;//收款状态
@property (strong, nonatomic) AppDataDictionary *cod_loan_state;//放款状态
@property (strong, nonatomic) AppDataDictionary *waybill_receive_state;//收货状态

- (NSString *)showStartTimeString;
- (NSString *)showEndTimeString;
- (NSString *)showStartStationString;
- (NSString *)showEndStationString;

@end
