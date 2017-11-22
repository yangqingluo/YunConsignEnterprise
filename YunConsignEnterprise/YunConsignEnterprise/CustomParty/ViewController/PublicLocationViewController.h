//
//  PublicLocationViewController.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/22.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppBasicViewController.h"
#import <MapKit/MapKit.h>

@interface PublicLocationViewController : AppBasicViewController

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate;
- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate andAddress:(NSString *)address;

@end
