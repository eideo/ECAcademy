//
//  common.h
//  ECAcademy
//
//  Created by Sophist on 2017/3/23.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#ifndef common_h
#define common_h


////-----------------屏幕适配 (以iphone5为基准)-----------------
#define kScreenWidthRatio  (kECScreenWidth / 320.0)
#define kScreenHeightRatio (kECScreenHeight / 568.0)
#define AdaptedWidthValue(x)  (ceilf((x) * kScreenWidthRatio))
#define AdaptedHeightValue(x) (ceilf((x) * kScreenHeightRatio))


#define kECScreenWidth     [UIScreen mainScreen].bounds.size.width
#define kECScreenHeight    [UIScreen mainScreen].bounds.size.height
#define kECScreenScale ((kECScreenWidth/320.0 - 1)*0.618 + 1)
//有TabBar和NaviBar时候的全屏大小
#define KECScreenTNFrame   CGRectMake(0, 64, kECScreenWidth, kECScreenHeight - 64 - 49)

//-----------------当前机型,系统-----------------
#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)
#ifndef iPhone5
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)
#endif
#define kiPhone6Below ([UIScreen mainScreen].bounds.size.height < 667)
#define kiPhone5Below ([UIScreen mainScreen].bounds.size.height < 568)
#define kiPhone6P ([UIScreen mainScreen].bounds.size.height > 667)
#define kIOS7              ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define kIOS8              ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define kIOS9              ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)

//-----------------项目通用颜色,字体-----------------

#define ECColorWithHEX(hex) [UIColor colorWithRed:(float)((hex & 0xFF0000) >> 16)/255.0 green:(float)((hex & 0xFF00) >> 8)/255.0 blue:(float)(hex & 0xFF)/255.0 alpha:1.0]
#define ECBGRColorWithHEX(hex) [UIColor colorWithRed:(float)(hex & 0xFF)/255.0 green:(float)((hex & 0xFF00) >> 8)/255.0 blue:(float)((hex & 0xFF0000) >> 16)/255.0 alpha:1.0]
#define ECColorWithRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define kECBackgroundColor  ECColorWithHEX(0xf2f6f7)
#define kECBlackColor1  ECColorWithHEX(0x1a1a1a)
#define kECBlackColor2  ECColorWithHEX(0x333333)
#define kECBlackColor3  ECColorWithHEX(0x888888)
#define kECBlackColor4  ECColorWithHEX(0xbfbfbf)
#define kECBlackColor5  ECColorWithHEX(0xececec)
#define kECBlackColor6  ECColorWithHEX(0xf9f9f9)
#define kECWhiteColor  ECColorWithHEX(0xffffff)
#define kECBlueColor  ECColorWithHEX(0x00b0ff)
#define kECRedColor  ECColorWithHEX(0xcc3d3d)
#define kECRedColor1  ECColorWithHEX(0xf42c24)
#define kECRedColor2  ECColorWithHEX(0xf85d5a)
#define kECOrangeColor  ECColorWithHEX(0xffa033)
#define kECOrangeColor1  ECColorWithHEX(0xe96f14)
#define kECOrangeColor2  ECColorWithHEX(0xf1a532)
#define kECGreenColor  ECColorWithHEX(0x9cce3c)
#define kECClearColor  [UIColor clearColor]


#define kECGreenColor1  ECColorWithHEX(0xb2eee9)
#define kECGreenColor2  ECColorWithHEX(0x00c5b5)
#define kECGreenColor3  ECColorWithHEX(0x00a289)
#define kECGreenColor4  ECColorWithHEX(0x0aa721)
#define kECGreenColor5  ECColorWithHEX(0x1ac852)

#define kECGreenImage1  [UIImage imageNamed:@"bg_blue_color1"]
#define kECGreenImage2  [UIImage imageNamed:@"bg_blue_color2"]
#define kECGreenImage3  [UIImage imageNamed:@"bg_blue_color3"]

#define kECBlackImage1  [UIImage imageNamed:@"bg_black_color1"]
#define kECBlackImage2  [UIImage imageNamed:@"bg_black_color2"]
#define kECBlackImage3  [UIImage imageNamed:@"bg_black_color3"]
#define kECBlackImage4  [UIImage imageNamed:@"bg_black_color4"]
#define kECBlackImage5  [UIImage imageNamed:@"bg_black_color5"]
#define kECBlackImage6  [UIImage imageNamed:@"bg_black_color6"]

#pragma mark - Font Define
#define kSystemFontSize(fontSize) [UIFont systemFontOfSize:fontSize]
#define kECDoctorFont1  [UIFont systemFontOfSize:10]
#define kECDoctorFont2  [UIFont systemFontOfSize:11]
#define kECDoctorFont3  [UIFont systemFontOfSize:14]
#define kECDoctorFont4  [UIFont systemFontOfSize:15]
#define kECDoctorFont5  [UIFont systemFontOfSize:17]

//-----------------自定义常量-----------------
#define kNavHeight 64.0f //导航栏高度
#define kStateBarHeight 20.0f //导航栏高度
#define kTabbarHeight 49.0f //导航栏高度
#define kVoiceMaxTime 60 //语音最长时间
#define MIN_LENGTH_USERNAME		6		// 用户名的最小长度
#define MAX_LENGTH_USERNAME		32		// 用户名的最大长度
#define MIN_LENGTH_PASSWORD		6		// 密码的最小长度
#define MAX_LENGTH_PASSWORD		16		// 密码的最大长度
#define TabBarSelectAnimationTime 0.f   //切换tabbar按钮时渐变效果的时间

//-----------------第三方key-----------------
#define kUMAnalyticsKey @"55a75a8967e58e3ccb006d98"

//-----------------缓存key-----------------
#define kCollectCache @"collect_cache"

//-----------------通知-----------------
#define kApplicationDidBecomeActiveNotification     @"ApplicationDidBecomeActiveNotification"
#define kUserSessionBeOverdueNotification           @"UserSessionBeOverdueNotification"
#define kUserInfoBeEditeNotification  @"UserInfoBeEditeNotification"


//-----------------Common Func-----------------
#ifdef DEBUG
#define DLog(fmt,...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#define MKLog(...)
#endif

#define ECBlockSet __weak __typeof(&*self)weakSelf = self;
#define ECBlockGet(name) __strong __typeof(&*self)name = weakSelf;

#define kLoadNibName(className) [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil] //加载nib
#define kLoadStoryBoardVc(storyboardID)  [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:storyboardID]; //加载storyboard控制器
#define kNotification [NSNotificationCenter defaultCenter]
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define kAppDelegate (AppDelegate*)[[UIApplication sharedApplication] delegate]

//-----------------快速单例-----------------
#define singleton_interface(className) \
+ (className *)shared##className;

#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}


//-----------------第三方,framework引入-----------------
#import <sys/utsname.h>
#import "SDWebImageManager.h"
#import "UIView+Extension.h"
#import "NSString+ECExtensions.h"
#endif /* common_h */
