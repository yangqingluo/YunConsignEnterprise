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
@property (strong, nonatomic) NSArray *responses;

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

@end

@interface AppSendReceiveInfo : AppType

@property (strong, nonatomic) AppCustomerInfo *customer;
@property (strong, nonatomic) AppServiceInfo *service;

@end
