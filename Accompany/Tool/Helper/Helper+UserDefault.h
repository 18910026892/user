//
//  Helper+UserDefault.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "Helper.h"

@interface Helper (UserDefault)

+(void)saveValue:(id) value forKey:(NSString *)key;

+(id)valueWithKey:(NSString *)key;

+(BOOL)boolValueWithKey:(NSString *)key;

+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key;

+(void)removeValueforKey:(NSString*)key;

+(void)print;


+ (NSData *)archiverObject:(NSObject *)object forKey:(NSString *)key;
+ (NSObject *)unarchiverObject:(NSData *)archivedData withKey:(NSString *)key;


@end
