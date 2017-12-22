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

- (NSArray *)urlZoneArray {
    if (!_urlZoneArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"url_zone" ofType:@"txt"];
        if (path) {
            NSArray *keyValuesArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:nil];
            _urlZoneArray = [AppDataDictionary mj_objectArrayWithKeyValuesArray:keyValuesArray];
        }
    }
    return _urlZoneArray;
}

- (AppDataDictionary *)selectedURLZone {
    if (!_selectedURLZone) {
        NSDictionary *m_dic = [[NSUserDefaults standardUserDefaults] objectForKey:kUserZone];
        if (m_dic) {
            _selectedURLZone = [AppDataDictionary mj_objectWithKeyValues:m_dic];
        }
        else {
            _selectedURLZone = self.urlZoneArray[0];
        }
    }
//    NSLog(@"%@", _selectedURLZone.item_val);
    return _selectedURLZone;
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
NSString *notNilString(NSString *string, NSString *placeString) {
    return string.length ? string : (placeString ? placeString : @"");
}

NSString *notShowFooterZeroString(NSString *string, NSString *placeString) {
    NSArray *m_array = [string componentsSeparatedByString:@"."];
    if (m_array.count == 2) {
        NSString *m_string = m_array[1];
        m_string = [m_string stringByReplacingOccurrencesOfString:@"0" withString:@""];
        if (m_string.length == 0) {
            return m_array[0];
        }
    }
    return string.length ? string : (placeString ? placeString : @"");
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
+ (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 = [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                                      withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if (!str) {
        str = tempStr3;
    }
    return str;
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

/*!
 @brief 布尔值转服务器需要的字符
 */
NSString *boolString(BOOL yn) {
    return yn ? @"1" : @"2";
}

//判断是否是全数字
BOOL stringIsNumberString(NSString *string, BOOL withPoint) {
    NSCharacterSet *notNumber=[[NSCharacterSet characterSetWithCharactersInString:withPoint ? NumberWithPoint : NumberWithoutPoint] invertedSet];
    NSString *string1 = [[string componentsSeparatedByCharactersInSet:notNumber] componentsJoinedByString:@""];
    return [string isEqualToString:string1];
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

NSDate *dateWithPriousorLaterDate(NSDate *date, int month) {
    //正数是以后n个月，负数是前n个月；
    NSDateComponents *comps = [NSDateComponents new];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
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
    label.width = ceil([AppPublic textSizeWithString:label.text font:label.font constantHeight:label.height].width);//根据苹果官方文档介绍，计算出来的值比实际需要的值略小，故需要对其向上取整，这样子获取的高度才是我们所需要的。
    //可能存在计算时并未添加到superView的情况，因为去掉
//    if (label.width > label.superview.width) {
//        label.width = label.superview.width;
//    }
}

+ (void)adjustLabelHeight:(UILabel *)label {
    label.height = ceil([AppPublic textSizeWithString:label.text font:label.font constantWidth:label.width].height);
}

+ (CGFloat )systemFontOfPXSize:(CGFloat)pxSize {
    CGFloat pt = (pxSize / 96) * 72;
    return pt;
}

+ (UIFont *)appFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)boldAppFontOfSize:(CGFloat)fontSize {
    return [UIFont boldSystemFontOfSize:fontSize];
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
    //Ivar得到的属性名称会有"_"前缀
//    Ivar *ivars = class_copyIvarList(myClass, &outCount);
//    for (i = 0; i < outCount; i++) {
//        Ivar property = ivars[i];
//        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
//        if ([keyName hasPrefix:@"_"]) {
//            keyName = [keyName substringFromIndex:1];
//        }
////        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
//        if ([keyName isEqualToString:name]) {
//            return YES;
//        }
//    }
    objc_property_t* props = class_copyPropertyList(myClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = props[i];
        NSString *keyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if ([keyName isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

+ (Class)getVariableClassWithClass:(Class)myClass varName:(NSString *)varName {
    Class varClass = nil;
//    BOOL yn = NO;
    unsigned int count;
    objc_property_t* props = class_copyPropertyList(myClass, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = props[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if (![propertyName isEqualToString:varName]) {
            continue;
        }
        const char *type = property_getAttributes(property);
        //        NSString *attr = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        NSString * typeString = [NSString stringWithUTF8String:type];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        //        NSString * propertyType = [typeAttribute substringFromIndex:1];
        //        const char * rawPropertyType = [propertyType UTF8String];
        
        //        if (strcmp(rawPropertyType, @encode(float)) == 0) {
        //            //it's a float
        //        } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
        //            //it's an int
        //        } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
        //            //it's some sort of object
        //        } else {
        //            // According to Apples Documentation you can determine the corresponding encoding values
        //        }
        
        if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
            NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length] - 4)];  //turns @"NSDate" into NSDate
            varClass = NSClassFromString(typeClassName);
        }
    }
    free(props);
    return varClass;
}

+ (BOOL)getVariableWithClass:(Class)myClass subClass:(Class)subClass varName:(NSString *)varName {
    return [[self getVariableClassWithClass:myClass varName:varName] isSubclassOfClass:subClass];
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

- (void)saveURLZoneWithData:(AppDataDictionary *)data {
    if (!data) {
        return;
    }
    _selectedURLZone = [data copy];
    [[NSUserDefaults standardUserDefaults] setObject:[_selectedURLZone mj_keyValues] forKey:kUserZone];
}

- (void)clearURLZone {
    _selectedURLZone = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserZone];
}

@end
