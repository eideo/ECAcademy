//
//  ECCommenMethod.m
//  ECDoctor
//
//  Created by linsen on 15/9/16.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECCommenMethod.h"
#import "ECDataBaseManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SDImageCache.h"
#import "NSString+ECExtensions.h"
#import "ECNetworkRequestManager.h"

#define kServerHostStr [[ECNetworkRequestManager sharedECNetworkRequestManager] getServerHostStr]

@interface ECCommenMethod ()
{
  
}
@end
@implementation ECCommenMethod

static NSInteger kECVersionIntValue = 0;

+ (void)userNeedLogin
{
    
}

+(BOOL)isFirstInstall
{
    BOOL isInstall = YES;
    NSString *boolStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstInstall"];
    if ([boolStr isValid]) {
        isInstall = NO;
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstInstall"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return isInstall;
}

+ (void)shakeAnimationForView:(UIView *) view
{
  // 获取到当前的View
  
  CALayer *viewLayer = view.layer;
  
  // 获取当前View的位置
  
  CGPoint position = viewLayer.position;
  
  // 移动的两个终点位置
  
  CGPoint x = CGPointMake(position.x - 5, position.y);
  
  CGPoint y = CGPointMake(position.x + 5, position.y);
  
  // 设置动画
  
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
  
  // 设置运动形式
  
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
  
  // 设置开始位置
  
  [animation setFromValue:[NSValue valueWithCGPoint:x]];
  
  // 设置结束位置
  
  [animation setToValue:[NSValue valueWithCGPoint:y]];
  
  // 设置自动反转
  
  [animation setAutoreverses:YES];
  
  // 设置时间
  
  [animation setDuration:.08];
  
  // 设置次数
  
  [animation setRepeatCount:3];
  
  // 添加上动画
  
  [viewLayer addAnimation:animation forKey:nil];
  
}

#pragma mark - System Methods
//获取当前设备型号®
+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"] ||
        [deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"] ||
        [deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;
}

+ (UIImage *)getLaunchImage
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString * viewOrientation = @"Portrait";
    NSString * launchImage = nil;
    NSArray * imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for (NSDictionary * dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    UIImage * returnObj = [UIImage imageNamed:launchImage];
    return returnObj;
}

+ (void)callToNumber:(NSString *)number
{
  if ([number isValid])
  {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", number]];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
      [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机不支持通话或电话号码有误哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
      [alert show];
    }
  }
}

+ (BOOL)allowUseCamera
{
  if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
  {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有访问相机的权限，您可以去系统设置[设置-隐私-相机]中为牙医管家开启相机功能" delegate:[UIApplication sharedApplication].delegate cancelButtonTitle:@"确定" otherButtonTitles:@"设置",nil];
        alert.tag = 9999;
      [alert show];
      return NO;
    }
  }
  else
  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备相机不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    return NO;
  }
  return YES;
}

NSInteger getVersionIntValue()
{
  if (kECVersionIntValue == 0)
  {
    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if (versionStr == nil)
    {
      versionStr = @"0";
    }
    versionStr = [versionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    kECVersionIntValue = [versionStr integerValue];
  }
  return kECVersionIntValue;
}

#pragma mark - Tool Methods
+ (NSInteger)getIntValueWithHexStr:(NSString *)hexStr
{
  hexStr = [hexStr lowercaseString];
  hexStr = [hexStr stringByReplacingOccurrencesOfString:@"0x" withString:@""];
  hexStr = [hexStr stringByReplacingOccurrencesOfString:@" " withString:@""];
  NSString *signStr = @"+";
  if ([hexStr hasPrefix:@"-"])
  {
    signStr = @"-";
    hexStr = [hexStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
  }
  NSInteger length = hexStr.length;
  NSInteger returnValue = 0;
  for (NSInteger i = 0; i < length; i++)
  {
    NSString *str = [hexStr substringWithRange:NSMakeRange(i, 1)];
    NSInteger tempValue = 0;
    if ([str isEqualToString:@"0"])
    {
      
    }
    else if ([str integerValue] > 0)
    {
      tempValue = [str integerValue];
      
    }
    else if([str isEqualToString:@"a"])
    {
      tempValue = 10;
    }
    else if([str isEqualToString:@"b"])
    {
      tempValue = 11;
    }
    else if([str isEqualToString:@"c"])
    {
      tempValue = 12;
    }
    else if([str isEqualToString:@"d"])
    {
      tempValue = 13;
    }
    else if([str isEqualToString:@"e"])
    {
      tempValue = 14;
    }
    else if([str isEqualToString:@"f"])
    {
      tempValue = 15;
    }
    else
    {
      return 0;
    }
    if (tempValue != 0)
    {
      tempValue <<= (length - i - 1)*4;
      returnValue += tempValue;
    }
  }
  if ([signStr isEqualToString:@"-"])
  {
    return -returnValue;
  }
  return returnValue;
}

+ (NSString*)stringByTrimmingIllegalCharacter:(NSString*)aString
{
  NSString *originString = [NSString stringWithString:aString];
  NSLog(@"%@",originString);
  NSString *sub1 = nil;
  NSString *sub2 = nil;
  int illegal = 0;
  for(int j=0;j<[originString length];j++)
  {
    if((int)[originString characterAtIndex:j] == 8198)
      illegal++;
  }
  for(int i=0;i<illegal;i++)
  {
    for(int j=0;j<[originString length];j++)
    {
      if((int)[originString characterAtIndex:j] == 8198)
      {
        sub1 = [originString substringToIndex:j];
        sub2 = [originString substringFromIndex:(j+1)];
        break;
      }
    }
    if(sub1 != nil && sub2 != nil)
    {
      originString = [NSString stringWithString:sub1];
      originString = [originString stringByAppendingString:sub2];
    }
  }
  return originString;
}

+ (NSString *)ToHex:(long long int)tmpid
{
  NSString *nLetterValue;
  NSString *str =@"";
  long long int ttmpig;
  for (int i = 0; i<9; i++) {
    ttmpig=tmpid%16;
    tmpid=tmpid/16;
    switch (ttmpig)
    {
      case 10:
        nLetterValue =@"A";break;
        
      case 11:
        nLetterValue =@"B";break;
        
      case 12:
        nLetterValue =@"C";break;
        
      case 13:
        nLetterValue =@"D";break;
        
      case 14:
        nLetterValue =@"E";break;
        
      case 15:
        nLetterValue =@"F";break;
        
      default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
    }
    str = [nLetterValue stringByAppendingString:str];
    if (tmpid == 0) {
      break;
    }
  }
  return str;
}

+ (NSDate *)getInternetDate
{
  NSString *urlString = kServerHostStr;
  urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString: urlString]];
  [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
  [request setTimeoutInterval: 2];
  [request setHTTPShouldHandleCookies:FALSE];
  [request setHTTPMethod:@"GET"];
  NSHTTPURLResponse *response;
  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
  
  NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
  date = [date substringFromIndex:5];
  date = [date substringToIndex:[date length]-4];
  NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
  dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
  [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
//  [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8]
  NSDate *netDate = [dMatter dateFromString:date];
  
  NSTimeZone *zone = [NSTimeZone systemTimeZone];
  NSInteger interval = [zone secondsFromGMTForDate: netDate];
  NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
  return localeDate;
}

@end


