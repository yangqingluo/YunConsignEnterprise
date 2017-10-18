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

//回单签收方式
typedef enum : NSUInteger {
    RECEIPT_SIGN_TYPE_1 = 1,//签字
    RECEIPT_SIGN_TYPE_2 = 2,//盖章
    RECEIPT_SIGN_TYPE_3 = 3,//签字+盖章
    RECEIPT_SIGN_TYPE_4 = 4//无回单
} RECEIPT_SIGN_TYPE;

//代收款类型
typedef enum : NSUInteger {
    CASH_ON_DELIVERY_TYPE_1 = 1,//现金代收
    CASH_ON_DELIVERY_TYPE_2 = 2,//一般代收
    CASH_ON_DELIVERY_TYPE_3 = 3//没有代收款
} CASH_ON_DELIVERY_TYPE;

@interface AppType : NSObject

@end

@interface Global : NSObject

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

@property (strong, nonatomic) NSString *freight_cust_name;//客户姓名
@property (strong, nonatomic) NSString *phone;//电话
@property (strong, nonatomic) NSString *last_deliver_time;//最后发货时间
@property (strong, nonatomic) NSString *last_deliver_goods;//最后发货内容

@end

@interface AppServiceInfo : AppType

@property (strong, nonatomic) NSString *open_city_id;//所在城市编号
@property (strong, nonatomic) NSString *open_city_name;//所在城市名称
@property (strong, nonatomic) NSString *service_id;//所属门店编号
@property (strong, nonatomic) NSString *service_name;//所属门店名称

- (NSString *)showCityAndServiceName;

@end

@interface AppCityInfo : AppType

@property (strong, nonatomic) NSString *open_city_id;//所在城市编号
@property (strong, nonatomic) NSString *open_city_name;//所在城市名称

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

//下单数据
@interface AppSaveWayBillInfo : AppType

@property (strong, nonatomic) NSString *end_station_service_id;//到站城市编号
@property (strong, nonatomic) NSString *shipper_name;//发货人名称
@property (strong, nonatomic) NSString *shipper_phone;//发货人电话
@property (strong, nonatomic) NSString *consignee_name;//收货人名称
@property (strong, nonatomic) NSString *consignee_phone;//收货人电话
@property (strong, nonatomic) NSString *freight;//运费
@property (strong, nonatomic) NSString *insurance_amount;//保价金额
@property (strong, nonatomic) NSString *insurance_fee;//保价费
@property (strong, nonatomic) NSString *take_goods_fee;//接货费
@property (strong, nonatomic) NSString *deliver_goods_fee;//送货费
@property (strong, nonatomic) NSString *rebate_fee;//回扣费
@property (strong, nonatomic) NSString *forklift_fee;//叉车费
@property (strong, nonatomic) NSString *return_fee;//原货返回费
@property (strong, nonatomic) NSString *pay_for_sb_fee;//垫付费
@property (strong, nonatomic) NSString *cash_on_delivery_amount;//代收款金额
@property (assign, nonatomic) BOOL is_deduction_freight;//是否运费代扣
@property (assign, nonatomic) BOOL is_urgent;//是否急货
@property (strong, nonatomic) NSString *total_amount;//总费用
@property (assign, nonatomic) BOOL is_pay_now;//是否现付
@property (strong, nonatomic) NSString *pay_now_amount;//现付金额
@property (assign, nonatomic) BOOL is_pay_on_delivery;//是否提付
@property (strong, nonatomic) NSString *pay_on_delivery_amount;//提付金额
@property (assign, nonatomic) BOOL is_pay_on_receipt;//是否回单付
@property (strong, nonatomic) NSString *pay_on_receipt_amount;//回单付金额
@property (strong, nonatomic) NSString *note;//运单内部
@property (strong, nonatomic) NSString *inner_note;//运单内部备注
@property (strong, nonatomic) NSString *return_waybill_number;//原货返货运单号
@property (strong, nonatomic) NSString *consignment_time;//托运日期
@property (strong, nonatomic) NSString *waybill_items;//运单货物明细（JSON格式）
@property (strong, nonatomic) NSString *receipt_sign_type;//回单签收方式
@property (strong, nonatomic) NSString *cash_on_delivery_type;//代收款类型
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
@property (strong, nonatomic) NSString *goods_number;//货物编号
@property (strong, nonatomic) NSString *waybill_state;//运单状态
@property (strong, nonatomic) NSString *waybill_state_text;//运单状态文本
@property (strong, nonatomic) NSString *route;//线路信息
@property (strong, nonatomic) NSString *goods;//货物信息
@property (strong, nonatomic) NSString *cust;//客户信息
@property (strong, nonatomic) NSString *pay_now_amount;//现付
@property (strong, nonatomic) NSString *pay_on_delivery_amount;//提付
@property (strong, nonatomic) NSString *pay_on_receipt_amount;//回单付
@property (strong, nonatomic) NSString *is_urgent;//是否急货
@property (strong, nonatomic) NSString *is_cash_on_delivery;//是否有代收款
@property (strong, nonatomic) NSString *cash_on_delivery_type;//代收款类型
@property (strong, nonatomic) NSString *cash_on_delivery_amount;//代收款金额
@property (strong, nonatomic) NSString *is_deduction_freight;//是否运费代扣

- (NSString *)statusStringForState;
- (UIColor *)statusColorForState;

@end

@interface AppCanReceiveWayBillInfo : AppWayBillInfo

//@property (strong, nonatomic) NSString *cash_on_delivery_amount;
//@property (strong, nonatomic) NSString *cash_on_delivery_type;
@property (strong, nonatomic) NSString *cash_on_delivery_type_text;
@property (strong, nonatomic) NSString *consignee_name;
@property (strong, nonatomic) NSString *consignee_phone;
//@property (strong, nonatomic) NSString *cust;
@property (strong, nonatomic) NSString *end_station_city_name;
//@property (strong, nonatomic) NSString *goods;
@property (strong, nonatomic) NSString *goods_name;
//@property (strong, nonatomic) NSString *goods_number;
@property (strong, nonatomic) NSString *goods_packge;
@property (strong, nonatomic) NSString *goods_total_count;
@property (strong, nonatomic) NSString *goods_total_volume;
@property (strong, nonatomic) NSString *goods_total_weight;
//@property (strong, nonatomic) NSString *is_cash_on_delivery;
//@property (strong, nonatomic) NSString *is_deduction_freight;
//@property (strong, nonatomic) NSString *is_urgent;
//@property (strong, nonatomic) NSString *pay_now_amount;
//@property (strong, nonatomic) NSString *pay_on_delivery_amount;
//@property (strong, nonatomic) NSString *pay_on_receipt_amount;
//@property (strong, nonatomic) NSString *route;
@property (strong, nonatomic) NSString *shipper_name;
@property (strong, nonatomic) NSString *start_station_city_name;
@property (strong, nonatomic) NSString *start_station_service_name;
@property (strong, nonatomic) NSString *total_amount;
//@property (strong, nonatomic) NSString *waybill_id;
//@property (strong, nonatomic) NSString *waybill_number;
//@property (strong, nonatomic) NSString *waybill_state;
//@property (strong, nonatomic) NSString *waybill_state_text;

- (NSString *)payStyleStringForState;

@end

@interface AppTrunkInfo : AppType

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

@interface AppTransportTrunkInfo : AppTrunkInfo


@end

@interface AppQueryTransportTrunkInfo : AppTrunkInfo

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


@interface AppCanLoadTransportTruckInfo : AppQueryTransportTrunkInfo


@end

@interface AppCanArrivalTransportTruckInfo : AppQueryTransportTrunkInfo

@property (strong, nonatomic) NSString *arrival_time;//到车时间
@property (strong, nonatomic) NSString *nohandover_count;//未交接运单数量

@end

@interface AppSearchQuantityInfo : AppType

@property (strong, nonatomic) NSDate *start_time;//开始时间
@property (strong, nonatomic) NSDate *end_time;//结束时间
@property (strong, nonatomic) AppCityInfo *start_station_city;//始发站
@property (strong, nonatomic) AppCityInfo *end_station_city;//终点站

- (NSString *)showStartTimeString;
- (NSString *)showEndTimeString;
- (NSString *)showStartStationString;
- (NSString *)showEndStationString;

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
