//
//  AppType.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/5.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@property (assign, nonatomic) int is_display;
@property (assign, nonatomic) int is_leaf;
@property (assign, nonatomic) int sort;
@property (strong, nonatomic) NSString *menu_code;
@property (strong, nonatomic) NSString *menu_icon;
@property (strong, nonatomic) NSString *menu_id;
@property (strong, nonatomic) NSString *menu_name;
@property (strong, nonatomic) NSString *parent_id;

@end

@interface AppUserInfo : AppType

@property (strong, nonatomic) NSArray *access_list;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *gender_text;
@property (strong, nonatomic) NSString *head_img;
@property (strong, nonatomic) NSString *join_id;
@property (strong, nonatomic) NSString *join_name;
@property (strong, nonatomic) NSString *login_token;
@property (strong, nonatomic) NSString *login_type;
@property (strong, nonatomic) NSString *login_type_text;
@property (strong, nonatomic) NSString *open_city_id;
@property (strong, nonatomic) NSString *open_city_name;
@property (strong, nonatomic) NSString *role_id;
@property (strong, nonatomic) NSString *role_name;
@property (strong, nonatomic) NSString *service_id;
@property (strong, nonatomic) NSString *service_name;
@property (strong, nonatomic) NSString *telphone;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *user_state;
@property (strong, nonatomic) NSString *user_state_text;

@end
