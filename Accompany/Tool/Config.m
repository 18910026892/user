//
//  Config.m
//  syb
//
//  Created by GX on 15/10/21.
//  Copyright © 2015年 GX. All rights reserved.
//

#import "Config.h"

static Config * config = nil;
@implementation Config

+(Config *)currentConfig
{
    //同步线程
    @synchronized (self)
    {
        if (!config) {
            config  = [[Config alloc]init];
            config.searchType = [UserDefaultsUtils valueWithKey:@"searchType"];
            config.latitude = [UserDefaultsUtils valueWithKey:@"latitude"];
             config.longitude = [UserDefaultsUtils valueWithKey:@"longitude"];
            config.cityName = [UserDefaultsUtils valueWithKey:@"cityName"];
        
        }
    }
    return  config;
}




@end
