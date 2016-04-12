//
//  Config.h
//  syb
//
//  Created by GX on 15/10/21.
//  Copyright © 2015年 GX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

+(Config *)currentConfig;


//搜索类型
@property (nonatomic,copy) NSString * searchType;

//地址消息：地址经度
@property (nonatomic,copy) NSString * latitude;
//地址消息：地址纬度
@property (nonatomic,copy) NSString * longitude;
//定位城市
@property (nonatomic,copy)NSString * cityName;




@end
