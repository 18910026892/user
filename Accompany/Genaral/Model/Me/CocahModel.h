//
//  CocahModel.h
//  Accompany
//
//  Created by 巩鑫 on 16/2/6.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CocahModel : NSObject

//{
//    area = "";
//    birthday = "1992-04-28 00:00:00";
//    city = "\U5317\U4eac";
//    coachType = "\U72c2\U70ed";
//    constellation = "\U91d1\U725b\U5ea7";
//    distance = "";
//    fansCount = "";
//    followCount = "";
//    followRelationship = 0;
//    grssClub =         {
//        area = "";
//        city = "";
//        clubAddress = "";
//        clubDesc = "";
//        clubId = 1;
//        clubImg = "";
//        clubImgs = "";
//        clubName = "\U573a\U99861";
//        clubTel = "";
//        createDate = "";
//        imgs = "";
//        isCollection = "";
//        latitude = "";
//        longitude = "";
//        province = "";
//        type = "";
//        updateDate = "";
//    };
//    grssCourse =         {
//        coachId = "";
//        id = "3ca77c4c-e13f-11e5-b4b3-00163e001bb1";
//        name = "\U4fdd\U51c6\U7626\U8170";
//        price = "18.8";
//    };
//    guidanceCount = "";
//    infoComplete = 0;
//    isActivity = 0;
//    lat = 0;
//    lng = 0;
//    nikeName = "\U9648\U5c0f\U6c99";
//    password = e10adc3949ba59abbe56e057f20f883e;
//    regCoachDate = "";
//    regDate = "2016-03-03 08:53:51";
//    status = 1;
//    token = "";
//    userDesc = "\U4ffa\U4ece\U6751\U91cc\U6765";
//    userHeight = 170cm;
//    userId = "65721a0c-e0da-11e5-b4b3-00163e001bb1";
//    userLevel = 1;
//    userPhone = 18888569655;
//    userPhoto = "http://wx.qlogo.cn/mmopen/ajNVdqHZLLDBkhodR5ZWODYVRyr2uSHXMBLDXwte7KVt0J2pTj9dXNvDDYfEt3micVSN1mJtejLHu47pdOaDnDg/0";
//    userQQ = "";
//    userSex = 1;
//    userType = coach;
//    userWeibo = "";
//    userWeight = 58kg;
//    userWeixin = "";
//}

@property (nonatomic,copy)NSDictionary * grssCourse;
@property (nonatomic,copy)NSDictionary * grssClub;
@property (nonatomic,copy)NSString * userLevel;
@property (nonatomic,copy)NSString * birthday;
@property (nonatomic,copy)NSString * nikeName;
@property (nonatomic,copy)NSString * userId;
@property (nonatomic,copy)NSString * userDesc;
@property (nonatomic,copy)NSString * userSex;
@property (nonatomic,copy)NSString * userPhoto;
@property (nonatomic,copy)NSString * constellation;
@property (nonatomic,copy)NSString * regCoachDate;
@property (nonatomic,copy)NSString * guidanceCount;





@end
