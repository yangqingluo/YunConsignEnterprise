//
//  QKNetworkSingleton.m
//
//  Created by yangqingluo on 2017/5/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "QKNetworkSingleton.h"
#import "NSData+HTTPRequest.h"

@implementation QKNetworkSingleton

+ (QKNetworkSingleton *)sharedManager{
    static QKNetworkSingleton *sharedQKNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedQKNetworkSingleton = [[self alloc] init];
    });
    return sharedQKNetworkSingleton;
}

- (AFHTTPSessionManager *)baseHttpRequestWithParm:(NSDictionary *)parm andSuffix:(NSString *)suffix{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:20];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    for (NSString *key in parm.allKeys) {
        if (parm[key]) {
            [manager.requestSerializer setValue:parm[key] forHTTPHeaderField:key];
        }
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    
    return manager;
}

NSString *urlStringWithService(NSString *service){
    return [NSString stringWithFormat:@"%@%@", appUrlAddress, service];
}


NSString *generateUuidString(){
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

#pragma public
BOOL isHttpSuccess(int state){
    return state == APP_HTTP_SUCCESS;
}

NSString *httpRespString(NSError *error, NSObject *object){
    if (error) {
        return @"网络出错";
    }
    
    NSString *noticeString = @"出错";
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        int state = [[(NSDictionary *)object objectForKey:@"State"] intValue];
        
        switch (state) {
            case APP_HTTP_SUCCESS:{
                noticeString = @"成功";
                
            }
                
            default:{
                noticeString = [NSString stringWithFormat:@"状态码: %d",state];
            }
                break;
        }
        
    }
    
    return noticeString;
}

//Get
- (void)Get:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion{
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm andSuffix:urlString];
    NSString *urlStr = [urlStringWithService(urlString) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    QKWEAKSELF;
    [manager GET:urlStr parameters:userInfo progress:^(NSProgress * _Nonnull Progress){
        
    } success:^(NSURLSessionDataTask *task, id responseObject){
        [weakself doResponseCompletion:responseObject block:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        [weakself doResponseCompletion:nil block:completion];
    }];
}
//Post
- (void)Post:(id)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion{
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm andSuffix:urlString];
    NSString *urlStr = [urlStringWithService(urlString) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo progress:^(NSProgress * _Nonnull progress){
        
    } success:^(NSURLSessionDataTask *task, id responseObject){
        completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        completion(nil, error);
    }];
}

- (void)Post:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block completion:(QKNetworkBlock)completion{
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm andSuffix:urlString];
    NSString *urlStr = [urlStringWithService(urlString) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:urlStr parameters:userInfo constructingBodyWithBlock:block progress:^(NSProgress * _Nonnull Progress){
        
    } success:^(NSURLSessionDataTask *task, id responseObject){
        completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        completion(nil, error);
    }];
}

//Put
- (void)Put:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion{
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm andSuffix:urlString];
    NSString *urlStr = [urlStringWithService(urlString) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager PUT:urlStr parameters:userInfo success:^(NSURLSessionDataTask *task, id responseObject){
        completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        completion(nil, error);
    }];
}

//Delete
- (void)Delete:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion{
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm andSuffix:urlString];
    NSString *urlStr = [urlStringWithService(urlString) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager DELETE:urlStr parameters:userInfo success:^(NSURLSessionDataTask *task, id responseObject){
        completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        completion(nil, error);
    }];
}

//download
- (BOOL)downLoadFileWithOperations:(NSDictionary *)operations withSavaPath:(NSString *)savePath withUrlString:(NSString *)urlString completion:(QKNetworkBlock)completion withDownLoadProgress:(Progress)progress{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:savePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completion(nil, error);
    }];
    
    [task resume];
    if (task) {
        return YES;
    }
    else{
        return NO;
    }
}

//上传一组图片
- (void)pushImages:(NSArray *)imageDataArray Parameters:(NSDictionary *)parameters URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion withUpLoadProgress:(Progress)progress{
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:nil andSuffix:urlString];
    NSString *urlStr = [urlStringWithService(urlString) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSData *imageData in imageDataArray) {
            NSString *imageExtension = [imageData getImageType];
            NSString *fileName = [NSString stringWithFormat:@"%@.%@",generateUuidString(),imageExtension];
            
            /*
             此方法参数
             1. 要上传的[二进制数据]
             2. 对应网站上[upload.php中]处理文件的[字段"file"]
             3. 要保存在服务器上的[文件名]
             4. 上传文件的[mimeType]
             */
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:[NSString stringWithFormat:@"image/%@",imageExtension]];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress){
        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask *task, id responseObject){
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        completion(nil, error);
    }];
}

- (void)commonSoapPost:(NSString *)funcId Parm:(NSDictionary *)parm completion:(QKNetworkBlock)completion{
    if (!funcId.length) {
        return;
    }
    
    NSString *urlFooter = @"/common/data.do";
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm andSuffix:urlFooter];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableString *xmlString = [NSMutableString stringWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"];
    [xmlString appendString:@"<requests>\n"];
    [xmlString appendString:@"<global>\n"];
    [xmlString appendFormat:@"<token>%@</token>\n", @"8614237952724297FF208865F949185F5C35F2973ABC361F5737A18714625BDF8A94D99A4B021AF7"];
    [xmlString appendString:@"</global>\n"];
    [xmlString appendString:@"<request>\n"];
    [xmlString appendFormat:@"<funcId>%@</funcId>\n", funcId];
    for (NSString *key in parm) {
        [xmlString appendFormat:@"<%@><![CDATA[%@]]></%@>\n", key, parm[key], key];
    }
    [xmlString appendString:@"</request>\n"];
    [xmlString appendString:@"</requests>"];
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error)
     {
         return xmlString;
     }];
    
    NSString *urlStr = [urlStringWithService(urlFooter) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:@{} progress:^(NSProgress * _Nonnull progress){
        
    } success:^(NSURLSessionDataTask *task, id responseObject){
        completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        completion(nil, error);
    }];
}

//login
- (void)loginWithID:(NSString *)username Password:(NSString *)password completion:(QKNetworkBlock)completion {
    NSDictionary *m_dic = @{@"login_code" : username, @"login_pass" : password, @"login_type" : @3};//登录方式：1安卓手机、2安卓平板、3苹果手机、4苹果平板、5电脑
    [self Get:m_dic HeadParm:nil URLFooter:@"/login/login.do" completion:^(id responseBody, NSError *error){
        if (!error) {
            [[AppPublic getInstance] loginDoneWithUserData:responseBody username:username password:password];
        }
        completion(responseBody, error);
    }];
}

#pragma mark - private
- (BOOL)occuredRemoteLogin:(id)object {
    
    
    return NO;
}

- (void)doResponseCompletion:(id)responseBody block:(QKNetworkBlock)completion {
    NSString *message = @"出错";
    NSInteger code = 0;
    id completionObject = nil;
    if (!responseBody) {
        message = @"网络出错";
    }
    else if ([responseBody isKindOfClass:[NSData class]]) {
        message = @"数据出错";
        id responseObject = nil;
        NSError *serializationError = nil;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseBody options:NSJSONReadingAllowFragments error:&serializationError];
        if (!serializationError && [responseObject isKindOfClass:[NSDictionary class]]) {
            AppResponse *appResponse = [AppResponse mj_objectWithKeyValues:responseBody];
            code = appResponse.global.flag;
            message = appResponse.global.message.length ? appResponse.global.message : [NSString stringWithFormat:@"未知错误码:%d", (int)code];
            if (code == 1) {
                completionObject = @{};
                if (appResponse.responses.count > 0) {
                    ResponseItem *item = appResponse.responses[0];
                    if (item.items.count > 0) {
                        completionObject = item.items[0];
                    }
                }
            }
        }
    }
    
    if (completionObject) {
        completion(completionObject, nil);
    }
    else {
        completion(nil, [NSError errorWithDomain:@"tms.yunlaila.com.cn" code:code userInfo:@{@"message" : message}]);
    }
}

@end
