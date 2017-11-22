//
//  QKGeocoder.h
//  SmartTeaching
//
//  Created by yangqingluo on 16/8/8.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QKPlaceMark : NSObject

@property(nonatomic, strong) NSString *formatted_address; 	//结构化地址信息，结构化地址信息包括：省+市+区+乡镇+街道+门牌号 如果坐标点处于海域范围内，则结构化地址信息为：省+市+区+海域信息
@property(nonatomic, strong) NSDictionary *addressComponent; //地址元素列表

@end

typedef void (^QKGeocodeCompletionHandler)(QKPlaceMark * __nullable placemark, NSError * __nullable error);

@interface QKGeocoder : NSObject

+ (QKGeocoder *)sharedGeocoder;
+ (void)reverseGeocodeLocation:(CLLocationCoordinate2D )location completionHandler:(QKGeocodeCompletionHandler)completionHandler;

NSString *locationDetailString(QKPlaceMark *placemark, NSError *error);
NSString *locationSimpleString(QKPlaceMark *placemark, NSError *error);

@property(nonatomic, strong) NSMutableDictionary *dataSource;

@end

NS_ASSUME_NONNULL_END
