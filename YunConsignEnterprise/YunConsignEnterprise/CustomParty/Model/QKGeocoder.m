//
//  QKGeocoder.m
//  SmartTeaching
//
//  Created by yangqingluo on 16/8/8.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "QKGeocoder.h"

@implementation QKPlaceMark



@end

__strong static QKGeocoder  *_singleGeocoder = nil;
@implementation QKGeocoder

+ (QKGeocoder *)sharedGeocoder {
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _singleGeocoder = [[QKGeocoder alloc] init];
    });
    return _singleGeocoder;
}

+ (void)reverseGeocodeLocation:(CLLocationCoordinate2D )location completionHandler:(QKGeocodeCompletionHandler)completionHandler{
    QKPlaceMark *placemark = [QKGeocoder sharedGeocoder].dataSource[keyForLocation(location)];
    if (placemark) {
        completionHandler(placemark, nil);
    }
    else{
        [[QKNetworkSingleton sharedManager] Get:nil HeadParm:nil URLString:[NSString stringWithFormat:@"http://restapi.amap.com/v3/geocode/regeo?output=json&location=%f,%f&key=40a660143178916a573e5e9bff3cb2a3",location.longitude,location.latitude] completion:^(id responseBody, NSError *error) {
            if (!error) {
                NSString *string = [[NSString alloc] initWithData:responseBody encoding:NSUTF8StringEncoding];
                NSDictionary *dicReceive = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                
                if ([dicReceive[@"status"] intValue] == 1) {
                    NSDictionary *data = dicReceive[@"regeocode"];
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        QKPlaceMark *coder = [QKPlaceMark mj_objectWithKeyValues:data];
                        [[QKGeocoder sharedGeocoder].dataSource setObject:coder forKey:keyForLocation(location)];
                        completionHandler(coder, nil);
                        return;
                    }
                }
                else {
                    NSError *error = [NSError errorWithDomain:dicReceive[@"info"] code:-1 userInfo:nil];
                    completionHandler(nil, error);
                }
            }
            else {
                completionHandler(nil, error);

            }
        }];
    }
}

NSString *keyForLocation(CLLocationCoordinate2D location){
    return [NSString stringWithFormat:@"%.6f&%.6f",location.longitude,location.latitude];
}

NSString *locationDetailString(QKPlaceMark *placemark, NSError *error){
    NSString *address = @"";
    
    if ([placemark.formatted_address isKindOfClass:[NSString class]]){
        if (placemark.formatted_address.length) {
            address = [NSString stringWithFormat:@"%@",placemark.formatted_address];
        }
    }
    else if (error == nil ){
        address = @"位置信息不存在";
    }
    else if (error != nil){
        address = @"位置信息获取出错，请重试";
    }
    else
        address = @"位置信息获取失败，请重试";
    
    return address;
}

NSString *locationSimpleString(QKPlaceMark *placemark, NSError *error){
    NSString *address = nil;
    
    if ([placemark.formatted_address isKindOfClass:[NSString class]]){
        if (placemark.formatted_address.length) {
            address = [NSString stringWithFormat:@"%@",placemark.formatted_address];

        }
    }
    
    return address;
}

#pragma getter
- (NSMutableDictionary *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableDictionary new];
    }
    
    return _dataSource;
}

@end
