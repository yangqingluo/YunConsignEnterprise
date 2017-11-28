//
//  PublicLocationViewController.m
//  YunConsignEnterprise
//
//  Created by 7kers on 2017/11/22.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "PublicLocationViewController.h"

#import <MapKit/MapKit.h>
#import "JZLocationConverter.h"
#import "QKGeocoder.h"

@interface PublicLocationViewController ()<MKMapViewDelegate> {
    MKMapView *_mapView;
    MKPointAnnotation *_annotation;
    CLLocationCoordinate2D _currentLocationCoordinate;
    BOOL _isSendLocation;
    BOOL hasShowLocation;
}

@property (strong, nonatomic) NSString *addressString;
@property (strong, nonatomic) UIButton *sendButton;

@end

@implementation PublicLocationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isSendLocation = YES;
    }
    return self;
}

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isSendLocation = NO;
        _currentLocationCoordinate = locationCoordinate;
    }
    return self;
}

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate andAddress:(NSString *)address {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isSendLocation = NO;
        _currentLocationCoordinate = locationCoordinate;
        _addressString = [address copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom, screen_width, screen_height)];
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.zoomEnabled = YES;
    [self.view addSubview:_mapView];
    
    if (_isSendLocation) {
        for (id subview1 in _mapView.subviews) {
            if([[NSString stringWithFormat:@"%@",((UIView *)subview1).class] isEqualToString:@"UIView"]){
                for (UIGestureRecognizer *g in ((UIView *)subview1).gestureRecognizers) {
                    if ([g isKindOfClass:[UIPanGestureRecognizer class]]) {
                        [g addTarget:self action:@selector(mapViewPan:)];
                    }
                }
            }
        }
    }
    else {
        [self removeToLocation:_currentLocationCoordinate];
        [self createAnnotationWithCoords:_currentLocationCoordinate withSelected:YES];
    }
}

- (void)setupNav {
    [self createNavWithTitle:self.title createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            if (_isSendLocation) {
                _sendButton = NewTextButton(@"确定", [UIColor whiteColor]);
                [_sendButton addTarget:self action:@selector(sendLocation) forControlEvents:UIControlEventTouchUpInside];
                return _sendButton;
            }
        }
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mapViewPan:(UIPanGestureRecognizer *)gesture{
    if (_isSendLocation) {
        [self createAnnotationWithCoords:_mapView.centerCoordinate withSelected:NO];
    }
}

/*!
 @brief 地图区域即将改变时会调用此接口
 @param mapview 地图View
 @param animated 是否动画
 */
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
}

/*!
 @brief 地图区域改变完成后会调用此接口
 @param mapview 地图View
 @param animated 是否动画
 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (_isSendLocation) {
        [self getAddressInfo:mapView.centerCoordinate];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!hasShowLocation) {
        [self removeToLocation:userLocation.coordinate];
        hasShowLocation = YES;
    }
}

#pragma mark - public
-(void)createAnnotationWithCoords:(CLLocationCoordinate2D)coords {
    if (_annotation == nil) {
        _annotation = [[MKPointAnnotation alloc] init];
    }
    else{
        [_mapView removeAnnotation:_annotation];
    }
    _annotation.coordinate = coords;
    [_mapView addAnnotation:_annotation];
}

- (void)removeToLocation:(CLLocationCoordinate2D)locationCoordinate {
    [self doHideHudFunction];
    
    _currentLocationCoordinate = locationCoordinate;
    float zoomLevel = 0.05;
    MKCoordinateRegion region = MKCoordinateRegionMake(_currentLocationCoordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
    
    if (_isSendLocation) {
        _sendButton.enabled = YES;
    }
    
    [self createAnnotationWithCoords:_currentLocationCoordinate];
}

- (void)sendLocation {
//    if (!self.addressString) {
//        [self showHint:@"无法获取位置信息"];
//        return;
//    }
//    if (_delegate && [_delegate respondsToSelector:@selector(sendLocationLatitude:longitude:andAddress:)]) {
//        [_delegate sendLocationLatitude:_currentLocationCoordinate.latitude longitude:_currentLocationCoordinate.longitude andAddress:_addressString];
//    }
    [self doDoneAction];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doDoneAction {
    if (self.doneBlock) {
        AppLocationInfo *data = [AppLocationInfo new];
        data.longitude = [NSString stringWithFormat:@"%.6f", _currentLocationCoordinate.longitude];
        data.latitude = [NSString stringWithFormat:@"%.6f", _currentLocationCoordinate.latitude];
        data.addressString = [_addressString copy];
        self.doneBlock(data);
    }
}


-(void)createAnnotationWithCoords:(CLLocationCoordinate2D)coords withSelected:(BOOL)selected
{
    if (_annotation == nil) {
        _annotation = [[MKPointAnnotation alloc] init];
    }
    else{
        [_mapView removeAnnotation:_annotation];
    }
    _annotation.coordinate = coords;
    _annotation.title = self.addressString;
    [_mapView addAnnotation:_annotation];
    
    if (selected) {
        [_mapView setSelectedAnnotations:@[_annotation]];
    }
}
- (void)getAddressInfo:(CLLocationCoordinate2D )coordinate{
//    if (!_sendButton.enabled) {
//        //获取位置信息尚未完成，return
//        return;
//    }
//    
//    if (_isSendLocation) {
//        _sendButton.enabled = NO;
//    }
//    [self doShowHudFunction:@"获取位置信息..."];
    QKWEAKSELF;
    [QKGeocoder reverseGeocodeLocation:coordinate completionHandler:^(QKPlaceMark *placemark, NSError *error){
        [weakself doHideHudFunction];
        self.addressString = locationSimpleString(placemark, error);
        if (!error && placemark) {
            _currentLocationCoordinate = coordinate;
            weakself.sendButton.enabled = YES;
            [weakself createAnnotationWithCoords:coordinate withSelected:YES];
        }
    }];
}

@end
