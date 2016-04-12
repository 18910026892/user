//
//  CocahModel.m
//  Accompany
//
//  Created by 巩鑫 on 16/2/6.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "CocahModel.h"

@implementation CocahModel

+ (instancetype)CocahModel:(NSDictionary *)dict
{
    CocahModel*model = [[self alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
@end
