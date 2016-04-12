//
//  BaseModel.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "NSDictionary+Additional.h"
@interface BaseModel : NSObject

/*
 单个字典 → 单个模型
 
 + (instancetype)objectWithKeyValues:(NSDictionary *)keyValues
 */


/*
[　 字典1，
 
 　　　　　　　　字典2，
 
 　　　　　　　　字典3 　]

如果每个字典都是一个模型，可以用

NSArray *modelArray = [模型类名 objectArrayWithKeyValuesArray:字段数组];
*/




/*
在场景一的基础上，每个字典里面，有数组(假设数组的key值是arrayName)，数组里面存放着若干个相同的模型,使用下面的方法

使用方法：

首先在模型类.m文件中，引入#import "MJExtension.h"

然后在 @implementation 和 @end之间 写上

- (NSDictionary *)objectClassInArray

{
    return @{@"arrayName" : [模型类名 class]};
}
 */



/*
 如果 服务器传过来的 字典数组里的字典的Key，是OC里的关键字，而使用MJExtention的前提是，模型里的属性名和数组的key一致才行（区分大小写），怎么办？
 
 使用方法：1.在模型类.m文件
 
 + (NSDictionary *)replacedKeyFromPropertyName
 
 {
 
 return @{@“非关键字的属性名” : @“数组的key”};
 
 }
 */
@end
