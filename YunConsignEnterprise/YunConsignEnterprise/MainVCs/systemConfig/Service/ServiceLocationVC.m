//
//  ServiceLocationVC.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/22.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "ServiceLocationVC.h"

@interface ServiceLocationVC ()

@end

@implementation ServiceLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店定位";
    
    if (self.isSendLocation) {
        NSString *title = [self.addressString copy];
        if (title) {
            [self moveToCoords:_currentLocationCoordinate animated:NO];
            [self createAnnotationWithCoords:_currentLocationCoordinate title:title withSelected:YES];
        }
    }
}

@end
