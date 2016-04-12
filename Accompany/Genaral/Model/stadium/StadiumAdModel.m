//
//  StadiumAdModel.m
//  Accompany
//
//  Created by 巩鑫 on 16/1/23.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "StadiumAdModel.h"

@implementation StadiumAdModel

+ (instancetype)StadiumAdModel:(NSDictionary *)dict
{
    StadiumAdModel*model = [[self alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
@end
