//
//  ECCommenMethod.h
//  ECDoctor
//
//  Created by linsen on 15/9/16.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECUser.h"
#define kECUserNeedLogin  [ECCommenMethod userNeedLogin];

@interface ECCommenMethod : NSObject

/**
 *	@brief	重新登录
 *
 *	Created by mac on 2015-09-28 15:13
 */
+ (void)userNeedLogin;

/**
 *	@brief 是否首次安装
 *
 */
+(BOOL)isFirstInstall;

/**
 *	@brief 窗口抖动
 *  @param view 视图
 */
+ (void)shakeAnimationForView:(UIView *) view;

#pragma mark - System Methods

+ (NSString*)deviceVersion;

+ (UIImage *)getLaunchImage;

/**
 *	@brief	拨打电话
 *	@param 	number 	电话号码
 *	Created by mac on 2015-09-16 20:57
 */
+ (void)callToNumber:(NSString *)number;

/**
 *	@brief	相机是否可用
 *
 *	@return	<#return value description#>
 */
+ (BOOL)allowUseCamera;


NSInteger getVersionIntValue();

#pragma mark - Tool Methods
/**
 *  16进制字符串转NSInteger
 *
 *  @param hexStr 16进制字符串
 *
 *  @return NSInteger
 *
 *  Supplied explanation by linsen on 2016-05-26 17:45:41
 */
+ (NSInteger)getIntValueWithHexStr:(NSString *)hexStr;

+ (NSString*)stringByTrimmingIllegalCharacter:(NSString*)aString;

+ (NSString *)ToHex:(long long int)tmpid;

/**
 获取服务器当前时间

 @return NSDate
 */
+(NSDate *)getInternetDate;

@end


