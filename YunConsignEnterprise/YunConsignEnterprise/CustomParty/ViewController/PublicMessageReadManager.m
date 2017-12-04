/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "PublicMessageReadManager.h"
#import "UIImageView+WebCache.h"

#define IMAGE_MAX_SIZE_5k 5120*2880

static PublicMessageReadManager *detailInstance = nil;

@interface PublicMessageReadManager()

@property (strong, nonatomic) UIWindow *keyWindow;

@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) UINavigationController *photoNavigationController;

@property (strong, nonatomic) UIAlertView *textAlertView;

@end

@implementation PublicMessageReadManager

+ (id)defaultManager
{
    @synchronized(self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            detailInstance = [[self alloc] init];
        });
    }
    
    return detailInstance;
}

#pragma mark - getter

- (UIWindow *)keyWindow
{
    if(_keyWindow == nil)
    {
        _keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    
    return _keyWindow;
}

- (NSMutableArray *)photos
{
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    
    return _photos;
}

- (MWPhotoBrowser *)photoBrowser
{
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.displayNavArrows = NO;
        _photoBrowser.startOnGrid = NO;
        _photoBrowser.enableGrid = YES;
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    
    return _photoBrowser;
}

- (UINavigationController *)photoNavigationController
{
    if (_photoNavigationController == nil) {
        _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    return _photoNavigationController;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.photos count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count)
    {
        return [self.photos objectAtIndex:index];
    }
    
    return nil;
}


#pragma mark - private


#pragma mark - public

- (void)showBrowserWithImages:(NSArray *)imageArray {
    [self showBrowserWithImages:imageArray currentPhotoIndex:0];
}

- (void)showBrowserWithImages:(NSArray *)imageArray currentPhotoIndex:(NSUInteger)index{
    if (imageArray && [imageArray count] > 0) {
        NSMutableArray *photoArray = [NSMutableArray array];
        for (id object in imageArray) {
            MWPhoto *photo;
            if ([object isKindOfClass:[UIImage class]]) {
                CGFloat imageSize = ((UIImage*)object).size.width * ((UIImage*)object).size.height;
                if (imageSize > IMAGE_MAX_SIZE_5k) {
                    photo = [MWPhoto photoWithImage:[self scaleImage:object toScale:(IMAGE_MAX_SIZE_5k)/imageSize]];
                } else {
                    photo = [MWPhoto photoWithImage:object];
                }
            }
            else if ([object isKindOfClass:[NSURL class]])
            {
                photo = [MWPhoto photoWithURL:object];
            }
            else if ([object isKindOfClass:[NSString class]])
            {
                photo = [MWPhoto photoWithURL:[NSURL URLWithString:object]];
            }
            else if ([object isKindOfClass:[MWPhoto class]]) {
                photo = object;
            }
            
            if (photo) {
                [photoArray addObject:photo];
            }
        }
        
        self.photos = photoArray;
    }
    
    [self.photoBrowser reloadData];
    
    if (index < self.photos.count) {
        [self.photoBrowser setCurrentPhotoIndex:index];
    }
    else{
        [self.photoBrowser setCurrentPhotoIndex:0];
    }
    
    UIViewController *rootController = [self.keyWindow rootViewController];
    [rootController presentViewController:self.photoNavigationController animated:YES completion:nil];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
