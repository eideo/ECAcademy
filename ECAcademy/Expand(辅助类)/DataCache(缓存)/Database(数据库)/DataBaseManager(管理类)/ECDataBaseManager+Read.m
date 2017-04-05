                    //
//  ECDataBaseManager+Read.m
//  ECDoctor
//
//  Created by linsen on 15/8/18.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECDataBaseManager+Read.h"
#import "FMDatabase.h"
#import "ECUser.h"
#import "NSString+ECExtensions.h"
@implementation ECDataBaseManager (Read)

+ (NSMutableArray *)getUserClinicsWithUser:(ECUser *)user
{
    NSString *sql = @"select * from t_clinic where datastatus <> '0'";
    NSMutableArray *resultArray = nil;
    FMDatabase *db = [ECDataBaseManager databaseWithUser:user];
    if (db && [db open])
    {
        FMResultSet *result = [db executeQuery:sql];
        resultArray = [ECDataBaseManager dataWithResult:result];
        [result close];
        [db close];
    }
    return resultArray;
}

#pragma mark - 针对公共数据库查询
+ (NSDictionary *)getHospitalUpdateInfo
{
  NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"HospitalUpdateInfo"];
  return dic;
}

+ (void)clearHospitalInfo
{
  FMDatabase *db = [ECDataBaseManager getCommonDatabase];
  if (db && [db open])
  {
    NSString *sql = [NSString stringWithFormat:@"delete from t_hospital"];
    [db beginTransaction];
    [db executeQuery:sql];
    [db commit];
    [db close];
  }
}

+ (NSString *)getHospitalLastUpdatetime
{
  NSString *returnValue = nil;
  FMDatabase *db = [ECDataBaseManager getCommonDatabase];
  if (db && [db open])
  {
    NSString *sql = [NSString stringWithFormat:@"select max(updatetime) updatetime from t_hospital"];
    [db beginTransaction];
    FMResultSet *result = [db executeQuery:sql];
    NSMutableArray *array = [ECDataBaseManager dataWithResult:result];
    if ([array count])
    {
      NSDictionary *dic = [array firstObject];
      returnValue = [dic objectForKey:@"updatetime"];
    }
    [db commit];
    [db close];
  }
  return returnValue;
}



+ (NSDictionary *)getUniversityUpdateInfo
{
  NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UniversityUpdateInfo"];
  return dic;
}

+ (void)clearUniversityInfo
{
  FMDatabase *db = [ECDataBaseManager getCommonDatabase];
  if (db && [db open])
  {
    NSString *sql = [NSString stringWithFormat:@"delete from t_university"];
    [db beginTransaction];
    [db executeQuery:sql];
    [db commit];
    [db close];
  }
}

@end
