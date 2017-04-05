//
//  ECNetworkRequestManager.h
//  ECDoctor
//
//  Created by linsen on 15/8/18.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef kTestServer
#define kIsTestServer   1  //测试
#else
#define kIsTestServer   0  //发布
#endif
#define kServerHostStr [[ECNetworkRequestManager sharedECNetworkRequestManager] getServerHostStr]


#define kFunctionUrlStr @"service11/func.php"

typedef enum RequestErrorCode
{
    RequestErrorCodeUnLogin = -5,
    RequestErrorCodeNetworkError = -4,
    RequestErrorCodeUrlError = -3,
    RequestErrorCodeParametersError = -2,
    RequestErrorCodeTimeout = -1,
    RequestErrorCodeFailure = 0,
    RequestErrorCodeSuccess = 1,
}RequestErrorCode;

typedef enum RequestUrlWithType
{
    RequestUrlWithTypeNormal = 0,
    RequestUrlWithTypeFSUpload,
    RequestUrlWithTypeImageUpload,
    RequestUrlWithTypeImage,
    RequestUrlWithTypeChat,
    RequestUrlWithTypePolling,
    RequestUrlWithTypeSilenceLogin,
    RequestUrlWithTypeOther
}RequestUrlWithType;

@class ECUser;
@class AFHTTPSessionManager,NSURLSessionDataTask;
typedef void(^NetworkRequestCallback)(NSInteger code, NSString *msg, NSError *error, id returnObject);
@interface ECNetworkRequestManager : NSObject

@property (nonatomic, strong)AFHTTPSessionManager *m_operationManager;
@property (nonatomic, copy)NSString *m_fsUploadUrlStr;
@property (nonatomic, copy)NSString *m_imageUrlStr;
@property (nonatomic, copy)NSString *m_normalUrlStr;
@property (nonatomic, strong)NSMutableDictionary *m_uploadFileArray;
@property (nonatomic, copy)NSString *m_configServerHostStr;
singleton_interface(ECNetworkRequestManager)

+ (NSString *)getIPAddress;

- (NSString *)getRequestUrlWithType:(RequestUrlWithType)type;

- (NSTimeInterval)getRequestTimeoutIntervalWithType:(RequestUrlWithType)type;

- (NSString *)getServerHostStr;

+ (void)configServerHostStr:(NSString *)host;


/**
 *	@brief	GET网络请求
 *
 *	@param 	URLString 	URLString description
 *	@param 	type 	<#type description#>
 *	@param 	parameters 	parameters description
 *	Created by mac on 2015-08-25 17:02
 */
- (void)GET:(NSString *)URLString
requestUrlType:(RequestUrlWithType)type
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *	@brief	POST网络请求
 *
 *	@param 	URLString 	URLString description
 *	@param 	type 	type description
 *	@param 	parameters 	parameters description
 
 */
- (void)POST:(NSString *)URLString
requestUrlType:(RequestUrlWithType)type
  parameters:(NSDictionary *)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *	@brief	上传文件
 *
 *	@param 	fileData 	文件
 *	@param 	fileName 	文件名
 *	@param 	typeStr 	类型
 *	@param 	parameters 	参数
 *
 *
 *	Created by mac on 2015-09-09 09:53
 */
- (void)uploadFileWithFileData:(NSData *)fileData
                      fileName:(NSString *)fileName
                      fileType:(NSString *)typeStr
                    parameters:(NSDictionary *)parameters
                      progress:(void (^)(NSProgress * uploadProgress))progress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



/**
 *	@brief	网络请求数据解析
 *
 *	@param 	responseData 	原始数据
 *	@param 	code 	返回Code
 *	@param 	msg 	返回 描述信息
 *	@param 	records 	返回数据
 *	@param 	data 	返回数据
 *
 *	Created by mac on 2015-09-26 14:40
 */
- (void)responseDataHandleWithData:(NSData *)responseData code:(NSInteger *)code msg:(NSString **)msg records:(NSArray **)records data:(NSDictionary **)data;

/**
 *	@brief	网络请求数据解析
 *
 *	@param 	responseData 	原始数据
 *	@param 	code 	返回Code
 *	@param 	msg 	返回 描述信息
 *	@param 	records 	返回数据
 *
 *	Created by mac on 2015-08-25 17:02
 */
- (void)responseDataHandleWithData:(NSData *)responseData code:(NSInteger *)code msg:(NSString **)msg records:(NSArray **)records;

/**
 *	@brief	网络请求数据解析
 *
 *	@param 	responseData 	原始数据
 *	@param 	code 	返回Code
 *	@param 	msg 	返回 描述信息
 *	@param 	data 	返回数据
 *
 *	Created by mac on 2015-08-27 17:42
 */
- (void)responseDataHandleWithData:(NSData *)responseData code:(NSInteger *)code msg:(NSString **)msg data:(NSDictionary **)data;

/**
 *	@brief	网络请求
 *
 *	@param 	serverUrl 	服务器url
 *	@param 	params 	参数
 *	@param 	callback 	(^)(NSInteger code, NSString *msg, NSError *error, @{“ver1”:1,“ver2”:1,“ver3”:0,“ver4”:0,“url”:”url”,“verific”:””,“note”:”text”})
 *
 *	@return	BOOL
 *
 *	Created by mac on 2015-08-19 16:58
 */
+ (BOOL)requestWithServer:(NSString *)serverUrl params:(NSDictionary *)params callback:(NetworkRequestCallback)callback;





@end
