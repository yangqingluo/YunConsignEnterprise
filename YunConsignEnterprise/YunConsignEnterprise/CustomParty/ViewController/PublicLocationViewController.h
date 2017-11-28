//
//  PublicLocationViewController.h
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/22.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppBasicViewController.h"
#import <MapKit/MapKit.h>
#import "QKGeocoder.h"

@interface PublicLocationViewController : AppBasicViewController<MKMapViewDelegate> {
    MKPointAnnotation *_annotation;
    CLLocationCoordinate2D _currentLocationCoordinate;
    BOOL hasShowLocation;
}

@property (strong, nonatomic) MKMapView *mapView;
@property (assign, nonatomic) BOOL isSendLocation;
@property (strong, nonatomic) NSString *addressString;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate;
- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate andAddress:(NSString *)address;
- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate andAddress:(NSString *)address isSend:(BOOL)isSend;

- (void)createAnnotationWithCoords:(CLLocationCoordinate2D)coords withSelected:(BOOL)selected;
- (void)createAnnotationWithCoords:(CLLocationCoordinate2D)coords title:(NSString *)title withSelected:(BOOL)selected;
- (void)moveToCoords:(CLLocationCoordinate2D)coords;
- (void)moveToCoords:(CLLocationCoordinate2D)coords animated:(BOOL)animated;

@end
