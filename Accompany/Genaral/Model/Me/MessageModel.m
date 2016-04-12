//
//  MessageModel.m
//  syb
//
//  Created by GX on 15/11/7.
//  Copyright © 2015年 GX. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
+ (instancetype)MessageModel:(NSDictionary *)dict
{
    MessageModel*model = [[self alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
@end
