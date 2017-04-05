//
//  ECNetworkRequestManager+User.m
//  ECDoctor
//
//  Created by linsen on 15/8/19.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECNetworkRequestManager+User.h"
#import "FMDatabase.h"
#import "ECUser.h"
#import "ECServerRequestFuncCode.h"
#import "ECDataBaseManager+Read.h"
#import "ECDataBaseManager+Write.h"
#import "AppDelegate.h"
#define kIsBindedBpush @"isBindedBpush"
#import "MJExtension.h"


@implementation ECUser(ECNetworkRequestManager)

- (NSString *)getLoginParams
{
    if (self)
    {
        NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        if (versionStr == nil)
        {
            versionStr = @"0";
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:versionStr, @"version", @"2",@"device", nil];
        if (self.userid && self.userid.length > 0)
        {
            [dict setObject:FUNC_ID_CUSTOMER_LOGIN_DEFAULT forKey:@"funcid"];
            [dict setObject:[NSString stringEmptyTransform:self.userid] forKey:@"userid"];
            [dict setObject:[NSString stringEmptyTransform:self.session] forKey:@"session"];
            [dict setObject:[NSString stringEmptyTransform:self.password] forKey:@"password"];
        }
        else
        {
            switch (self.loginType) {
                case UserLoginTypeOfWeCat:
                {}
                    break;
                case UserLoginTypeOfQRCode:
                {}
                    break;
                case UserLoginTypeOfMobileVerification:
                {}
                    break;
                    
                default:
                {
                    //[dict setObject:@"3" forKey:@"role"];
                    [dict setObject:FUNC_ID_DOC_LOGIN_USERNAME forKey:@"funcid"];
                    [dict setObject:[NSString stringEmptyTransform:self.loginUserName] forKey:@"username"];
                    NSString *passWord = [NSString stringEmptyTransform:self.loginUserPassword];
                    [dict setObject:passWord forKey:@"passwordkq88"];
                    if (passWord.length > 0)
                    {
                        [dict setObject:[NSString stringEmptyTransform:[ECNetworkRequestManager md5HexDigest:passWord]] forKey:@"password"];
                    }
                    else
                    {
                        [dict setObject:@"" forKey:@"password"];
                    }
                }
                    break;
            }
        }
        NSArray *requestArr = @[@{@"params":dict}];
        NSString *str = [requestArr JSONString];
        return str;
    }
    return nil;
}

@end

@implementation ECNetworkRequestManager (User)

+ (NSString *)md5HexDigest:(NSString*)str{
    const char *original_str = [str UTF8String];
    unsigned char result[16];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    return mdfiveString;
}

+ (BOOL)changePhoneNumApplyWith:(ECUser *)user number:(NSString *)number callback:(NetworkRequestCallback)callback
{
    if (user && [user isKindOfClass:[ECUser class]] && number)
    {}
    else
    {
        callback(RequestErrorCodeParametersError, @"参数有误", nil, nil);
    }
    return YES;
}

+ (BOOL)changePhoneNumSumbitWith:(ECUser *)user mobile:(NSString *)mobile code:(NSString *)code callback:(NetworkRequestCallback)callback
{
    if (user && [user isKindOfClass:[ECUser class]] && code && mobile)
    {}
    else
    {
        callback(RequestErrorCodeParametersError, @"参数有误", nil, nil);
    }
    return YES;
}

+ (BOOL)bindingCellPhoneApplyWith:(ECUser *)user number:(NSString *)number callback:(NetworkRequestCallback)callback
{
    if (user && [user isKindOfClass:[ECUser class]] && number)
    {}
    else
    {
        callback(RequestErrorCodeParametersError, @"参数有误", nil, nil);
    }
    return YES;
}

+ (BOOL)bindingCellPhoneWith:(ECUser *)user code:(NSString *)code callback:(NetworkRequestCallback)callback
{
    if (user && [user isKindOfClass:[ECUser class]] && code)
    {}
    else
    {
        callback(RequestErrorCodeParametersError, @"参数有误", nil, nil);
    }
    return YES;
}

+ (BOOL)cancelBindingCellPhoneApplyWith:(ECUser *)user number:(NSString *)number callback:(NetworkRequestCallback)callback
{
    if (user && [user isKindOfClass:[ECUser class]] && number)
    {}
    else
    {
        callback(RequestErrorCodeParametersError, @"参数有误", nil, nil);
    }
    return YES;
}

+ (BOOL)cancelBindingCellPhoneWith:(ECUser *)user code:(NSString *)code callback:(NetworkRequestCallback)callback
{
    if (user && [user isKindOfClass:[ECUser class]] && code)
    {}
    else
    {
        callback(RequestErrorCodeParametersError, @"参数有误", nil, nil);
    }
    return YES;
}

+ (BOOL)bindingWeChatWith:(ECUser *)user wechatData:(NSDictionary *)data callback:(NetworkRequestCallback)callback
{
    if (user && [user isKindOfClass:[ECUser class]] && data && [[data objectForKey:@"unionid"] length] > 0)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString *m_strOpenID = [data objectForKey:@"unionid"];
        [dict setObject:[NSString stringEmptyTransform:m_strOpenID] forKey:@"openid"];
        
        NSString *sex = [NSString stringEmptyTransform:[data objectForKey:@"sex"]];
        if (sex.length > 0)
        {
            [dict setObject:sex forKey:@"sex"];
        }
        
        NSString *picture = [NSString stringEmptyTransform:[data objectForKey:@"headimgurl"]];
        if (picture.length > 0)
        {
            [dict setObject:picture forKey:@"picture"];
        }
        
        NSString *nickname = [NSString stringEmptyTransform:[data objectForKey:@"nickname"]];
        if (nickname.length > 0)
        {
            [dict setObject:nickname forKey:@"nickname"];
        }
    }
    else
    {
        callback(RequestErrorCodeParametersError, @"参数有误", nil, nil);
    }
    return YES;
}

+ (BOOL)getUserInfoWithUser:(ECUser *)user callback:(NetworkRequestCallback)callback
{
    if (user && [user isKindOfClass:[ECUser class]])
    {}
    else
    {
        callback(RequestErrorCodeParametersError, @"参数有误", nil, nil);
    }
    return YES;
}

+ (BOOL)alertUserInfoWith:(ECUser *)user alertData:(NSDictionary *)alerData callback:(NetworkRequestCallback)callback
{
    if (user && [user isKindOfClass:[ECUser class]])
    {}
    else
    {
        callback(RequestErrorCodeParametersError, @"参数有误", nil, nil);
    }
    return YES;
}

+ (BOOL)getClinicsWithUser:(ECUser *)user callback:(NetworkRequestCallback)callback
{
    if (user && [user isKindOfClass:[ECUser class]])
    {}
    else
    {
        callback(RequestErrorCodeParametersError, @"参数有误", nil, nil);
    }
    return YES;
}

+ (BOOL)relationClinicWithUser:(ECUser *)user clinicQRCord:(NSString *)qrcode  callback:(NetworkRequestCallback)callback
{
    if (user && [user isKindOfClass:[ECUser class]])
    {}
    else
    {
        callback(RequestErrorCodeParametersError, @"参数有误", nil, nil);
    }
    return YES;
}

@end
