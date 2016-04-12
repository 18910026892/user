//
//  JLCommentModel.m
//  Accompany
//
//  Created by GongXin on 16/3/30.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLCommentModel.h"

@implementation JLCommentModel
+ (instancetype)JLCommentModel:(NSDictionary *)dict
{
    JLCommentModel*model = [[self alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
@end
