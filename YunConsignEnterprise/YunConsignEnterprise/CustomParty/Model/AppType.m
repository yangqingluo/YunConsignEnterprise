//
//  AppType.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/9/5.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppType.h"

@implementation AppType

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

@implementation AppUserInfo



@end
