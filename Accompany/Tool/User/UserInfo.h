//
//  UserInfo.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject


+(UserInfo *)sharedUserInfo;

//需要和接口返回的字段同名
@property (nonatomic,copy)NSString * birthday;
@property (nonatomic,copy)NSString * city ;
@property (nonatomic,copy)NSString * coachType;
@property (nonatomic,copy)NSString * constellation;
@property (nonatomic,copy)NSString * infoComplete ;
@property (nonatomic,copy)NSString * isActivity ;
@property (nonatomic,copy)NSString * nikeName;
@property (nonatomic,copy)NSString * password;
@property (nonatomic,copy)NSString * regDate;
@property (nonatomic,copy)NSString * status;
@property (nonatomic,copy)NSString * token;
@property (nonatomic,copy)NSString * userDesc;
@property (nonatomic,copy)NSString * userHeight;
@property (nonatomic,copy)NSString * userId;
@property (nonatomic,copy)NSString * userPhone;
@property (nonatomic,copy)NSString * userPhoto;
@property (nonatomic,copy)NSString * userQQ;
@property (nonatomic,copy)NSString * userSex;
@property (nonatomic,copy)NSString * userType;
@property (nonatomic,copy)NSString * userWeibo;
@property (nonatomic,copy)NSString * userWeight;
@property (nonatomic,copy)NSString * userWeixin;
@property (nonatomic,copy)NSString * followCount;
@property (nonatomic,copy)NSString * fansCount;

@property(nonatomic,assign)BOOL isLog;


@property(nonatomic,strong)NSDictionary *userDict;
-(void)LoginWithDictionary:(NSDictionary *)dict;
-(void)Logout;
-(void)prinf;


@end
