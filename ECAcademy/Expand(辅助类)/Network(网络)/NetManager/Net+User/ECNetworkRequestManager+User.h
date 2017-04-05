//
//  ECNetworkRequestManager+User.h
//  ECDoctor
//
//  Created by linsen on 15/8/19.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECNetworkRequestManager.h"
#import "ECUser.h"

@class ECUser;
@interface ECNetworkRequestManager (User)

+ (NSString *)md5HexDigest:(NSString *)str;

/**
 *	@brief	忘记密码密码
 *
 *	@param 	mobile 	电话号码
 *	@param 	password 	新密码
 *	@param 	code 	验证码
 *	@param 	callback 	(^)(NSInteger code, NSString *msg, NSError *error, id object)
 *
 *	@return	<#return value description#>
 *
 *	Created by mac on 2015-12-22 17:24
 */
+ (BOOL)forgetUserPasswordWithMobile:(NSString *)mobile password:(NSString *)password code:(NSString *)code callback:(NetworkRequestCallback)callback;


/**
 *  获取手机验登录证码
 *
 *  @param mobileNO 手机号
 *  @param callback 回调
 *
 *  @return YES
 */
+ (BOOL)requestPhoneLoginCodeWithMobileNO:(NSString *)mobileNO callback:(NetworkRequestCallback)callback;

/**
 *	@brief	用户登录
 *
 *	@param 	user 	用户
 *	@param 	callback 	(^)(NSInteger code, NSString *msg, NSError *error, ECUser *returnObject)
 *
 *	@return bool
 *
 *	Created by mac on 2015-08-19 09:41
 */
+ (BOOL)loginWithUser:(ECUser *)user callback:(NetworkRequestCallback)callback;

+ (BOOL)silenceLoginWithUser:(ECUser *)user callback:(NetworkRequestCallback)callback;

/**
 *	@brief	用户登出
 *
 *	@param 	user 	用户
 *	@param 	callback 	(^)(NSInteger code, NSString *msg, NSError *error, nil)
 *
 *	@return	BOOL
 *
 *	Created by mac on 2015-08-19 15:04
 */
+ (BOOL)logOutWithUser:(ECUser *)user callback:(NetworkRequestCallback)callback;

/**
 *	@brief	修改、绑定手机号码提交
 *
 *	@param 	user 	用户
 *	@param 	code 	验证码
 *	@param 	callback 	(^)(NSInteger code, NSString *msg, NSError *error, id object)
 *
 *	@return	BOOL
 *
 *	Created by mac on 2015-10-16 17:03
 */
+ (BOOL)changePhoneNumSumbitWith:(ECUser *)user mobile:(NSString *)mobile code:(NSString *)code callback:(NetworkRequestCallback)callback;

/**
 *	@brief	绑定手机号码申请
 *
 *	@param 	user 	用户
 *	@param 	number 	电话号码
 *	@param 	callback 	(^)(NSInteger code, NSString *msg, NSError *error, id object)
 *
 *	@return	BOOL
 *
 *	Created by mac on 2015-08-19 15:35
 */
+ (BOOL)bindingCellPhoneApplyWith:(ECUser *)user number:(NSString *)number callback:(NetworkRequestCallback)callback;

/**
 *	@brief	绑定手机号码提交
 *
 *	@param 	user 	用户
 *	@param 	code 	验证码
 *	@param 	callback 	(^)(NSInteger code, NSString *msg, NSError *error, id object)
 *
 *	@return	BOOL
 *
 *	Created by mac on 2015-08-19 15:37
 */
+ (BOOL)bindingCellPhoneWith:(ECUser *)user code:(NSString *)code callback:(NetworkRequestCallback)callback;

/**
 *	@brief	解除绑定手机申请
 *
 *	@param 	user 	用户
 *	@param 	number 	电话号码
 *	@param 	callback 	(^)(NSInteger code, NSString *msg, NSError *error, id object)
 *
 *	Created by mac on 2015-08-19 15:49
 */
+ (BOOL)cancelBindingCellPhoneApplyWith:(ECUser *)user number:(NSString *)number callback:(NetworkRequestCallback)callback;

/**
 *	@brief	解除绑定手机提交
 *
 *	@param 	user 	用户
 *	@param 	code 	验证码
 *	@param 	callback 	(^)(NSInteger code, NSString *msg, NSError *error, id object)
 *
 *	@return	BOOL
 *
 *	Created by mac on 2015-08-19 15:49
 */
+ (BOOL)cancelBindingCellPhoneWith:(ECUser *)user code:(NSString *)code callback:(NetworkRequestCallback)callback;


/**
 绑定微信

 @param user     用户
 @param data     微信数据
 @param callback <#callback description#>

 @return <#return value description#>
 */
+ (BOOL)bindingWeChatWith:(ECUser *)user wechatData:(NSDictionary *)data callback:(NetworkRequestCallback)callback;

/**
 *	@brief	获取用户信息（医生、诊所、顾客）
 *
 *	@param 	userid 	用户id（医生、诊所、顾客）(required)
 *	@param 	callback 	(^)(NSInteger code, NSString *msg, NSError *error, ECDoctor/ECClinic/ECCustomer *object)
 *
 *	@return	BOOL
 *
 *	Created by mac on 2015-08-19 10:28
 */
+ (BOOL)getUserInfoWithUser:(ECUser *)user callback:(NetworkRequestCallback)callback;


+ (BOOL)alertUserInfoWith:(ECUser *)user alertData:(NSDictionary *)alerData callback:(NetworkRequestCallback)callback;


@end

@interface ECUser(ECNetworkRequestManager)
- (NSString *)getLoginParams;
@end
