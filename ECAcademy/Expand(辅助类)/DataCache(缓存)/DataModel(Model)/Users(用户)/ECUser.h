//
//  ECUser.h
//  ECDoctor
//
//  Created by linsen on 15/8/17.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECBaseObject.h"

typedef enum UserLoginType
{
    UserLoginTypeOfCommon = 0, /**< 飞熊用户登录、KQ88帐号登录 */
    UserLoginTypeOfKQ88, /**< 口腔88帐号登录 --废弃*/
    UserLoginTypeOfWeCat, /**< 微信帐号登录 */
    UserLoginTypeOfQRCode, /**< 二维码登录 */
    UserLoginTypeOfMobileVerification, /**< 手机验证登录 */
    UserLoginTypeOfDefault, /**< 默认登录 */
}UserLoginType;

@interface ECUser : ECBaseObject

/**
 *	@brief	是否已登录
 *
 *	Created by mac on 2015-08-17 16:45
 */
@property (nonatomic)BOOL isLogin;
/**
 *	@brief	用户登录类型
 *
 *	Created by mac on 2015-08-17 16:24
 */
@property (nonatomic)UserLoginType loginType;

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *uploadimage;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *mainip;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *session;
@property (nonatomic, copy) NSString *bindmobile;
@property (nonatomic, copy) NSString *loginUserName;
@property (nonatomic, copy) NSString *loginUserPassword;
@property (nonatomic, strong)NSDictionary *otherLoginData;//第三方登录信息
@property (nonatomic, copy)NSString *loginMobilePhone;//登录手机
@property (nonatomic, copy)NSString *loginMobilePhoneCode;//手机登录校验码



+ (instancetype)standardUser;

+ (void)setStandardUser:(ECUser *)user;

- (BOOL)saveUser:(BOOL)isStandardUser;//存储User, 传nil直接清空User

+ (instancetype)lastLoginUser;//获取最后登录用户




@end
