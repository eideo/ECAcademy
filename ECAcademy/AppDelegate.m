//
//  AppDelegate.m
//  ECAcademy
//
//  Created by Sophist on 2017/3/23.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "AppDelegate.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ECPlatformShareManager.h"
#import "IQKeyboardManager.h"
#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@property(nonatomic, copy)NSString * WeChatCode;
@property(nonatomic, strong)NSMutableDictionary *wxInfoDic;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initWindow];
    [self initUMShareManager];
    [self initIQKeyboardManager];
    [self initWXApi];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
 
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
  
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}
- (void)applicationWillTerminate:(UIApplication *)application
{
   
}

#pragma mark - 友盟分享
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}



# pragma mark - 私有方法
# pragma mark 初始化键盘全局管理器
- (void)initIQKeyboardManager
{
    //IQKeyboard自动键盘管理
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //    keyboardManager.enableAutoToolbar = NO;
}

# pragma mark 初始化UMeng分享
-(void)initUMShareManager
{
    ECPlatformShareManager *shareManager   = [ECPlatformShareManager sharedECPlatformShareManager];
    
    [shareManager configUSharePlatforms];
}

# pragma mark 初始化window

-(void)initWindow{
    self.window.backgroundColor = [UIColor whiteColor];
}

# pragma mark 初始化微信
- (void)initWXApi
{
    [WXApi registerApp:kWeChatAppID];//微信支付
}

# pragma mark - 公开方法
# pragma mark 微信登录
+ (BOOL)sendAuthRequest
{
    //BOOL bl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://app/wxefcb6fbe7290272e/"]];
    if ([WXApi isWXAppInstalled])
    {
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"123";
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
        return YES;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未安装微信" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return NO;
    }
    
}


# pragma mark - 各种代理方法
# pragma mark WXApiDelegate 微信代理

//授权后回调(获取code)
- (void)onResp:(BaseResp*)resp
{
    if (resp && [resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *sendAuthResp =  (SendAuthResp *)resp;
        [self toCompliteWeChatLogin:sendAuthResp];
    }
    else if([resp isKindOfClass:[PayResp class]]){
        
    }
    else if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        self.Appdelegateblock(resp);
    }
    
}

-(void)onReq:(BaseReq *)req
{
    
}

- (void)toCompliteWeChatLogin:(SendAuthResp *)sendAuthResp
{
    if (sendAuthResp.errCode == 0) {
        self.WeChatCode = sendAuthResp.code;
        ECBlockSet
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ECBlockGet(strongSelf)
            NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", kWeChatAppID,kWeChatSecret,strongSelf.WeChatCode];
            NSURL *zoneUrl = [NSURL URLWithString:url];
            NSData *data = [NSData dataWithContentsOfURL:zoneUrl];
            if (!data)
            {
                return ;
            }
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (dic)
            {
                NSString *openid = [NSString stringEmptyTransform:[dic objectForKey:@"openid"]];
                NSString *token = [NSString stringEmptyTransform:[dic objectForKey:@"access_token"]];
                if (openid.length > 0 && token.length > 0)
                {
                    NSMutableDictionary *responeData = [[NSMutableDictionary alloc] init];
                    [responeData setObject:openid forKey:@"openid"];
                    [responeData setObject:token forKey:@"token"];
                    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", token, openid];
                    NSURL *zoneUrl = [NSURL URLWithString:url];
                    NSData *data = [NSData dataWithContentsOfURL:zoneUrl];
                    NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if (userInfo)
                    {
                        NSString *sex = [NSString stringEmptyTransform:userInfo[@"sex"]];
                        if ([sex isEqualToString:@"1"])
                        {
                            sex = @"男";
                        }
                        else if ([sex isEqualToString:@"0"])
                        {
                            sex = @"女";
                        }
                        else
                        {
                            sex = @"";
                        }
                        [responeData addEntriesFromDictionary:userInfo];
                        [responeData setObject:sex forKey:@"sex"];
                    }
                    strongSelf.wxInfoDic = responeData;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ECBlockGet(strongSelf)
                        if (strongSelf && strongSelf.Appdelegateblock)
                        {
                            strongSelf.Appdelegateblock(strongSelf.wxInfoDic);
                        }
                    });
                }
            }
        });
    }
}

@end
