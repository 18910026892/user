//
//  StadiumAdModel.h
//  Accompany
//
//  Created by 巩鑫 on 16/1/23.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseModel.h"

@interface StadiumAdModel : BaseModel

//图片的地址
@property(nonatomic,copy)NSString * imageUrl;

//点击的地址
@property(nonatomic,copy)NSString * linkUrl;

//二级页面的标题
@property(nonatomic,copy)NSString * title;



@end
