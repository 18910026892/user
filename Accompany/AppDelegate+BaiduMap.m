//
//  AppDelegate+BaiduMap.m
//  Accompany
//
//  Created by GongXin on 16/2/16.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "AppDelegate+BaiduMap.h"

@implementation AppDelegate (BaiduMap)
-(void)initBaiduMap;
{
    _mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [_mapManager start:@"LQNmRTG60CEeihools2HhETRs8aahzMQ"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}
@end
