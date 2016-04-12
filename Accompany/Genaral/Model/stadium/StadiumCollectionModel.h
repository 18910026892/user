//
//  StadiumCollectionModel.h
//  Accompany
//
//  Created by 巩鑫 on 16/1/23.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseModel.h"

@interface StadiumCollectionModel : BaseModel


@property(nonatomic,copy)NSString * area;
@property(nonatomic,copy)NSString * city;
@property(nonatomic,copy)NSString * updateDate;
@property(nonatomic,copy)NSString * clubDesc;
@property(nonatomic,copy)NSString * clubName;
@property double latitude;
@property(nonatomic,copy)NSString * clubAddress;
@property(nonatomic,copy)NSString * clubId;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * isCollection;
@property(nonatomic,copy)NSString * province;
@property(nonatomic,copy)NSString * clubTel;
@property(nonatomic,copy)NSString * createDate;
@property double longitude;
@property(nonatomic,copy)NSString * clubImg;
@property(nonatomic,strong)NSArray * clubImgs;

@end
