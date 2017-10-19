//
//  AppPublic.m
//
//  Created by yangqingluo on 16/9/9.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "AppPublic.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIImage+Color.h"

#import "LoginViewController.h"
#import "MainTabBarController.h"

@interface AppPublic()

@end

@implementation AppPublic

__strong static AppPublic  *_singleManger = nil;

+ (AppPublic *)getInstance {
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        _singleManger = [[AppPublic alloc] init];
        
        
    });
    return _singleManger;
}

- (instancetype)init {
    if (_singleManger) {
        return _singleManger;
    }
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark - getter
- (NSString *)appName {
    if (!_appName) {
        _appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    }
    
    return _appName;
}

#pragma mark - public
//检查该版本是否第一次使用
BOOL isFirstUsing() {
    //#if DEBUG
    //    NSString *key = @"CFBundleVersion";
    //#else
    NSString *key = @"CFBundleShortVersionString";
    //#endif
    
    // 1.当前版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    
    // 2.从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    // 3.写入本次版本号
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return ![version isEqualToString:saveVersion];
}

BOOL isMobilePhone(NSString *string) {
    if (!string || string.length == 0) {
        return NO;
    }
    
    NSMutableAttributedString *parsedOutput = [[NSMutableAttributedString alloc]initWithString:string attributes:nil];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^1\\d{10}$" options:0 error:nil];
    NSArray* matches = [regex matchesInString:[parsedOutput string]
                                      options:NSMatchingWithoutAnchoringBounds
                                        range:NSMakeRange(0, parsedOutput.length)];
    
    return matches.count > 0;
}

BOOL isEmailAdress(NSString *string) {
    if (!string || string.length == 0) {
        return NO;
    }
    
    //匹配Email地址
    NSMutableAttributedString *parsedOutput = [[NSMutableAttributedString alloc]initWithString:string attributes:nil];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*.\\w+([-.]\\w+)*" options:0 error:nil];
    NSArray* matches = [regex matchesInString:[parsedOutput string]
                                      options:NSMatchingWithoutAnchoringBounds
                                        range:NSMakeRange(0, parsedOutput.length)];
    
    return matches.count > 0;
}

NSString *sha1(NSString *string) {
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *outputStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [outputStr appendFormat:@"%02x", digest[i]];
    }
    
    return outputStr;
}

/*!
 @brief 替换空字符串
 */
NSString *notNilString(NSString *string) {
    return string.length ? string : @"";
}

/*!
 @brief 中文序数
 */
NSString *indexChineseString(NSUInteger index) {
    NSArray *array = @[@"零", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十"];
    if (index <= 10) {
        return array[index];
    }
    else if (index < 100) {
        NSUInteger single = index % 10;
        NSUInteger tens = (index - single) / 10;
        return [NSString stringWithFormat:@"%@十%@", indexChineseString(tens), single == 0 ? @"" : indexChineseString(single)];
    }
    else if (index == 100) {
        return @"一百";
    }
    
    return @"";
}

//图像压缩
NSData *dataOfImageCompression(UIImage *image, BOOL isHead) {
    //头像图片
    if (isHead) {
        //调整分辨率
        if (image.size.width > headImageSizeMax || image.size.height > headImageSizeMax) {
            //压缩图片
            CGSize newSize = CGSizeMake(image.size.width, image.size.height);
            
            CGFloat tempHeight = newSize.height / headImageSizeMax;
            CGFloat tempWidth = newSize.width / headImageSizeMax;
            
            if (tempWidth > 1.0 && tempWidth > tempHeight) {
                newSize = CGSizeMake(image.size.width / tempWidth, image.size.height / tempWidth);
            }
            else if (tempHeight > 1.0 && tempWidth < tempHeight){
                newSize = CGSizeMake(image.size.width / tempHeight, image.size.height / tempHeight);
            }
            
            UIGraphicsBeginImageContext(newSize);
            [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    
    //调整大小
    CGFloat scale = 1.0;
    NSData *imageData;
    
    do {
        if (imageData) {
            scale *= (imageDataMax / imageData.length);
        }
        imageData = UIImageJPEGRepresentation(image, scale);
    } while (imageData.length > imageDataMax);
    
    return imageData;
}

//生成视图
UIButton *NewBackButton(UIColor *color) {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *i = [UIImage imageNamed:@"navbar_icon_back"];
    if (color) {
        i = [i imageWithColor:color];
    }
    [btn setImage:i forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 64, 44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    return btn;
}

UIButton *NewRightButton(UIImage *image, UIColor *color) {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(screen_width - 64, 0, 64, 44)];
    if (color) {
        image = [image imageWithColor:color];
    }
    [btn setImage:image forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    return btn;
}

UIButton *NewTextButton(NSString *title, UIColor *textColor) {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(screen_width - 64, 0, 64, 44)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:appButtonTitleFontSize];
    return btn;
}

UILabel *NewLabel(CGRect frame, UIColor *textColor, UIFont *font, NSTextAlignment alignment) {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = textColor ? textColor : baseTextColor;
    label.font = font ? font : [AppPublic appFontOfSize:appLabelFontSize];
    label.textAlignment = alignment;
    return label;
}

UIView *NewSeparatorLine(CGRect frame) {
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = baseSeparatorColor;
    return lineView;
}

//日期-文本转换
NSDate *dateFromString(NSString *dateString, NSString *format) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    return destDate;
}

NSString *stringFromDate(NSDate *date, NSString *format) {
    if (!format) {
        format = defaultDateFormat;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

NSString *dateStringWithTimeString(NSString *string){
    NSDate *date = dateFromString(string, @"yyyy-MM-dd HH:mm:ss");
    if (date) {
        return stringFromDate(date, @"yyyy-MM-dd");
    }

    return string.length ? string : @"--";
}

//文本尺寸
+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantWidth:(CGFloat)width {
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = 0;
    
    NSStringDrawingOptions drawOptions = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attibutes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
    return [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:drawOptions attributes:attibutes context:nil].size;
}

+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantHeight:(CGFloat)height {
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = 0;
    
    NSStringDrawingOptions drawOptions = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attibutes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:drawOptions attributes:attibutes context:nil].size;
}

+ (void)adjustLabelWidth:(UILabel *)label {
    label.width = [AppPublic textSizeWithString:label.text font:label.font constantHeight:label.height].width;
}

+ (void)adjustLabelHeight:(UILabel *)label {
    label.height = [AppPublic textSizeWithString:label.text font:label.font constantWidth:label.width].height;
}

+ (CGFloat )systemFontOfPXSize:(CGFloat)pxSize {
    CGFloat pt = (pxSize / 96) * 72;
    return pt;
}

+ (UIFont *)appFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)appFontOfPxSize:(CGFloat)pxSize {
    return [UIFont systemFontOfSize:[AppPublic systemFontOfPXSize:pxSize]];
}

//切圆角
+ (void)roundCornerRadius:(UIView *)view {
    [AppPublic roundCornerRadius:view cornerRadius:0.5 * MAX(view.width, view.height)];
}

+ (void)roundCornerRadius:(UIView *)view cornerRadius:(CGFloat)radius {
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

//View转Image
+ (UIImage *)viewToImage:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [[UIScreen mainScreen] scale]);
// [TOP_VIEW.layer renderInContext:UIGraphicsGetCurrentContext()]; // 此方法，除却iOS8以外其他系统都OK
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

//顶部状态栏颜色
+ (void)changeStatusBarLightContent:(BOOL)isWhite {
    [[UIApplication sharedApplication] setStatusBarStyle:isWhite ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault];
}

//判断类是否有某属性
+ (BOOL)getVariableWithClass:(Class)myClass varName:(NSString *)name {
    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList(myClass, &outCount);
    for (i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        if ([keyName hasPrefix:@"_"]) {
            keyName = [keyName substringFromIndex:1];
        }
//        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if ([keyName isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

- (void)logout {
    [self goToLoginCompletion:^{
        [[UserPublic getInstance] clear];
    }];
}

- (void)loginDoneWithUserData:(NSDictionary *)data username:(NSString *)username password:(NSString *)password {
    if (!data || !username) {
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:username forKey:kUserName];
    
    [[UserPublic getInstance] saveUserData:[AppUserInfo mj_objectWithKeyValues:data]];
    [self goToMainVC];
}

- (void)goToMainVC {
    [UserPublic getInstance].mainTabNav = [[MainTabNavController alloc] initWithRootViewController:[MainTabBarController new]];
    [[UIApplication sharedApplication].delegate window].rootViewController = [UserPublic getInstance].mainTabNav;
}

- (void)goToLoginCompletion:(void (^)(void))completion {
    [[UIApplication sharedApplication].delegate window].rootViewController = [LoginViewController new];
    if (completion) {
        completion();
    }
}

@end
