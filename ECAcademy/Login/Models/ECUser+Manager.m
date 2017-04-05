//
//  ECUser+Manager.m
//  ECDoctor
//
//  Created by linsen on 15/8/17.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECUser+Manager.h"
#import "MJExtension.h"
#define kECStandardUserKey   @"kECStandardUserKey"
#define kECLastLoginUserKey   @"kECLastLoginUserKey"
@implementation ECUser (Manager)
+ (NSMutableDictionary *)userListData
{
    NSArray *paths1=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                        , NSUserDomainMask
                                                        , YES);
    NSString *documentsDirect=[paths1 objectAtIndex:0];
    documentsDirect = [documentsDirect stringByAppendingPathComponent:@"userSave"];
    NSString *filePath = [documentsDirect stringByAppendingPathComponent:@"userList.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        return dict;
    }
    return nil;
}

+ (ECUser *)getUserByLoginUserName:(NSString *)strName
{
    return nil;
}

+ (ECUser *)getStandardUser
{
    NSMutableDictionary *mdic = [ECUser userListData];
    NSString *standarUserid = [mdic objectForKey:kECStandardUserKey];
    if (standarUserid.length > 0)
    {
        NSDictionary *dic = [mdic objectForKey:standarUserid];
        if (dic && [dic isKindOfClass:[NSDictionary class]])
        {
            ECUser *user = [ECUser objectWithKeyValues:dic];
            if (user)
            {
                user.isLogin = NO;
            }
            return user;
        }
    }
    return nil;
}

+ (ECUser *)getLastLoginUser
{
    NSMutableDictionary *mdic = [ECUser userListData];
    NSString *standarUserid = [mdic objectForKey:kECLastLoginUserKey];
    if (standarUserid.length > 0)
    {
        NSDictionary *dic = [mdic objectForKey:standarUserid];
        if (dic && [dic isKindOfClass:[NSDictionary class]])
        {
            ECUser *user = [ECUser objectWithKeyValues:dic];
            if (user)
            {
                user.isLogin = NO;
            }
            return user;
        }
    }
    return nil;
}

+ (BOOL)saveUser:(ECUser *)user setStandardUser:(BOOL)isAllow
{
    if (user && [user isKindOfClass:[ECUser class]] && user.userid.length > 0)
    {
        NSDictionary *dic = [user keyValues];
        NSMutableDictionary *mdic = [ECUser userListData];
        if (mdic == nil)
        {
            mdic = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
        NSDictionary *theDic = [mdic objectForKey:user.userid];
        if (theDic)
        {
            NSMutableDictionary *md = [[NSMutableDictionary alloc] initWithDictionary:theDic];
            [md setDictionary:dic];
            [mdic setObject:md forKey:user.userid];
        }
        else
        {
            [mdic setObject:dic forKey:user.userid];
        }
        if (isAllow)
        {
            [mdic setObject:user.userid forKey:kECStandardUserKey];
            [ECUser setStandardUser:user];
        }
        else
        {
            NSString *oldStandUserid = [mdic objectForKey:kECStandardUserKey];
            if (user.userid.length > 0 && oldStandUserid.length > 0 && [oldStandUserid isEqualToString:user.userid])
            {
                [mdic removeObjectForKey:kECStandardUserKey];
                [ECUser setStandardUser:nil];
            }
        }
        [mdic setObject:user.userid forKey:kECLastLoginUserKey];
        NSArray *paths1=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                            , NSUserDomainMask
                                                            , YES);
        
        
        NSString *documentsDirect=[paths1 objectAtIndex:0];
        documentsDirect = [documentsDirect stringByAppendingPathComponent:@"userSave"];
        NSString *filePath = [documentsDirect stringByAppendingPathComponent:@"userList.plist"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:documentsDirect])
        {
            [fileManager createDirectoryAtPath:documentsDirect
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
        }
        
        if ([fileManager fileExistsAtPath:filePath])
        {
            [fileManager removeItemAtPath:filePath error:nil];
        }
        [mdic writeToURL:[NSURL fileURLWithPath:filePath] atomically:YES];
      
#pragma mark - Add
      [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoBeEditeNotification object:[ECUser standardUser]];
      
        return YES;
    }
    return NO;
}
@end
