//
//  QKNetworkSingleton.h
//
//  Created by yangqingluo on 2017/5/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define appUrlAddress      ([AppPublic getInstance].selectedServer[@"server_addr"])
#define APP_HTTP_SUCCESS	             	1	//成功

typedef void(^QKNetworkBlock)(id responseBody, NSError *error);
typedef void(^Progress)(float progress);

@interface QKNetworkSingleton : NSObject

BOOL isHttpSuccess(int state);
NSString *httpRespString(NSError *error, NSObject *object);
NSString *urlStringWithService(NSString *service);
NSString *imageUrlStringWithImagePath(NSString *path);
NSURL *imageURLWithPath(NSString *path);


+ (QKNetworkSingleton *)sharedManager;

//Get
- (void)Get:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLString:(NSString *)urlString completion:(QKNetworkBlock)completion;
- (void)Get:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion;

//Post
- (void)Post:(id)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion;

- (void)Post:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block completion:(QKNetworkBlock)completion;

//Put
- (void)Put:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion;

//Delete
- (void)Delete:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion;

//通用SoapPost
- (void)commonSoapPost:(NSString *)funcId Parm:(NSDictionary *)parm completion:(QKNetworkBlock)completion;
- (void)commonSoapPost:(NSString *)funcId Parm:(NSDictionary *)parm URLFooter:(NSString *)urlFooter completion:(QKNetworkBlock)completion ;

//download
- (BOOL)downLoadFileWithOperations:(NSDictionary *)operations withSavaPath:(NSString *)savePath withUrlString:(NSString *)urlString completion:(QKNetworkBlock)completion withDownLoadProgress:(Progress)progress;

//上传一组图片
- (void)pushImages:(NSArray *)imageDataArray Parameters:(NSDictionary *)parameters URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion withUpLoadProgress:(Progress)progress;

//login
- (void)loginWithID:(NSString *)username Password:(NSString *)password  completion:(QKNetworkBlock)completion;
//获取当前用户信息
- (void)getCurrentUserInfoCompletion:(QKNetworkBlock)completion;
//获取保价费率
- (void)getInsuranceFeeRateByJoinIdCompletion:(QKNetworkBlock)completion;

@end
