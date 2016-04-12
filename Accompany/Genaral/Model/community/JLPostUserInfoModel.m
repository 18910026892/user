//
//  JLPostUserInfoModel.m
//  Accompany
//
//  Created by 王园园 on 16/2/23.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLPostUserInfoModel.h"

@implementation JLPostUserInfoModel
+ (instancetype)JLPostUserInfoModel:(NSDictionary *)dict
{
    JLPostUserInfoModel*model = [[self alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
@end
