//
//  FileService.h
//  百思不得姐
//
//  Created by yellowei on 16/1/15.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWSandbox.h"

@interface FileService : NSObject

/**
 *  计算单个文件大小
 *
 *  @param path 路径
 *
 *  @return 文件大小
 */
+ (float)fileSizeAtPath:(NSString *)path;


/**
 *  计算目录大小
 *
 *  @param path 路径
 *
 *  @return 返回目录大小
 */
+ (float)folderSizeAtPath:(NSString *)path;


/**
 *  清理缓存
 *
 *  @param path 路径
 */
+ (void)clearCache:(NSString *)path;

/**
 *  可用空间
 *
 *  @return
 */
+ (NSString *)freeDiskSpaceInBytesString;

/**
 *  总空间
 *
 *  @return 
 */
+ (NSString *)getTotalDiskSizeString;

/**
 *  总空间
 *
 *  @return
 */
+ (long long)getTotalDiskSize;


/**
 *  可用空间
 *
 *  @return
 */
+ (long long)getFreeDiskSize;

/**
 *  字符串转换方法
 *
 *  @param fileSize 大小
 *
 *  @return
 */
+ (NSString *)fileSizeToString:(unsigned long long)fileSize;


@end
