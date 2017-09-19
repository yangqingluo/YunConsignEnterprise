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



@end

@implementation AppSendReceiveInfo



@end
