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

typedef NS_ENUM(NSInteger, WaybillDetailType) {
    WaybillDetailType_WayBillQuery = 0,
    WaybillDetailType_WaybillReceive,
    WaybillDetailType_CodQuery,
    WaybillDetailType_CodWaitPay,
    WaybillDetailType_DailyReimbursementApply,
};

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

typedef NS_ENUM(NSInteger, RESOURCE_TYPE) {
    RESOURCE_TYPE_Reimburse = 1,//日常报销
    RESOURCE_TYPE_Waybill,//签收单
};

//回单状态
typedef enum : NSUInteger {
    RECEIPT_STATE_TYPE_1 = 1,//未到站
    RECEIPT_STATE_TYPE_2 = 2,//未提货
    RECEIPT_STATE_TYPE_3 = 3,//已提货
    RECEIPT_STATE_TYPE_4 = 4,//已回单
} RECEIPT_STATE_TYPE;

typedef NS_ENUM(NSInteger, LOAN_APPLY_STATE) {
    LOAN_APPLY_STATE_1 = 1,//等待审核
    LOAN_APPLY_STATE_2,//审核通过
    LOAN_APPLY_STATE_3,//驳回
    LOAN_APPLY_STATE_4,//已放款
};

typedef NS_ENUM(NSInteger, WAYBILL_CHANGE_APPLY_STATE) {
    WAYBILL_CHANGE_APPLY_STATE_1 = 1,//等待审核
    WAYBILL_CHANGE_APPLY_STATE_2,//审核通过
    WAYBILL_CHANGE_APPLY_STATE_3,//驳回
};

//运单状态
typedef NS_ENUM(NSInteger, WAYBILL_STATE) {
    WAYBILL_STATE_1 = 1,//等待装车
    WAYBILL_STATE_2,//已装车
    WAYBILL_STATE_3,//运输中
    WAYBILL_STATE_4,//已到站
    WAYBILL_STATE_5,//已完成
    WAYBILL_STATE_6,//已作废
};

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
@property (strong, nonatomic) NSString *open_city_id;//所属城市
@property (strong, nonatomic) NSString *open_city_name;
@property (strong, nonatomic) NSString *role_id;//岗位编号，多个用逗号隔开
@property (strong, nonatomic) NSString *role_name;//岗位名称，多个采用逗号隔开
@property (strong, nonatomic) NSString *service_id;//所属门店
@property (strong, nonatomic) NSString *service_name;
@property (strong, nonatomic) NSString *telphone;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *user_state;//用户状态，USER_STATE，1正常、2禁用、3删除
@property (strong, nonatomic) NSString *user_state_text;

@end

@interface AppUserDetailInfo : AppUserInfo

@property (strong, nonatomic) NSString *login_code;//登录名
@property (strong, nonatomic) NSString *login_pass;//密码
@property (strong, nonatomic) NSString *power_service_id;//财务权限门店，不是财务只能看自己门店，财务可看全部
@property (strong, nonatomic) NSString *power_service_name;//财务权限门店，不是财务只能看自己门店，财务可看全部
@property (strong, nonatomic) NSString *power_city_id;//调度城市
@property (strong, nonatomic) NSString *power_city_name;

@end

@interface AppPasswordInfo : AppType

@property (strong, nonatomic) NSString *pass_old;//旧密码
@property (strong, nonatomic) NSString *pass_new;//新密码
@property (strong, nonatomic) NSString *pass_again;//确认新密码

@end

@interface AppCustomerInfo : AppType

@property (strong, nonatomic) NSString *freight_cust_id;//客户编号
@property (strong, nonatomic) NSString *freight_cust_name;//客户姓名
@property (strong, nonatomic) NSString *id_card;//身份证号
@property (strong, nonatomic) NSString *phone;//电话
@property (strong, nonatomic) NSString *last_deliver_time;//最后发货时间
@property (strong, nonatomic) NSString *last_deliver_goods;//最后发货内容
@property (strong, nonatomic) NSString *bank_name;//银行名称
@property (strong, nonatomic) NSString *bank_card_account;//银行卡号
@property (strong, nonatomic) NSString *belong_city_id;//所属城市编号
@property (strong, nonatomic) NSString *belong_city_name;//所属城市名称
@property (strong, nonatomic) NSString *note;//备注

@end

@interface AppCustomerDetailInfo : AppCustomerInfo


@end

@interface AppServiceInfo : AppType

@property (strong, nonatomic) NSString *open_city_id;//所在城市编号
@property (strong, nonatomic) NSString *open_city_name;//所在城市名称
@property (strong, nonatomic) NSString *service_id;//所属门店编号
@property (strong, nonatomic) NSString *service_name;//所属门店名称
@property (strong, nonatomic) NSString *service_code;//开单代码

@property (strong, nonatomic) NSString *service_address;//门店地址
@property (strong, nonatomic) NSString *service_phone;//门店电话
@property (strong, nonatomic) NSString *responsible_info;//负责人信息
@property (strong, nonatomic) NSString *responsible_name;//负责人姓名
@property (strong, nonatomic) NSString *responsible_phone;//负责人电话
@property (strong, nonatomic) NSString *service_state;//门店状态
@property (strong, nonatomic) NSString *service_state_text;//门店状态文本

- (NSString *)showCityAndServiceName;

@end

@interface AppServiceDetailInfo : AppServiceInfo

@property (strong, nonatomic) NSString *service_number;//门店系统代码，用于生成运单号
@property (strong, nonatomic) NSString *service_pinyin;//门店拼音
@property (strong, nonatomic) NSString *longitude;//经度
@property (strong, nonatomic) NSString *latitude;//纬度
@property (strong, nonatomic) NSString *print_count;//标签可打印数量

//编辑保存时自定义使用
@property (strong, nonatomic) NSString *location;

@end

@interface AppTownInfo : AppType

@property (strong, nonatomic) NSString *town_id;//中转站编号
@property (strong, nonatomic) NSString *town_name;//中转站名称
@property (strong, nonatomic) NSString *sort;//排序

@end

@interface AppGoodInfo : AppType

@property (strong, nonatomic) NSString *good_id;//常用品名编号
@property (strong, nonatomic) NSString *good_name;//常用品名名称

@end

@interface AppGoodDetailInfo : AppGoodInfo

@property (strong, nonatomic) NSString *good_py;//常用品名拼音
@property (strong, nonatomic) NSString *sort;//常用品名排序

@end

@interface AppPackageInfo : AppType

@property (strong, nonatomic) NSString *package_id;//常用包装编号
@property (strong, nonatomic) NSString *package_name;//常用包装名称

@end

@interface AppPackageDetailInfo : AppPackageInfo

@property (strong, nonatomic) NSString *package_py;//常用包装拼音
@property (strong, nonatomic) NSString *sort;//常用包装排序

@end

@interface AppCityInfo : AppType

@property (strong, nonatomic) NSString *open_city_id;//所在城市编号
@property (strong, nonatomic) NSString *open_city_name;//所在城市名称

@end

@interface AppCityDetailInfo : AppCityInfo

@property (strong, nonatomic) NSString *open_city_py;//开通城市名称拼音
@property (strong, nonatomic) NSString *sort;//开通城市名称排序

@end

@interface AppVoucherInfo : AppType

@property (strong, nonatomic) NSString *upload_date;
@property (strong, nonatomic) NSString *voucher;
@property (strong, nonatomic) NSString *waybill_id;
@end


@interface AppLocationInfo : AppType

@property (strong, nonatomic) NSString *longitude;//经度
@property (strong, nonatomic) NSString *latitude;//纬度
@property (strong, nonatomic) NSString *addressString;

@end

@interface AppEndStationInfo : AppType

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
@property (strong, nonatomic) AppTownInfo *town;

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
@property (strong, nonatomic) NSString *freight;//运费
@property (strong, nonatomic) NSString *number;//数量，件
@property (strong, nonatomic) NSString *volume;//体积，方
@property (strong, nonatomic) NSString *weight;//重量，吨

@end

@interface AppWaybillItemInfo : AppType

@property (strong, nonatomic) NSString *waybill_id;
@property (strong, nonatomic) NSString *waybill_item_id;
@property (strong, nonatomic) NSString *waybill_item_name;
@property (strong, nonatomic) NSString *packge;//包装
@property (strong, nonatomic) NSString *freight;//运费
@property (strong, nonatomic) NSString *number;//数量，件
@property (strong, nonatomic) NSString *volume;//体积，方
@property (strong, nonatomic) NSString *weight;//重量，吨

@end

//下单数据
@interface AppSaveWayBillInfo : AppType

@property (strong, nonatomic) NSString *end_station_service_id;//到站门店编号
@property (strong, nonatomic) NSString *real_station_city_name;//真实到站名称（中转站）
@property (strong, nonatomic) NSString *shipper_name;//发货人名称
@property (strong, nonatomic) NSString *shipper_phone;//发货人电话
@property (strong, nonatomic) NSString *shipper_id_card;//发货人身份证号
@property (strong, nonatomic) NSString *shipper_bank_name;//代收款打款银行名称
@property (strong, nonatomic) NSString *shipper_bank_card_account;//代收款打款银行卡号
@property (strong, nonatomic) NSString *consignee_name;//收货人名称
@property (strong, nonatomic) NSString *consignee_phone;//收货人电话
@property (strong, nonatomic) NSString *insurance_amount;//保价金额
@property (strong, nonatomic) NSString *insurance_fee;//保价费
@property (strong, nonatomic) NSString *take_goods_fee;//接货费
@property (strong, nonatomic) NSString *deliver_goods_fee;//送货费
@property (strong, nonatomic) NSString *rebate_fee;//回扣费
@property (strong, nonatomic) NSString *forklift_fee;//叉车费
@property (strong, nonatomic) NSString *transfer_fee;//中转费
@property (strong, nonatomic) NSString *return_fee;//原货返回费
@property (strong, nonatomic) NSString *pay_for_sb_fee;//垫付费
@property (strong, nonatomic) NSString *cash_on_delivery_amount;//代收款金额
@property (assign, nonatomic) NSString *is_deduction_freight;//是否运费代扣
//@property (assign, nonatomic) NSString *is_urgent;//是否急货
@property (strong, nonatomic) NSString *is_deliver_goods;//是否送货
@property (strong, nonatomic) NSString *total_amount;//总费用
@property (assign, nonatomic) NSString *is_pay_now;//是否现付
@property (strong, nonatomic) NSString *pay_now_amount;//现付金额
@property (assign, nonatomic) NSString *is_pay_on_delivery;//是否提付
@property (strong, nonatomic) NSString *pay_on_delivery_amount;//提付金额
@property (assign, nonatomic) NSString *is_pay_on_receipt;//是否回单付
@property (strong, nonatomic) NSString *pay_on_receipt_amount;//回单付金额
@property (strong, nonatomic) NSString *note;//运单内部
@property (strong, nonatomic) NSString *inner_note;//运单内部备注
@property (strong, nonatomic) NSString *return_waybill_number;//原货返回货号
@property (strong, nonatomic) NSString *return_waybill_id;//原货返回运单编号
@property (strong, nonatomic) NSString *consignment_time;//托运日期
@property (strong, nonatomic) NSString *receipt_sign_type;//回单签收方式
@property (strong, nonatomic) NSString *cash_on_delivery_type;//代收款类型
@property (strong, nonatomic) NSString *freight;//运费
@property (strong, nonatomic) NSString *goods_packge;//包装
@property (strong, nonatomic) NSString *goods_total_count;//物品总件数
@property (strong, nonatomic) NSString *goods_total_weight;//物品总重量
@property (strong, nonatomic) NSString *goods_total_volume;//物品总体积
@property (strong, nonatomic) NSString *change_cause;//修改原因
@property (strong, nonatomic) NSString *waybill_items;//运单货物明细（JSON格式）
@property (strong, nonatomic) NSString *is_update_waybill_item;//是否更新货物明细
@property (strong, nonatomic) NSString *goods_number;//货物编号

- (void)appendSenderInfo:(AppSendReceiveInfo *)info;
- (void)appendReceiverInfo:(AppSendReceiveInfo *)info;
- (NSDictionary *)app_keyValues;

- (NSArray *)defaultKVOArray;

@end

//原货返回下单数据
@interface AppSaveReturnWayBillInfo : AppSaveWayBillInfo



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
//@property (strong, nonatomic) NSString *is_urgent;//是否急货
@property (strong, nonatomic) NSString *is_deliver_goods;//是否送货
@property (strong, nonatomic) NSString *is_receipt;//是否有回单
@property (strong, nonatomic) NSString *start_station_city_id;//发站城市编号
@property (strong, nonatomic) NSString *start_station_city_name;//发站城市名称
@property (strong, nonatomic) NSString *start_station_service_id;//发站网点编号
@property (strong, nonatomic) NSString *start_station_service_name ;//发站网点名称
@property (strong, nonatomic) NSString *end_station_city_id;//到站城市编号
@property (strong, nonatomic) NSString *end_station_city_name;//到站城市名称
@property (strong, nonatomic) NSString *end_station_service_id;//到站网点编号
@property (strong, nonatomic) NSString *end_station_service_name;//到站网点名称
@property (strong, nonatomic) NSString *real_station_city_name;//真实到站名称（中转站）
@property (strong, nonatomic) NSString *shipper_name;//发货人名称
@property (strong, nonatomic) NSString *shipper_phone;//发货人电话
@property (strong, nonatomic) NSString *shipper_bank_name;//代收款打款银行名称
@property (strong, nonatomic) NSString *shipper_bank_card_account;//代收款打款银行卡号
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
- (NSString *)payStyleStringForStateOld;

@end

@interface AppWayBillDetailInfo : AppWayBillInfo

@property (strong, nonatomic) NSString *receipt_state;//回单状态 RECEIPT_STATE 未到站、未付款、已付款
@property (strong, nonatomic) NSString *receipt_state_text;
@property (strong, nonatomic) NSString *cash_on_delivery_state;//代收款状态 CASH_ON_DELIVERY_STATE 未收款、已收款、已申请、已审核、已放款
@property (strong, nonatomic) NSString *cash_on_delivery_state_text;
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
@property (strong, nonatomic) NSString *deliver_goods_fee;//送货费
@property (strong, nonatomic) NSString *receipt_sign_type;//回单签收方式 RECEIPT_SIGN_TYPE 无回单、签字、盖章、签字+盖章
@property (strong, nonatomic) NSString *receipt_sign_type_text;
@property (strong, nonatomic) NSString *rebate_fee;//回扣费
@property (strong, nonatomic) NSString *forklift_fee;//叉车费
@property (strong, nonatomic) NSString *transfer_fee;//中转费
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
@property (strong, nonatomic) NSString *return_waybill_id;//原货返回运单编号
@property (strong, nonatomic) NSString *waybill_change_count;//运单修改次数
@property (strong, nonatomic) NSArray *waybill_items;//货物信息


@property (strong, nonatomic) NSString *cust_info;//客户信息
@property (strong, nonatomic) NSString *goods_info;//货物信息
@property (strong, nonatomic) NSString *cash_on_delivery_real_amount;//实收代收款
@property (strong, nonatomic) NSString *cash_on_delivery_real_time;//收款时间
@property (strong, nonatomic) NSString *cash_on_delivery_causes_amount;//少款金额，没有收款，显示未收款
@property (strong, nonatomic) NSString *cash_on_delivery_causes_note;//少款原因
@property (strong, nonatomic) NSString *agent_money_fee;//手续费
@property (strong, nonatomic) NSString *is_can_apply;//是否能够申请 YES_NO 1是2否
@property (strong, nonatomic) NSString *print_check_code;//6位数字验证代码，用于确认运单的真伪，防止重复打印，可以申请时才有
@property (strong, nonatomic) NSString *not_can_apply_note;//不能申请的原因

@property (strong, nonatomic) NSString *less_indemnity_amount ;//少款
@property (strong, nonatomic) NSString *payment_indemnity_amount;//赔款
@property (strong, nonatomic) NSString *deliver_indemnity_amount;//包送

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
@property (strong, nonatomic) NSString *handover_state_text;
@property (strong, nonatomic) NSString *print_state;//打印状态，YES_NO，1是，2否
@property (strong, nonatomic) NSString *print_state_text;

@end

@interface AppPaymentWaybillInfo : AppWayBillInfo

@property (strong, nonatomic) NSString *goods_total;//件吨方

@end

@interface AppNeedReceiptWayBillInfo : AppWayBillDetailInfo

@property (strong, nonatomic) NSString *shipper;//发货人

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
@property (strong, nonatomic) NSString *city_info;
@property (strong, nonatomic) NSString *is_get_cash_on_delivery;
@property (strong, nonatomic) NSString *loan_apply_state;
@property (strong, nonatomic) NSString *cash_on_delivery_note;//应收代收款备注

@end

@interface AppLoanApplyCheckWaybillInfo : AppWayBillInfo

@property (strong, nonatomic) NSString *loan_apply_state;//申请状态 LOAN_APPLY_STATE 等待审核、审核通过、驳回、已放款，只有在等待审核状态下，才能进行“驳回”操作
@property (strong, nonatomic) NSString *loan_apply_state_text;
@property (strong, nonatomic) NSString *cust_info;//客户信息
@property (strong, nonatomic) NSString *cash_on_delivery_real_amount;//实收代收款
@property (strong, nonatomic) NSString *cash_on_delivery_real_time;//收款时间
@property (strong, nonatomic) NSString *cash_on_delivery_causes_amount;//少款金额，没有收款，显示未收款
@property (strong, nonatomic) NSString *cash_on_delivery_causes_note;//少款原因
@property (strong, nonatomic) NSString *system_check;//系统检查结果，除“正常”外，其余都是红色字显示
@property (strong, nonatomic) NSString *is_reject;//是否驳回 YES_NO 1是2否
@property (strong, nonatomic) NSString *reject_note;//驳回原因
@property (strong, nonatomic) NSString *city_info;//城市

@end

//运单修改申请数据
@interface AppWaybillChangeApplyInfo : AppWayBillInfo

@property (strong, nonatomic) NSString *change_id;//申请编号
@property (strong, nonatomic) NSString *change_state;//申请状态
@property (strong, nonatomic) NSString *change_state_text;
@property (strong, nonatomic) NSString *apply;//申请信息
@property (strong, nonatomic) NSString *check;//审核信息
@property (strong, nonatomic) NSString *change_note;//修改内容
@property (strong, nonatomic) NSString *check_note;//驳回原因

@end

//进行自提提交数据
@interface WaybillToCustReceiveInfo : AppType

@property (strong, nonatomic) NSString *waybill_id;//运单内部编号
@property (strong, nonatomic) NSString *consignee_name;//提货人
@property (strong, nonatomic) NSString *consignee_phone;//提货电话
@property (strong, nonatomic) AppDataDictionary *cash_on_delivery_causes_type;//代收款少款类型，CASH_ON_DELIVERY_CAUSES_TYPE，1不少款、2运费代扣、3其他，默认1不少款
@property (strong, nonatomic) NSString *consignee_id_card;//提货人身份证
@property (strong, nonatomic) NSString *cash_on_delivery_real_amount;//实收代收款，0表示没有收到代收款
@property (strong, nonatomic) NSString *cash_on_delivery_causes_amount;//少款金额
@property (strong, nonatomic) NSString *cash_on_delivery_causes_note;//代收款少款原因备注
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
@property (strong, nonatomic) NSString *cost_load;//装车费
@property (strong, nonatomic) NSString *cost_check;//结算运费
@property (strong, nonatomic) NSString *operate_time;
@property (strong, nonatomic) NSString *operator_id;
@property (strong, nonatomic) NSString *operator_name;
@property (strong, nonatomic) NSString *truck_id;//车辆编号
@property (strong, nonatomic) NSString *truck_number_plate;//车辆牌照
@property (strong, nonatomic) NSString *truck_driver_name;//司机姓名
@property (strong, nonatomic) NSString *truck_driver_phone;//司机电话
@property (strong, nonatomic) NSString *note;//备注

@end

@interface AppTruckDetailInfo : AppTruckInfo

@property (strong, nonatomic) NSString *driver_account;//银行卡号
@property (strong, nonatomic) NSString *driver_account_name;//户主
@property (strong, nonatomic) NSString *driver_account_bank;//开户行

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
@property (strong, nonatomic) NSString *operator_name;//登记人
@property (strong, nonatomic) NSString *start_car_time;
@property (strong, nonatomic) NSString *transport_truck_state;
@property (strong, nonatomic) NSString *cost_load;//装车费
@property (strong, nonatomic) NSString *cost_before;//预付费

@end

@interface AppSaveTransportTruckInfo : AppType

@property (strong, nonatomic) NSString *start_station_city_id;
@property (strong, nonatomic) NSString *start_station_city_name;//始发站
@property (strong, nonatomic) NSString *truck_number_plate;//车牌
@property (strong, nonatomic) NSString *truck_driver_name;//司机
@property (strong, nonatomic) NSString *truck_driver_phone;//电话
@property (strong, nonatomic) NSString *cost_register;//登记运费
@property (strong, nonatomic) NSString *cost_load;//装车费
@property (strong, nonatomic) NSString *cost_before;//预付费
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
@property (strong, nonatomic) NSString *remain;//剩余

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

@interface AppCodLoanApplyInfo : AppType

@property (strong, nonatomic) NSString *loan_apply_id;//申请放款编号
@property (strong, nonatomic) NSString *loan_apply_state;//申请放款状态
@property (strong, nonatomic) NSString *loan_apply_state_text;
@property (strong, nonatomic) NSString *cust_info;//客户信息
@property (strong, nonatomic) NSString *bank_info;//银行信息
@property (strong, nonatomic) NSString *apply_amount;//申请放款金额
@property (strong, nonatomic) NSString *apply_time;//申请时间
@property (strong, nonatomic) NSString *apply_note;//申请备注
@property (strong, nonatomic) NSString *audit_amount;//审核放款金额
@property (strong, nonatomic) NSString *audit_time;//审核时间
@property (strong, nonatomic) NSString *audit_name;//审核人
@property (strong, nonatomic) NSString *bank_card_account;//银行卡账号
@property (strong, nonatomic) NSString *bank_card_owner;
@property (strong, nonatomic) NSString *bank_name;
@property (strong, nonatomic) NSString *contact_phone;

@property (strong, nonatomic) NSString *apply_amount_fee;//手续费
@property (strong, nonatomic) NSString *apply_service_id;

/*根据条件查询审核通过发放代收款的列表时*/
@property (strong, nonatomic) NSString *loan_apply_ids;//申请单编号，多个用逗号隔开

@end

@interface AppCodLoanApplyWaitLoanInfo : AppCodLoanApplyInfo

@property (strong, nonatomic) NSString *remittance_id;//放款编号，未打款时不存在，此时使用loan_apply_ids查询申请单列表
@property (strong, nonatomic) NSString *remittance_state;//放款状态 REMITTANCE_STATE 未打款、已打款
@property (strong, nonatomic) NSString *operate_time;//放款时间
@property (strong, nonatomic) NSString *operator_name;//放款人
@property (strong, nonatomic) NSString *remit_amount;//放款金额
//@property (strong, nonatomic) NSString *bank_info;//银行名称
@property (strong, nonatomic) NSString *bank_account;//银行账号

@end

@interface AppDailyReimbursementApplyInfo : AppType

@property (strong, nonatomic) NSString *daily_apply_id;//报销申请编号
@property (strong, nonatomic) NSString *daily_name;//科目名称
@property (strong, nonatomic) NSString *daily_fee;//申请费用
@property (strong, nonatomic) NSString *apply_time;//申请时间
@property (strong, nonatomic) NSString *apply_name;//申请人
@property (strong, nonatomic) NSString *voucher;//凭证
@property (strong, nonatomic) NSString *waybill_info;//关联运单
@property (strong, nonatomic) NSString *note;//申请备注
@property (strong, nonatomic) NSString *daily_apply_state;//申请状态CHECK_STATE 等待审核、审核通过、驳回
@property (strong, nonatomic) NSString *daily_apply_state_text;//申请状态名称
@property (strong, nonatomic) NSString *check_name;//审核人
@property (strong, nonatomic) NSString *check_time;//审核时间
@property (strong, nonatomic) NSString *check_note;//审核内容

@property (strong, nonatomic) NSString *goods_number;
@property (strong, nonatomic) NSString *waybill_id;
@property (strong, nonatomic) NSString *waybill_number;
@property (strong, nonatomic) NSString *service_id;//申请门店编号
@property (strong, nonatomic) NSString *service_name;//申请门店名称

@property (strong, nonatomic) NSString *daily_info;//申请内容

- (BOOL)judgeWaybillInfoValidity;
- (NSString *)showWaybillInfoString;

@end

@interface AppDailyReimbursementCheckInfo : AppDailyReimbursementApplyInfo



@end

@interface AppDailyGrossMarginInfo : AppType

@property (strong, nonatomic) NSString *count_date;//日期
@property (strong, nonatomic) NSString *total_amount;//货量
@property (strong, nonatomic) NSString *cost_register;//车费
@property (strong, nonatomic) NSString *cost_load;//装车费
@property (strong, nonatomic) NSString *gross_margin;//毛利

@end








//查询条件
@interface AppQueryConditionInfo : AppType

@property (strong, nonatomic) NSDate *start_time;//开始时间
@property (strong, nonatomic) NSDate *end_time;//结束时间

/*客户管理*/
@property (strong, nonatomic) NSString *freight_cust_name;//客户姓名，至少2个汉字
@property (strong, nonatomic) NSString *phone;//客户电话，至少4位数字

/*订单相关*/
@property (strong, nonatomic) AppDataDictionary *query_column;//查询字段
@property (strong, nonatomic) NSString *query_val;//查询内容
@property (strong, nonatomic) NSArray *show_column;//显示字段
@property (strong, nonatomic) AppServiceInfo *start_service;
@property (strong, nonatomic) AppServiceInfo *end_service;
@property (strong, nonatomic) NSString *is_cancel;//是否作废
@property (strong, nonatomic) AppServiceInfo *power_service;//收款网点
@property (strong, nonatomic) AppServiceInfo *load_service;//装车网点
@property (strong, nonatomic) AppDataDictionary *waybill_type;//运单类型 全部、发货、收货

/*车辆相关*/
@property (strong, nonatomic) AppCityInfo *start_station_city;//起点城市
@property (strong, nonatomic) AppCityInfo *start_station_city_exception;//排除当前城市的起点城市
@property (strong, nonatomic) AppCityInfo *end_station_city;
@property (strong, nonatomic) NSString *truck_number_plate;//车辆牌照
@property (strong, nonatomic) AppDataDictionary *transport_truck_state;//车辆状态
@property (strong, nonatomic) NSString *transport_truck_id;//车辆id

/*财务管理相关*/
@property (strong, nonatomic) NSArray *power_service_array;//收款网点
@property (strong, nonatomic) AppDataDictionary *search_time_type;//时间类型
@property (strong, nonatomic) AppDataDictionary *cod_search_time_type;//时间类型
@property (strong, nonatomic) AppDataDictionary *cash_on_delivery_type;//代收方式
@property (strong, nonatomic) AppDataDictionary *cash_on_delivery_state_show;//代收方式(为了在某些情况下和cash_on_delivery_type同时存在)
@property (strong, nonatomic) AppDataDictionary *cod_payment_state;//收款状态
@property (strong, nonatomic) AppDataDictionary *cod_loan_state;//放款状态
@property (strong, nonatomic) NSString *order_by;//排序方式，比如：pay_now_amount desc
@property (strong, nonatomic) NSString *waybill_receive_state;//是否提货
@property (strong, nonatomic) NSString *bank_card_owner;//客户姓名
@property (strong, nonatomic) NSString *contact_phone;//联系电话
@property (strong, nonatomic) AppDataDictionary *loan_apply_state;//放款申请审核状态
@property (strong, nonatomic) AppDataDictionary *daily_name;//申请科目 叉车费、回扣费、赔款、水电费、其他
@property (strong, nonatomic) AppDataDictionary *daily_apply_state;//申请状态 CHECK_STATE 等待审核、审核通过、驳回
@property (strong, nonatomic) NSString *daily_fee;//报销金额
@property (strong, nonatomic) AppWayBillDetailInfo *bind_waybill;//绑定运单
@property (strong, nonatomic) NSString *note;//报销备注
@property (strong, nonatomic) NSString *voucher;//报销凭证，最多三张
@property (strong, nonatomic) AppServiceInfo *reimbursement_service;//报销网点
@property (strong, nonatomic) NSString *is_match_waybill;//是否关联运单

/*系统设置相关*/
@property (strong, nonatomic) AppCityInfo *open_city;//所属城市
@property (strong, nonatomic) AppDataDictionary *service_state;//门店状态 SERVICE_STATE 营业中、已停用
@property (strong, nonatomic) NSString *service_name;//门店名称
@property (strong, nonatomic) NSString *service_code;//门店代码
@property (strong, nonatomic) NSString *user_name;//姓名
@property (strong, nonatomic) NSString *telphone;//电话
@property (strong, nonatomic) NSArray *user_role;//岗位编号
@property (strong, nonatomic) NSString *truck_driver_name;//司机姓名
@property (strong, nonatomic) NSString *truck_driver_phone;//司机电话

- (NSString *)showStartTimeString;
- (NSString *)showEndTimeString;
- (NSString *)showStartStationString;
- (NSString *)showEndStationString;
- (NSString *)showArrayValStringWithKey:(NSString *)key;
- (NSString *)showArrayNameStringWithKey:(NSString *)key;
- (NSArray *)IDArrayForPowerServiceArray;

@end
