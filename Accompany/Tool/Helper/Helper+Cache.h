//
//  Helper+Cache.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "Helper.h"

@interface Helper (Cache)


+ (NSString *)pathAtDocumentFileName:(NSString *)fileName;
/**
 *  缓存一个对象
 *
 *  @param object   缓存对象
 *  @param fileName 文件名
 */
+ (BOOL)cacheObject:(id)object fileName:(NSString *)fileName;

/**
 *  取出缓存数据对象
 *
 *  @param fileName 文件名
 *
 */
+ (id)readCacheWithFileName:(NSString *)fileName;

/**
 *  删除缓存文件
 *
 *  @param fileName 文件名
 */
+ (void)removeCacheWithFileName:(NSString *)fileName;

@end
