//
//  JLOrderModel.h
//  Accompany
//
//  Created by GongXin on 16/3/12.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JLPostUserInfoModel.h"

@interface JLOrderExtModel : NSObject
@property (nonatomic,copy)NSString * age;
@property (nonatomic,copy)NSString * bloodPressure;
@property (nonatomic,copy)NSString * bodyFat;
@property (nonatomic,copy)NSString * frontImageUrl;
@property (nonatomic,copy)NSString * habitusExp;
@property (nonatomic,copy)NSString * height;
@property (nonatomic,copy)NSString * hipline;
@property (nonatomic,copy)NSString * hiplineRatio;
@property (nonatomic,copy)NSString * metabolismRatio;
@property (nonatomic,copy)NSString * rearImageUrl;
@property (nonatomic,copy)NSString * sex;
@property (nonatomic,copy)NSString * sideImageUrl;
@property (nonatomic,copy)NSString * stillHeartbeat;
@property (nonatomic,copy)NSString * userId;
@property (nonatomic,copy)NSString * waist;
@property (nonatomic,copy)NSString * weight;
@end

@interface JLOrderModel : NSObject


@property (nonatomic,copy)NSString * amount;//
@property (nonatomic,copy)NSString * coachComment;//

@property (nonatomic,copy)NSString * userId;//

@property (nonatomic,copy)NSString * name;//

@property (nonatomic,copy)NSString * orderId;//

@property (nonatomic,copy)NSString * orderDate;//

@property (nonatomic,copy)NSString * userComment;//

@property (nonatomic,copy)NSString * courseId;//

@property (nonatomic,copy)NSString * orderCount;//

@property (nonatomic,copy)NSString * state;//

@property (nonatomic,copy)NSString * payDate;//

@property(nonatomic,strong)JLPostUserInfoModel *grssUser;//
@property (nonatomic,strong)JLOrderExtModel * userEx;
@end
