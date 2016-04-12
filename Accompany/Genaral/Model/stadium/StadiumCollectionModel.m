//
//  StadiumCollectionModel.m
//  Accompany
//
//  Created by 巩鑫 on 16/1/23.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "StadiumCollectionModel.h"

@implementation StadiumCollectionModel
+ (instancetype)StadiumCollectionModel:(NSDictionary *)dict
{
    StadiumCollectionModel*model = [[self alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
@end
