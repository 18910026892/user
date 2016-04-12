//
//  NSString+Additional.h
//  
//
//  Created by 家伟 李 on 15/4/8.
//  Copyright (c) 2015年 家伟 李. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additional)

/**
 * Returns the MD5 value of the string
 */
- (NSString*)md5;

- (NSString *)encodingURL;

@end
