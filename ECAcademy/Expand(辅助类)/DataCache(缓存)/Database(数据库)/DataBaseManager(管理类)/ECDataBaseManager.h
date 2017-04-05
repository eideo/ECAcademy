//
//  ECDataBaseManager.h
//  ECDoctor
//
//  Created by linsen on 15/8/18.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

/**
 *	@brief	医生擅长项目
 */
#define kECDoctorExpertListKey  @"ECDoctorExpertListKey"

/**
 *  排班类型数据
 *
 *  @return <#return value description#>
 *
 *  Supplied explanation by linsen on 2016-06-28 10:03:32
 */
#define KECDoctorWorkShiftTypeKey @"KECDoctorWorkShiftTypeKey"

#import <Foundation/Foundation.h>
@class FMDatabase, ECUser, FMResultSet;
@interface ECDataBaseManager : NSObject

+ (FMDatabase *)getCommonDatabase;
+ (BOOL)isExistDBWithUser:(ECUser *)user;
+ (FMDatabase *)databaseWithUser:(ECUser *)user;
+ (NSMutableArray *)dataWithResult:(FMResultSet *)resultSet;

+ (BOOL)writeData:(NSArray *)dataArray intoTable:(NSString *)tableName byPrimaryKey:(NSString *)primaryKey;

+ (BOOL)writeData:(NSArray *)dataArray intoTable:(NSString *)tableName byPrimaryKey:(NSString *)primaryKey inDataBase:(FMDatabase *)db;
+ (BOOL)writeData:(NSArray *)dataArray intoTable:(NSString *)tableName inDataBase:(FMDatabase *)db;

+ (void)cacheDataWithData:(id)data andKey:(NSString *)strKey;
+ (id)getCacheDataWithKey:(NSString *)strKey;

+ (void)userCacheDataWithData:(id)data andKey:(NSString *)strKey user:(ECUser *)user;
+ (id)getUserCacheDataWithKey:(NSString *)strKey user:(ECUser *)user;


/**
 清除缓存 (SDImageCache 和library 目录下缓存)
 */
+ (void)clearCacheData;

@end

