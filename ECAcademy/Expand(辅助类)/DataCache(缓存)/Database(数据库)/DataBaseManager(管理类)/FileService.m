//
//  FileService.m
//  百思不得姐
//
//  Created by yellowei on 16/1/15.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import "FileService.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#include <sys/param.h>
#include <sys/mount.h>

@implementation FileService
/*
 NSLog(@"释放内存");
 NSString * cachePath = [HWSandbox libCachePath];
 
 [FileService clearCache:cachePath];
 
 CGFloat cacheSize = [FileService folderSizeAtPath:cachePath];
 _cacheSizeLabel.text = [NSString stringWithFormat:@"已使用:%dMB",(int)cacheSize];
 */

+ (float)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}


+ (float)folderSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize=0.f;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        //SDImageCache的原生内存管理
//        folderSize+=[[SDImageCache sharedImageCache] getSize]/1000.0/1000.0;
        return folderSize;
    }
    return 0;
}

+ (void)clearCache:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles)
        {
            //如有需要，加入条件，过滤掉不想删除的文件
            //Caches里的bundleID名字文件夹不清理
            if ([fileName isEqualToString:@"Caches"])
            {
                NSString * secondPath = [path stringByAppendingPathComponent:@"Caches"];
                NSArray * secondChilFiles = [fileManager subpathsAtPath:secondPath];
                
                
                for (NSString * secondFileName in secondChilFiles)
                {
                    if ([secondFileName containsString:[NSBundle mainBundle].bundleIdentifier])
                    {
#if DEBUG
                        NSLog(@"%@",secondFileName);
#endif
                        //不删除
                    }
                    else
                    {
                        NSString *absolutePath=[secondPath stringByAppendingPathComponent:fileName];
                        [fileManager removeItemAtPath:absolutePath error:nil];
                    }
                }
                
                
            }
            //Preferences文件夹不清理
            else if ([fileName containsString:@"Preferences"])
            {
                //不删除
#if DEBUG
                NSLog(@"%@",fileName);
#endif
            }
            else
            {
                NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
                
            
        }
    }
    [[SDImageCache sharedImageCache] clearDisk];
}

+ (NSString *)freeDiskSpaceInBytesString
{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0)
    {
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return [NSString stringWithFormat:@"可用空间：%qi GB" ,freespace/1024/1024/1024];
}


+ (NSString *)getTotalDiskSizeString
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return [NSString stringWithFormat:@"总空间：%qi GB" ,freeSpace/1024/1024/1024];
}

+ (long long)getTotalDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return freeSpace;
}


+ (long long)getFreeDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace;
}


+ (NSString *)fileSizeToString:(unsigned long long)fileSize
{
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (fileSize < 10)
    {
        return @"0 B";
        
    }else if (fileSize < KB)
    {
        return @"< 1 KB";
        
    }else if (fileSize < MB)
    {
        return [NSString stringWithFormat:@"%.1f KB",((CGFloat)fileSize)/KB];
        
    }else if (fileSize < GB)
    {
        return [NSString stringWithFormat:@"%.1f MB",((CGFloat)fileSize)/MB];
        
    }else
    {
        return [NSString stringWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
    }
}
@end
