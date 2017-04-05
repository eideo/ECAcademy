//
//  ECDataBaseManager.m
//  ECDoctor
//
//  Created by linsen on 15/8/18.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECDataBaseManager.h"
#import "FMDatabase.h"
#import "NSString+ECExtensions.h"
#import "ECUser.h"
#define nkCachesSavePathWith(account)      [NSString stringWithFormat:@"ECDoctorCaches/%@", account]
#define nkCachesSaveDB       @"cache.sqlite"
#define nkCommonCachesSaveDB       @"common.sqlite"
#define nkDataBaseVersion   1
#define nkCommonDataBaseVersion   1         //common.sqlite
#define nkDataBaseVersionKey   @"DataBaseVersionKey"
#define kCacheDataPath  @"kCacheTempDataPath"
@implementation ECDataBaseManager

+ (BOOL)isExistDBWithUser:(ECUser *)user
{
    NSString *userId = user.userid;
    if (userId.length < 1) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath=[paths objectAtIndex:0];
    
    filePath = [filePath stringByAppendingPathComponent:nkCachesSavePathWith(userId)];
    filePath = [filePath stringByAppendingPathComponent:nkCachesSaveDB];
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    return fileExists;
}

+ (FMDatabase *)databaseWithUser:(ECUser *)user
{
    NSString *dbBase = [ECDataBaseManager databasePath:user.userid];
    if (dbBase)
    {
        FMDatabase *db = [FMDatabase databaseWithPath:dbBase];
        return db;
    }
    return nil;
}

+ (FMDatabase *)getCommonDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath=[paths objectAtIndex:0];
    
    filePath = [filePath stringByAppendingPathComponent:nkCachesSavePathWith(@"common")];
    // 判断文件夹是否存在，不存在则创建对应文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
        }
    }
    filePath = [filePath stringByAppendingPathComponent:nkCommonCachesSaveDB];
    
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    //数据库版本控制
    if (fileExists)
    {
        NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@", nkDataBaseVersionKey, @"common"]];
        if (!version || [version integerValue] < nkCommonDataBaseVersion)
        {
            fileExists = NO;
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
    if (!fileExists)
    {
        NSString *sourcesPath = [[NSBundle mainBundle] pathForResource:@"common"ofType:@"sqlite"];
        NSError *error ;
        if ([fileManager copyItemAtPath:sourcesPath toPath:filePath error:&error]) {
            //      NSLog(@"数据库复制成功");
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd", nkCommonDataBaseVersion] forKey:[NSString stringWithFormat:@"%@_%@", nkDataBaseVersionKey, @"common"]];
        }
        else {
            NSLog(@"数据库复制失败");
        }
    }
    
    if (filePath)
    {
        FMDatabase *db = [FMDatabase databaseWithPath:filePath];
        return db;
    }
    return nil;
}

+ (NSMutableArray *)dataWithResult:(FMResultSet *)resultSet
{
    NSMutableArray *result = [NSMutableArray array];
    while ([resultSet next]) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithCapacity:0];
        NSInteger columnCount = [resultSet columnCount];
        for (int i=0; i < columnCount; i++) {
            NSString *key = [resultSet columnNameForIndex:i];
            NSString *value = [resultSet stringForColumn:key];
            
            if (![value isValid]) {
                value = @"";
            }
            //存入数据库之前将单引号转为两个单引号，所以取出来也要将单引号减少一个
            if (value && [value isKindOfClass:[NSString class]] && value.length > 0 && [value containsString:@"''"])
            {
                value = [value stringByReplacingOccurrencesOfString:@"''" withString:@"'"];
            }
            [data setObject:value forKey:key];
        }
        [result addObject:data];
    }
    return result;
}

+ (NSMutableArray *)databaseSpecialCharacterTransformationWith:(NSArray *)array
{
    NSMutableArray *returnArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *string in array)
    {
        NSString *tempString = [string lowercaseString];
        if ([tempString isEqualToString:@"no"] || [tempString isEqualToString:@"key"] || [tempString isEqualToString:@"group"] || [tempString isEqualToString:@"order"] || [tempString isEqualToString:@"plan"])
        {
            [returnArr addObject:[NSString stringWithFormat:@"\"%@\"", string]];
        }
        else
        {
            [returnArr addObject:string];
        }
    }
    return returnArr;
}
+ (BOOL)writeData:(NSArray *)dataArray intoTable:(NSString *)tableName byPrimaryKey:(NSString *)primaryKey
{
    FMDatabase *db = [ECDataBaseManager databaseWithUser:[ECUser standardUser]];
    if (db)
    {
        return [ECDataBaseManager writeData:dataArray intoTable:tableName byPrimaryKey:primaryKey inDataBase:db];
    }else{
        return NO;
    }
}

+ (BOOL)writeData:(NSArray *)dataArray intoTable:(NSString *)tableName byPrimaryKey:(NSString *)primaryKey inDataBase:(FMDatabase *)db
{
    BOOL result = YES;
    if (![tableName isValid] || ![primaryKey isValid] || [dataArray count] == 0)
    {
        return NO;
    }
    if ([dataArray count] > 0)
    {
        NSMutableArray *saveObjects = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableString *objectIdStr = nil;
        //找出所有key, 务必要覆盖所有model的字段
        NSArray *keys = nil;
        NSMutableDictionary * dicts = [[NSMutableDictionary alloc] initWithCapacity:30];
        for (id object in dataArray)
        {
            NSDictionary *objectDic = nil;
            if ([object isKindOfClass:[ECBaseObject class]])
            {
                objectDic = [object keyValuesForDatabase];//[object keyValues];
            }
            //利用字典的特性,对key进行去重复操作
            [dicts setValuesForKeysWithDictionary:objectDic];
        }
        keys = [dicts allKeys];
        //接下来处理数据,分别对model进行values的处理
        for (id object in dataArray)
        {
            NSDictionary *objectDic = nil;
            if ([object isKindOfClass:[ECBaseObject class]])
            {
                objectDic = [object keyValuesForDatabase];//[object keyValues];
            }
            if (objectDic)
            {
                NSString *objectid = nil;//[NSString stringEmptyTransform:[objectDic objectForKey:primaryKey]];
                NSArray *primaryKeys = [primaryKey componentsSeparatedByString:@"&"];
                //处理主键的值
                for (NSString *key in primaryKeys)
                {
                    NSString *tempStr = [NSString stringEmptyTransform:[objectDic objectForKey:key]];
                    if (objectid == nil)
                    {
                        objectid = [NSString stringWithFormat:@"%@", tempStr];
                    }
                    else
                    {
                        objectid = [objectid stringByAppendingFormat:@"&%@", tempStr];
                    }
                }
                if (objectid.length > 0)
                {
                    objectid = [NSString stringWithFormat:@"'%@'", objectid];
                    if (objectIdStr == nil)
                    {
                        objectIdStr = [NSMutableString stringWithFormat:@"%@", objectid];
                    }
                    else
                    {
                        if ([objectIdStr rangeOfString:objectid].length == 0)
                        {
                            [objectIdStr appendFormat:@",%@", objectid];
                        }
                    }
                    
                    
                    NSMutableString *objectStr = nil;
                    for (NSString *keyStr in keys)
                    {
                        NSString *valueStr = [NSString stringEmptyTransform:[objectDic objectForKey:keyStr]];
                        if (objectStr == nil)
                        {
                            objectStr = [NSMutableString stringWithFormat:@"'%@'", valueStr];
                        }
                        else
                        {
                            [objectStr appendFormat:@",'%@'", valueStr];
                        }
                    }
                    //汇总所有的待插入数据库的值字符串到数组当中, objectStr为一个model的所有值的字符组合,
                    if (objectStr.length > 0)
                    {
                        [saveObjects addObject:[NSString stringWithFormat:@"(%@)", objectStr]];
                    }
                }
            }
        }
        primaryKey = [primaryKey stringByReplacingOccurrencesOfString:@"&" withString:@"||'&'||"];
        if ([saveObjects count] > 0 && [keys count] > 0)
        {
            NSString *sql = [NSString stringWithFormat:@"delete from %@ where (%@) in (%@)", tableName, primaryKey, objectIdStr];
            if (db && [db open])
            {
                [db beginTransaction];
                result &= [db executeUpdate:sql];
                NSString *insertKeyStr = [[ECDataBaseManager databaseSpecialCharacterTransformationWith:keys] componentsJoinedByString:@","];
                while ([saveObjects count] > 0) {
                    NSArray *insertArray = nil;
                    if ([saveObjects count] > 100)
                    {
                        NSRange range = NSMakeRange(0, 100);
                        insertArray = [saveObjects subarrayWithRange:range];
                        [saveObjects removeObjectsInRange:range];
                    }
                    else
                    {
                        insertArray = [NSArray arrayWithArray:saveObjects];
                        [saveObjects removeAllObjects];
                    }
                    NSString *insertValueStr = [insertArray componentsJoinedByString:@","];
                    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@) values %@", tableName, insertKeyStr, insertValueStr];
                    result &= [db executeUpdate:insertSql];
                }
                [db commit];
                [db close];
            }
        }
        
    }
    return result;
}

+ (BOOL)writeData:(NSArray *)dataArray intoTable:(NSString *)tableName inDataBase:(FMDatabase *)db
{
    BOOL result = YES;
    if (![tableName isValid] || [dataArray count] == 0)
    {
        return NO;
    }
    if ([dataArray count] > 0)
    {
        NSMutableArray *saveObjects = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *keys = nil;
        for (id object in dataArray)
        {
            NSDictionary *objectDic = nil;
            if ([object isKindOfClass:[ECBaseObject class]])
            {
                objectDic = [object keyValuesForDatabase];//[object keyValues];
            }
            if (objectDic)
            {
                if ([keys count] == 0)
                {
                    keys = [objectDic allKeys];
                }
                NSMutableString *objectStr = nil;
                for (NSString *keyStr in keys)
                {
                    NSString *valueStr = [NSString stringEmptyTransform:[objectDic objectForKey:keyStr]];
                    if (objectStr == nil)
                    {
                        objectStr = [NSMutableString stringWithFormat:@"'%@'", valueStr];
                    }
                    else
                    {
                        [objectStr appendFormat:@",'%@'", valueStr];
                    }
                }
                if (objectStr.length > 0)
                {
                    [saveObjects addObject:[NSString stringWithFormat:@"(%@)", objectStr]];
                }
            }
        }
        if ([saveObjects count] > 0 && [keys count] > 0)
        {
            if (db && [db open])
            {
                [db beginTransaction];
                NSString *insertKeyStr = [[ECDataBaseManager databaseSpecialCharacterTransformationWith:keys] componentsJoinedByString:@","];
                while ([saveObjects count] > 0) {
                    NSArray *insertArray = nil;
                    if ([saveObjects count] > 100)
                    {
                        NSRange range = NSMakeRange(0, 100);
                        insertArray = [saveObjects subarrayWithRange:range];
                        [saveObjects removeObjectsInRange:range];
                    }
                    else
                    {
                        insertArray = [NSArray arrayWithArray:saveObjects];
                        [saveObjects removeAllObjects];
                    }
                    NSString *insertValueStr = [insertArray componentsJoinedByString:@","];
                    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@) values %@", tableName, insertKeyStr, insertValueStr];
                    result &= [db executeUpdate:insertSql];
                }
                [db commit];
                [db close];
            }
        }
        
    }
    return result;
}

+ (void)cacheDataWithData:(id)data andKey:(NSString *)strKey
{
    if (data == nil || strKey.length == 0)
    {
        return;
    }
    strKey = [strKey stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    strKey = [strKey stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath=[paths objectAtIndex:0];
    filePath = [filePath stringByAppendingPathComponent:@"ECDoctorCaches"];
    filePath = [filePath stringByAppendingPathComponent:kCacheDataPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath])
    {
        [fileManager createDirectoryAtPath:filePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strKey]];
    if ([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    NSDictionary *dict = @{@"data":data};
    if ([dict writeToURL:[NSURL fileURLWithPath:filePath] atomically:YES]) {
        //        NSLog(@"写入成功");
    }else{
        NSLog(@"写入失败");
    };
}

+ (id)getCacheDataWithKey:(NSString *)strKey
{
    if (strKey.length == 0)
    {
        return nil;
    }
    strKey = [strKey stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    strKey = [strKey stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath=[paths objectAtIndex:0];
    filePath = [filePath stringByAppendingPathComponent:@"ECDoctorCaches"];
    filePath = [filePath stringByAppendingPathComponent:kCacheDataPath];
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strKey]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        return dict[@"data"];
    }
    //  /var/mobile/Applications/00A0621B-E40D-4539-9796-DE217E11BA09/Library/ECDoctorCaches/kCacheTempDataPath/collect_cache.plist
    
    return nil;
}

+ (void)userCacheDataWithData:(id)data andKey:(NSString *)strKey user:(ECUser *)user
{
    NSString *clinicStr = @"";
    if (data == nil || strKey.length == 0 || user == nil || ![user isKindOfClass:[ECUser class]] || user.userid.length == 0||![clinicStr isValid])
    {
        return;
    }
    
    
    strKey = [strKey stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    strKey = [strKey stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath=[paths objectAtIndex:0];
    filePath = [filePath stringByAppendingPathComponent:nkCachesSavePathWith(clinicStr)];
    filePath = [filePath stringByAppendingPathComponent:kCacheDataPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath])
    {
        [fileManager createDirectoryAtPath:filePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strKey]];
    if ([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    NSDictionary *dict = @{@"data":data};
    [dict writeToURL:[NSURL fileURLWithPath:filePath] atomically:YES];
}

+ (id)getUserCacheDataWithKey:(NSString *)strKey user:(ECUser *)user
{
    NSString *clinicStr = @"";
    if (strKey.length == 0 || user == nil || ![user isKindOfClass:[ECUser class]] || user.userid.length == 0||![clinicStr isValid])
    {
        return nil;
    }
    strKey = [strKey stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    strKey = [strKey stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath=[paths objectAtIndex:0];
    filePath = [filePath stringByAppendingPathComponent:nkCachesSavePathWith(clinicStr)];
    filePath = [filePath stringByAppendingPathComponent:kCacheDataPath];
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strKey]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        return dict[@"data"];
    }
    
    return nil;
}

+ (void)clearCacheData
{
    [[SDImageCache sharedImageCache] clearDisk];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath=[paths objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager contentsOfDirectoryAtPath:filePath error:nil];
    for (NSString *str in array)
    {
        NSString *itemFilePath = [filePath stringByAppendingPathComponent:str];
        [manager removeItemAtPath:itemFilePath error:nil];
    }
}


#pragma mark - Private
+ (NSString *)databasePath:(NSString *)userId;
{
    if (userId.length < 1) {
        return nil;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath=[paths objectAtIndex:0];
    
    filePath = [filePath stringByAppendingPathComponent:nkCachesSavePathWith(userId)];
    // 判断文件夹是否存在，不存在则创建对应文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
        }
    }
    filePath = [filePath stringByAppendingPathComponent:nkCachesSaveDB];
    
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    if (fileExists)
    {
        NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@", nkDataBaseVersionKey, userId]];
        if (!version || [version integerValue] < nkDataBaseVersion)
        {
            fileExists = NO;
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
    if (!fileExists)
    {
        NSString *sourcesPath = [[NSBundle mainBundle] pathForResource:@"cache"ofType:@"sqlite"];
        NSError *error ;
        if ([fileManager copyItemAtPath:sourcesPath toPath:filePath error:&error]) {
            //      NSLog(@"数据库复制成功");
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd", nkDataBaseVersion] forKey:[NSString stringWithFormat:@"%@_%@", nkDataBaseVersionKey, userId]];
        }
        else {
            NSLog(@"数据库复制失败");
        }
    }
    
    return filePath;
}


@end
