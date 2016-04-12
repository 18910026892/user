//
//  JLExchangeModel.m
//  Accompany
//
//  Created by 巩鑫 on 16/2/21.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLExchangeModel.h"

@implementation JLExchangeModel
+ (instancetype)JLExchangeModel:(NSDictionary *)dict
{
    JLExchangeModel*model = [[self alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
@end
