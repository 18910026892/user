//
//  Helper+Cache.m
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "Helper+Cache.h"

@implementation Helper (Cache)

/**
 *@brief 获取Documents下的路径
 */
+ (NSString *)pathAtDocumentFileName:(NSString *)fileName{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
}


+ (BOOL)cacheObject:(id)object fileName:(NSString *)fileName{
    if(fileName == nil){
        return NO;
    }
    //创建文件夹
    NSString *floderPath = [self pathAtDocumentFileName:fileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:floderPath isDirectory:nil]){
        BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:floderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!isSuccess){
            //创建文件夹失败
            return NO;
        }
    }
    //写入文件
    NSString *filePath = [floderPath stringByAppendingPathComponent:fileName];
    if(![NSKeyedArchiver archiveRootObject:object toFile:filePath]){
        return NO;
    }
    return YES;
}

+ (id)readCacheWithFileName:(NSString *)fileName{
    if(fileName == nil){
        return nil;
    }
    NSString *floderPath = [self pathAtDocumentFileName:fileName];
    NSString *filePath = [floderPath stringByAppendingPathComponent:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}


+ (void)removeCacheWithFileName:(NSString *)fileName{
    if(fileName == nil){
        return;
    }
    NSString *floderPath = [self pathAtDocumentFileName:fileName];
    NSString *filePath = [floderPath stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}


@end
