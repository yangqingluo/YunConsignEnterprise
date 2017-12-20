//
//  AppPublic.h
//
//  Created by yangqingluo on 16/9/9.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIImage+Color.h"
#import "UIViewController+HUD.h"
#import "AppType.h"
#import "MJExtension.h"
#import "QKNetworkSingleton.h"
#import "BlockAlertView.h"
#import "JXTAlertController.h"
#import "PublicMessageReadManager.h"

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

#define QKWEAKSELF typeof(self) __weak weakself = self;

#define RGBA(R, G, B, A) [UIColor colorWithRed:R / 255.f green:G / 255.f blue:B / 255.f alpha:A]

#define MainColor                    RGBA(0x00, 0xbc, 0xd4, 1.0)
#define AuxiliaryColor               RGBA(0x00, 0x97, 0xa7, 1.0)
#define baseSeparatorColor           RGBA(0xdb, 0xdb, 0xdb, 1.0)
#define baseSeparatorAlphaColor      RGBA(0xdb, 0xdb, 0xdb, 0.6)
#define EmphasizedColor              RGBA(0xec, 0xda, 0x60, 1.0)//强调色
#define WarningColor                 RGBA(0xc5, 0x2c, 0x2c, 1.0)//警告色
#define CellHeaderLightBlueColor     RGBA(0xf4, 0xfb, 0xfc, 1.0)//表格表头/列表标题背景色
#define baseFooterBarColor           RGBA(0xef, 0xef, 0xef, 1.0)

#define baseRedColor                 RGBA(0xd9, 0x55, 0x55, 1.0)
#define baseBlueColor                RGBA(0x00, 0x84, 0xff, 1.0)
#define lightWhiteColor              RGBA(0xf8, 0xf8, 0xf8, 1.0)
#define silverColor                  RGBA(0xc0, 0xc0, 0xc0, 1.0)
#define baseTextColor                RGBA(0x21, 0x21, 0x21, 1.0)
#define secondaryTextColor           RGBA(0x75, 0x75, 0x75, 1.0)

#define appGreenColor                RGBA(0x22, 0xb5, 0x89, 1.0)
#define appLightRedColor             RGBA(0xff, 0x8b, 0x74, 1.0)
#define appLightGreenColor           RGBA(0xa5, 0xd5, 0x32, 1.0)
#define appLightBlueColor            RGBA(0x3f, 0xcc, 0xe9, 1.0)
#define appDarkOrangeColor           RGBA(0xff, 0x8c, 0x00, 1.0)

#define STATUS_HEIGHT                20.0
#define STATUS_BAR_HEIGHT            64.0
#define TAB_BAR_HEIGHT               49.0
#define DEFAULT_BAR_HEIGHT           44.0

#define defaultDayTimeInterval       (1 * 24 * 60 * 60)//1天时间
#define appRefreshTime               24 * 60 * 60//自动刷新间隔时间
#define kButtonCornerRadius          4.0
#define kViewCornerRadius            4.0

#define kCellHeightSmall             32.0
#define kCellHeight                  44.0
#define kCellHeightFilter            50.0
#define kCellHeightMiddle            60.0
#define kCellHeightBig               80.0
#define kCellHeightHuge              100.0

#define imageDataMax                 100 * 1024//图像大小上限
#define headImageSizeMax             96//头像图像 宽/高 大小上限

#define appButtonTitleFontSizeSmall  14.0
#define appButtonTitleFontSize       16.0
#define appLabelFontSizeSmall        14.0
#define appLabelFontSize             16.0
#define appLabelFontSizeMiddle       18.0
#define appSeparaterLineSize         0.5//分割线尺寸
#define appPageSize                  10//获取分页数据时分页size

#define kEdgeSmall                   4.0
#define kEdge                        8.0
#define kEdgeMiddle                  12.0
#define kEdgeBig                     16.0
#define kEdgeHuge                    28.0

#define cellDetailLeft               (kEdgeMiddle + 60 + kEdge)
#define cellDetailRightWhenIndicator (screen_width - kEdgeHuge)

#define kPhoneNumberLength           0x0b
#define kVCodeNumberLength           0x06
#define kPasswordLengthMin           0x03
#define kPasswordLengthMax           0x10
#define kNameLengthMax               0x20
#define kNumberLengthMax             0x09
#define kPriceLengthMax              0x06
#define kInputLengthMax              0x30
#define kIDLengthMax                 0x12//18位身份证号码

#define NumberWithoutPoint           @"0123456789"
#define NumberWithPoint              @"0123456789."
#define NumberWithDash               @"0123456789-"

#define kUserName                    @"username_YunConsignEnterprise"
#define kUserData                    @"userdata_YunConsignEnterprise"
#define kUserZone                    @"userzone_YunConsignEnterprise"

#define defaultDateFormat            @"yyyy-MM-dd"
#define defaultHeadImageName         @"默认头像"
#define defaultNoticeNotComplete     @"精彩功能，敬请期待"
#define kNotification_WaybillListRefresh    @"kNotification_WaybillListRefresh"
#define kNotification_WaybillLogRefresh    @"kNotification_WaybillLogRefresh"
#define kNotification_WaybillLoadRefresh    @"kNotification_WaybillLoadRefresh"//配载装车更新
#define kNotification_TransportTruckSaveRefresh    @"kNotification_TransportTruckSaveRefresh"//派车更新
#define kNotification_WaybillArrivalRefresh    @"kNotification_WaybillArrivalRefresh"//到车更新
#define kNotification_WaybillReceiveRefresh    @"kNotification_WaybillReceiveRefresh"//自提更新
#define kNotification_CustomerManageRefresh    @"kNotification_CustomerManageRefresh"//客户管理更新
#define kNotification_CodWaitPayRefresh    @"kNotification_CodWaitPayRefresh"//代收款未收款更新
#define kNotification_CodLoanApplyRefresh    @"kNotification_CodLoanApplyRefresh"//放款申请更新
#define kNotification_CodLoanCheckRefresh    @"kNotification_CodLoanCheckRefresh"//放款审核更新
#define kNotification_CodRemitRefresh    @"kNotification_CodRemitRefresh"//代收款放款更新
#define kNotification_DailyReimbursementApplyRefresh    @"kNotification_DailyReimbursementApplyRefresh"//报销申请更新
#define kNotification_DailyReimbursementCheckRefresh    @"kNotification_DailyReimbursementCheckRefresh"//报销审核更新

#define key_ServicePackage  @"ServicePackage"
#define key_ServiceGood     @"ServiceGood"

typedef enum : NSUInteger {
    PowerType_CustomerManagement = 1,
    PowerType_OrderManagement    = 4,
    PowerType_FollowUpRecord     = 0,
} PowerType;

typedef void(^DoneBlock)(id object);

@interface AppPublic : NSObject

//应用名称
@property (strong, nonatomic) NSString *appName;

//分区选择
@property (strong, nonatomic) NSArray *urlZoneArray;
@property (strong, nonatomic) AppDataDictionary *selectedURLZone;

+ (AppPublic *)getInstance;

/*!
 @brief 检查版本是否第一次使用
 */
BOOL isFirstUsing();

/*!
 @brief 检查字符串是否是手机号码
 */
BOOL isMobilePhone(NSString *string);

/*!
 @brief 检查字符串是否是邮件地址
 */
BOOL isEmailAdress(NSString *string);

/*!
 @brief sha1加密
 */
NSString *sha1(NSString *string);

/*!
 @brief 替换空字符串
 */
NSString *notNilString(NSString *string, NSString *placeString);
/*!
 @brief 替换小数点后0字符串
 */
NSString *notShowFooterZeroString(NSString *string, NSString *placeString);

/*!
 @brief 字典转中文字符串
 */
+ (NSString *)logDic:(NSDictionary *)dic;

/*!
 @brief 中文序数
 */
NSString *indexChineseString(NSUInteger index);

/*!
 @brief 布尔值转服务器需要的字符
 */
NSString *boolString(BOOL yn);

//判断是否是全数字
BOOL stringIsNumberString(NSString *string, BOOL withPoint);

//图像压缩
NSData *dataOfImageCompression(UIImage *image, BOOL isHead);

//生成视图
UIButton *NewBackButton(UIColor *color);
UIButton *NewRightButton(UIImage *image, UIColor *color);
UIButton *NewTextButton(NSString *title, UIColor *textColor);
UILabel *NewLabel(CGRect frame, UIColor *textColor, UIFont *font, NSTextAlignment alignment);
UIView *NewSeparatorLine(CGRect frame);

//日期-文本转换
NSDate *dateFromString(NSString *dateString, NSString *format);
NSString *stringFromDate(NSDate *date, NSString *format);
NSString *dateStringWithTimeString(NSString *string);
NSDate *dateWithPriousorLaterDate(NSDate *date, int month);

//文本尺寸
+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantWidth:(CGFloat)width;
+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantHeight:(CGFloat)height;
+ (void)adjustLabelWidth:(UILabel *)label;
+ (void)adjustLabelHeight:(UILabel *)label;
+ (UIFont *)appFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldAppFontOfSize:(CGFloat)fontSize;
+ (UIFont *)appFontOfPxSize:(CGFloat)pxSize;

//切圆角
+ (void)roundCornerRadius:(UIView *)view;
+ (void)roundCornerRadius:(UIView *)view cornerRadius:(CGFloat)radius;

//View转Image
+ (UIImage *)viewToImage:(UIView *)view;

//顶部状态栏颜色
+ (void)changeStatusBarLightContent:(BOOL)isWhite;

//判断类是否有某属性
+ (BOOL)getVariableWithClass:(Class)myClass varName:(NSString *)name;
+ (Class)getVariableClassWithClass:(Class)myClass varName:(NSString *)name;
+ (BOOL)getVariableWithClass:(Class)myClass subClass:(Class)subClass varName:(NSString *)name;

- (void)logout;
- (void)loginDoneWithUserData:(NSDictionary *)data username:(NSString *)username password:(NSString *)password;

- (void)goToMainVC;
- (void)goToLoginCompletion:(void (^)(void))completion;

- (void)saveURLZoneWithData:(AppDataDictionary *)data;

@end
