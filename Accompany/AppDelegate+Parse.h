//
//  AppDelegate.h
//  Accompany
//
//  Created by GX on 16/1/18.
//  Copyright © 2016年 GX. All rights reserved.
//


#import "AppDelegate.h"

@interface AppDelegate (Parse)

- (void)parseApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)initParse;

- (void)clearParse;

@end
