//
//  ECNetworkRequestManager.m
//  ECDoctor
//
//  Created by linsen on 15/8/18.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECNetworkRequestManager.h"
#import "ECUser.h"
#import "JSONKit.h"
#import "AFNetworking.h"
#import "NSString+ECExtensions.h"
#import "ECServerRequestFuncCode.h"

//获取本机ip地址用
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/utsname.h>

#define kTestServerHostKey @"ECNetworkTestServerHostKey"

@implementation ECNetworkRequestManager

singleton_implementation(ECNetworkRequestManager)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.m_uploadFileArray = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.m_operationManager = [AFHTTPSessionManager manager];
        // 设置请求格式
        self.m_operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置返回格式
        self.m_operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //开启https ssl验证
        [self.m_operationManager setSecurityPolicy:[ECNetworkRequestManager customSecurityPolicy]];
    }
    return self;
}

+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cer" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    if (certData)
    {
        securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    }
    return securityPolicy;
}

- (NSString *)getRequestUrlWithType:(RequestUrlWithType)type
{
    if (self.m_fsUploadUrlStr == nil)
    {
        self.m_fsUploadUrlStr = [NSString stringWithFormat:@"%@//image/upload.php", kServerHostStr];
    }
    if (self.m_imageUrlStr == nil)
    {
        self.m_imageUrlStr = [NSString stringWithFormat:@"%@/image", kServerHostStr];
    }
    if (self.m_normalUrlStr == nil)
    {
        self.m_normalUrlStr = [NSString stringWithFormat:@"%@/service11/func.php", kServerHostStr];
    }
    NSString *returnStr = nil;
    ECUser *user = [ECUser standardUser];
    switch (type) {
        case RequestUrlWithTypeNormal:
            returnStr = [NSString stringWithFormat:@"%@/service11/func.php", kServerHostStr];
            break;
        case RequestUrlWithTypeSilenceLogin:
            returnStr = [NSString stringWithFormat:@"%@/service11/func.php", kServerHostStr];
            break;
        case RequestUrlWithTypeImage:
            if (user && user.image.length > 0 && [user.image containsString:@"http://"])
            {
                returnStr = [NSString stringEmptyTransform:user.image];
            }
            else
            {
                returnStr = [NSString stringWithFormat:@"%@/image", kServerHostStr];
            }
            break;
        case RequestUrlWithTypeFSUpload:
        {
            if (user && user.image.length > 0 && [user.image containsString:@"http://"])
            {
                returnStr = [NSString stringWithFormat:@"%@/upload.php", user.image];
            }
            else
            {
                returnStr = [NSString stringWithFormat:@"%@//image/upload.php", kServerHostStr];
            }
        }
            break;
        case RequestUrlWithTypeImageUpload:
        {
            if (user && user.uploadimage.length > 0 && [user.uploadimage containsString:@"http://"])
            {
                returnStr = [NSString stringEmptyTransform:user.uploadimage];
            }
            else
            {
                returnStr = [NSString stringWithFormat:@"%@/image/upload_image.php", kServerHostStr];
            }
        }
            break;
        case RequestUrlWithTypeChat:
        case RequestUrlWithTypePolling:
            returnStr = [NSString stringWithFormat:@"%@/service11/func.php", kServerHostStr];
        default:
            break;
    }
    return returnStr;
}

- (NSTimeInterval)getRequestTimeoutIntervalWithType:(RequestUrlWithType)type
{
    NSTimeInterval timeInterval = 10.f;
    switch (type) {
        case RequestUrlWithTypeSilenceLogin:
            timeInterval = 5.0f;
            break;
        default:
            timeInterval = 15.f;
            break;
    }
    return timeInterval;
}


+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }

    freeifaddrs(interfaces);
    return address;
}

/*
 https://saas.dental360.cn:446/service11/func.php?param=[{%22params%22:{%22funcid%22:10}}]
 */
- (NSString *)getServerHostStr
{
    if (kIsTestServer)
    {
        if (self.m_configServerHostStr.length == 0)
        {
            self.m_configServerHostStr = [NSString stringEmptyTransform:[[NSUserDefaults standardUserDefaults] objectForKey:kTestServerHostKey]];
        }
        
        if (self.m_configServerHostStr.length > 0)
        {
            return self.m_configServerHostStr;
        }
        else
        {
            return @"https://115.28.139.39";
        }
    }
    else
    {
        ECUser *loginUser = [ECUser standardUser];
        if (loginUser && [loginUser.mainip isValid])
        {
            return [NSString stringWithFormat:@"https://%@:446",loginUser.mainip];
        }
        return @"https://saas.dental360.cn:446";
    }
    return @"";
}

- (NSString *)getTemporaryServerHostStr
{
    if (kIsTestServer)
    {
        if (self.m_configServerHostStr.length == 0)
        {
            self.m_configServerHostStr = [NSString stringEmptyTransform:[[NSUserDefaults standardUserDefaults] objectForKey:kTestServerHostKey]];
        }
        if (self.m_configServerHostStr.length > 0)
        {
            return self.m_configServerHostStr;
        }
        else
        {
            return @"http://115.28.139.39";
        }
    }
    else
    {
        ECUser *loginUser = [ECUser standardUser];
        if (loginUser&&[loginUser.mainip isValid]) {
            return [NSString stringWithFormat:@"http://%@",loginUser.mainip];
        }
        return @"http://115.29.37.174";
    }
    return @"";
}

+ (void)configServerHostStr:(NSString *)host
{
    if (host && [host isKindOfClass:[NSString class]] && host.length > 0)
    {
        host = [host stringByReplacingOccurrencesOfString:@" " withString:@""];
        host = [host stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        host = [host stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        host = [host lowercaseString];
        if (![host hasPrefix:@"https"])
        {
            host = [NSString stringWithFormat:@"https://%@", host];
        }
        [ECNetworkRequestManager sharedECNetworkRequestManager].m_configServerHostStr = host;
        [[NSUserDefaults standardUserDefaults] setObject:host forKey:kTestServerHostKey];
    }
}

- (void)GET:(NSString *)URLString
requestUrlType:(RequestUrlWithType)type
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    NSMutableDictionary *targetParam = [self appendCommonParam:paramDict];
    NSString *url = [self getRequestUrlWithType:type];
    if (url == nil)
    {
        url = URLString;
    }
    if (url.length > 0)
    {
        self.m_operationManager.requestSerializer.timeoutInterval = [self getRequestTimeoutIntervalWithType:type];

        [self.m_operationManager GET:url parameters:targetParam progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task, error);
            DLog(@"\nError:%@", error);

        }];
    }
    else
    {
        NSError *errort = [NSError errorWithDomain:@"请求地址为空" code:RequestErrorCodeUrlError userInfo:nil];
        failure(nil, errort);
    }
}

- (void)POST:(NSString *)URLString
requestUrlType:(RequestUrlWithType)type
  parameters:(NSDictionary *)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    NSMutableDictionary *targetParam = [self appendCommonParam:paramDict];
    NSString *url = [self getRequestUrlWithType:type];
    if (url == nil)
    {
        url = URLString;
    }
    if (url.length > 0)
    {
        if (type != RequestUrlWithTypePolling)
        {
            NSString *jsonStr = [NSString stringEmptyTransform:[targetParam objectForKey:@"param"]];
            DLog(@"\nRequest:%@\nBody:%@", url, jsonStr);
        }
        self.m_operationManager.requestSerializer.timeoutInterval = [self getRequestTimeoutIntervalWithType:type];
        [self.m_operationManager POST:url parameters:targetParam progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task,error);
        }];
    }
    else
    {
        NSError *errort = [NSError errorWithDomain:@"请求地址为空" code:RequestErrorCodeUrlError userInfo:nil];
        failure(nil, errort);
        DLog(@"\nError:%@", errort);
    }
}


- (void)uploadFileWithFileData:(NSData *)fileData
                      fileName:(NSString *)fileName
                      fileType:(NSString *)typeStr
                    parameters:(NSDictionary *)parameters
                      progress:(void (^)(NSProgress * uploadProgress))progress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *targetParam = [self appendCommonParam:parameters];
    
    if (![fileName isValid])
    {
        fileName = @"unkown";
    }
    if (![typeStr isValid])
    {
        typeStr = @"image/png";
    }
    
//    NSString *BOUNDARY = @"3da8368b-dcba-42b6-8933-3880c4c659a4";
    NSString *URLString = [self getRequestUrlWithType:RequestUrlWithTypeFSUpload];
    
    [self.m_operationManager POST:URLString parameters:targetParam constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:typeStr];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
    
}



#pragma mark --- 网络请求数据处理
- (void)responseDataHandleWithData:(NSData *)responseData code:(NSInteger *)code msg:(NSString **)msg records:(NSArray **)records
{
    [self responseDataHandleWithData:responseData code:code msg:msg records:records data:nil];
}

- (void)responseDataHandleWithData:(NSData *)responseData code:(NSInteger *)code msg:(NSString **)msg records:(NSArray **)records data:(NSDictionary **)data
{
    NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    if ([dataArr count] > 0)
    {
        NSDictionary *dataDic = [dataArr firstObject];
        NSInteger tcode = [[dataDic objectForKey:@"code"] integerValue];
        if (code != NULL)
        {
            *code = tcode;
        }
        NSString *tmsg = [dataDic objectForKey:@"info"];
        if (msg != NULL)
        {
            *msg = tmsg;
        }
        if (tcode == 1)
        {
            NSDictionary *tdata = [dataDic objectForKey:@"data"];
            if (data != NULL)
            {
                *data = tdata;
            }
            if (tdata && [tdata isKindOfClass:[NSDictionary class]])
            {
                NSArray *trecords = [tdata objectForKey:@"records"];
                if (trecords != NULL && records != NULL)
                {
                    *records = trecords;
                }
            }
        }
        else if (tcode == 2)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserSessionBeOverdueNotification object:nil];
        }
    }
}


- (void)responseDataHandleWithData:(NSData *)responseData code:(NSInteger *)code msg:(NSString **)msg data:(NSDictionary **)data
{
    [self responseDataHandleWithData:responseData code:code msg:msg records:nil data:data];
}

+ (BOOL)requestWithServer:(NSString *)serverUrl params:(NSDictionary *)params callback:(NetworkRequestCallback)callback
{
    [[ECNetworkRequestManager sharedECNetworkRequestManager].m_operationManager GET:serverUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) { 
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    return YES;
}


#pragma mark  ----- 公共参数拼接 以及格式化样式
//添加公共参数
- (NSMutableDictionary *)appendCommonParam:(NSDictionary *)data
{
    if (data && [data isKindOfClass:[NSDictionary class]] && [data allKeys] > 0)
    {
        NSMutableDictionary *nData = nil;
        NSMutableDictionary *submitParam = nil;
        nData = [NSMutableDictionary dictionaryWithDictionary:data];
        [nData setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"version"];
        [nData setValue:@"2" forKey:@"device"];
        NSArray *requestArr = nData?@[@{@"params":nData}]:@[@{@"params":data}];
        NSString *str = [requestArr JSONString];
        submitParam = [@{@"param":[NSString stringEmptyTransform:str]} mutableCopy];
        return submitParam;
    }
    return [@{} mutableCopy];
}




@end
