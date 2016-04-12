//
//  UserInfo.m
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "UserInfo.h"
#import "Helper+UserDefault.h"

@implementation UserInfo

NSString *const kBaseId = @"userId";
NSString *const kBaseToken = @"token";
NSString *const kBaseBirthday = @"birthday";
NSString *const kBaseCity = @"city";
NSString *const kBaseCoachType = @"coachType";
NSString *const kBaseConstellation = @"constellation";
NSString *const kBaseInfoComplete = @"infoComplete";
NSString *const kBaseIsActivity = @"isActivity";
NSString *const kBaseNikeName = @"nikeName";
NSString *const kBasePassword = @"password";
NSString *const kBaseRegDate= @"regDate";
NSString *const kBaseStatus= @"status";
NSString *const kBaseUserDesc= @"userDesc";
NSString *const kBaseUserHeight= @"userHeight";
NSString *const kBaseUserPhone= @"userPhone";
NSString *const kBaseUserPhoto= @"userPhoto";
NSString *const kBaseUserQQ= @"userQQ";
NSString *const kBaseUserSex= @"userSex";
NSString *const kBaseUserType= @"userType";
NSString *const kBaseUserWeibo= @"userWeibo";
NSString *const kBaseUserWeight= @"userWeight";
NSString *const kBaseUserWeixin= @"userWeixin";
NSString *const kBasefansCount = @"fansCount";
NSString *const kBasefollowCount = @"followCount";



+(UserInfo *)sharedUserInfo
{
    static UserInfo *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[UserInfo alloc] init];
        
        sharedManager.birthday = [Helper valueWithKey:kBaseBirthday];
        sharedManager.city = [Helper valueWithKey:kBaseCity];
        sharedManager.coachType = [Helper valueWithKey:kBaseCoachType];
        sharedManager.constellation = [Helper valueWithKey:kBaseConstellation];
        sharedManager.infoComplete = [Helper valueWithKey:kBaseInfoComplete];
        sharedManager.isActivity =[Helper valueWithKey:kBaseIsActivity];
        sharedManager.nikeName = [Helper valueWithKey:kBaseNikeName];
        sharedManager.password = [Helper valueWithKey:kBasePassword];
        sharedManager.regDate = [Helper valueWithKey:kBaseRegDate];
        sharedManager.status = [Helper valueWithKey:kBaseStatus];
        sharedManager.token = [Helper valueWithKey:kBaseToken];
        sharedManager.userDesc = [Helper valueWithKey:kBaseUserDesc];
        sharedManager.userHeight = [Helper valueWithKey:kBaseUserHeight];
        sharedManager.userId = [Helper valueWithKey:kBaseId];
        sharedManager.userPhone = [Helper valueWithKey:kBaseUserPhone];
        sharedManager.userPhoto = [Helper valueWithKey:kBaseUserPhoto];
        sharedManager.userQQ = [Helper valueWithKey:kBaseUserQQ];
        sharedManager.userSex = [Helper valueWithKey:kBaseUserSex];
        sharedManager.userType = [Helper valueWithKey:kBaseUserType];
        sharedManager.userWeibo = [Helper valueWithKey:kBaseUserWeibo];
        sharedManager.userWeight = [Helper valueWithKey:kBaseUserWeight];
        sharedManager.userWeixin = [Helper valueWithKey:kBaseUserWeixin];

        sharedManager.fansCount = [Helper valueWithKey:kBasefansCount];

        sharedManager.followCount = [Helper valueWithKey:kBasefollowCount];
        sharedManager.isLog = NO;
   
        
    });
    
    return sharedManager;
}


-(void)LoginWithDictionary:(NSDictionary *)dict{
    
    [Helper saveValue:dict forKey:KUSERINFO_Dict];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.isLog = YES;
    
        [Helper saveValue:[self objectOrNilForKey:kBaseBirthday fromDictionary:dict] forKey:kBaseBirthday];
        [Helper saveValue:[self objectOrNilForKey:kBaseCity fromDictionary:dict] forKey:kBaseCity];
        [Helper saveValue:[self objectOrNilForKey:kBaseCoachType fromDictionary:dict] forKey:kBaseCoachType];
        [Helper saveValue:[self objectOrNilForKey:kBaseConstellation fromDictionary:dict] forKey:kBaseConstellation];
        [Helper saveValue:[self objectOrNilForKey:kBaseInfoComplete fromDictionary:dict] forKey:kBaseInfoComplete];
        [Helper saveValue:[self objectOrNilForKey:kBaseIsActivity fromDictionary:dict] forKey:kBaseIsActivity];
        [Helper saveValue:[self objectOrNilForKey:kBaseNikeName fromDictionary:dict] forKey:kBaseNikeName];
        [Helper saveValue:[self objectOrNilForKey:kBasePassword fromDictionary:dict] forKey:kBasePassword];
        [Helper saveValue:[self objectOrNilForKey:kBaseRegDate fromDictionary:dict] forKey:kBaseRegDate];
        [Helper saveValue:[self objectOrNilForKey:kBaseStatus fromDictionary:dict] forKey:kBaseStatus];
        [Helper saveValue:[self objectOrNilForKey:kBaseToken fromDictionary:dict] forKey:kBaseToken];
        [Helper saveValue:[self objectOrNilForKey:kBaseUserDesc fromDictionary:dict] forKey:kBaseUserDesc];
        [Helper saveValue:[self objectOrNilForKey:kBaseUserHeight fromDictionary:dict] forKey:kBaseUserHeight];
        [Helper saveValue:[self objectOrNilForKey:kBaseId fromDictionary:dict] forKey:kBaseId];
        [Helper saveValue:[self objectOrNilForKey:kBaseUserPhone fromDictionary:dict] forKey:kBaseUserPhone];
        [Helper saveValue:[self objectOrNilForKey:kBaseUserPhoto fromDictionary:dict] forKey:kBaseUserPhoto];
        [Helper saveValue:[self objectOrNilForKey:kBaseUserQQ fromDictionary:dict] forKey:kBaseUserQQ];
        [Helper saveValue:[self objectOrNilForKey:kBaseUserSex fromDictionary:dict] forKey:kBaseUserSex];
        [Helper saveValue:[self objectOrNilForKey:kBaseUserType fromDictionary:dict] forKey:kBaseUserType];
        [Helper saveValue:[self objectOrNilForKey:kBaseUserWeibo fromDictionary:dict] forKey:kBaseUserWeibo];
        [Helper saveValue:[self objectOrNilForKey:kBaseUserWeight fromDictionary:dict] forKey:kBaseUserWeight];
        [Helper saveValue:[self objectOrNilForKey:kBaseUserWeixin fromDictionary:dict] forKey:kBaseUserWeixin];
         [Helper saveValue:[self objectOrNilForKey:kBasefollowCount  fromDictionary:dict] forKey:kBasefollowCount];
          [Helper saveValue:[self objectOrNilForKey:kBasefansCount fromDictionary:dict] forKey:kBasefansCount];

        
        
        self.birthday = [Helper valueWithKey:kBaseBirthday];
        self.city = [Helper valueWithKey:kBaseCity];
        self.coachType = [Helper valueWithKey:kBaseCoachType];
        self.constellation = [Helper valueWithKey:kBaseConstellation];
        self.infoComplete = [Helper valueWithKey:kBaseInfoComplete];
        self.isActivity =[Helper valueWithKey:kBaseIsActivity];
        self.nikeName = [Helper valueWithKey:kBaseNikeName];
        self.password = [Helper valueWithKey:kBasePassword];
        self.regDate = [Helper valueWithKey:kBaseRegDate];
        self.status = [Helper valueWithKey:kBaseStatus];
        self.token = [Helper valueWithKey:kBaseToken];
        self.userDesc = [Helper valueWithKey:kBaseUserDesc];
        self.userHeight = [Helper valueWithKey:kBaseUserHeight];
        self.userId = [Helper valueWithKey:kBaseId];
        self.userPhone = [Helper valueWithKey:kBaseUserPhone];
        self.userPhoto = [Helper valueWithKey:kBaseUserPhoto];
        self.userQQ = [Helper valueWithKey:kBaseUserQQ];
        self.userSex = [Helper valueWithKey:kBaseUserSex];
        self.userType = [Helper valueWithKey:kBaseUserType];
        self.userWeibo = [Helper valueWithKey:kBaseUserWeibo];
        self.userWeight = [Helper valueWithKey:kBaseUserWeight];
        self.userWeixin = [Helper valueWithKey:kBaseUserWeixin];
        self.fansCount = [Helper valueWithKey:kBasefansCount];
        self.followCount =[Helper valueWithKey:kBasefollowCount];
        

        
       
    }
    _userDict = dict;
}


-(void)Logout{
    
    
    [Helper removeValueforKey:KUSERINFO_Dict];
    [Helper removeValueforKey:kBaseBirthday];
    [Helper removeValueforKey:kBaseCity];
    [Helper removeValueforKey:kBaseCoachType];
    [Helper removeValueforKey:kBaseConstellation];
    [Helper removeValueforKey:kBaseInfoComplete];
    [Helper removeValueforKey:kBaseIsActivity];
    [Helper removeValueforKey:kBaseNikeName];
    [Helper removeValueforKey:kBasePassword];
    [Helper removeValueforKey:kBaseRegDate];
    [Helper removeValueforKey:kBaseStatus];
    [Helper removeValueforKey:kBaseToken];
    [Helper removeValueforKey:kBaseUserDesc];
    [Helper removeValueforKey:kBaseUserHeight];
    [Helper removeValueforKey:kBaseId];
    [Helper removeValueforKey:kBaseUserPhone];
    [Helper removeValueforKey:kBaseUserPhoto];
    [Helper removeValueforKey:kBaseUserQQ];
    [Helper removeValueforKey:kBaseUserSex];
    [Helper removeValueforKey:kBaseUserType];
    [Helper removeValueforKey:kBaseUserWeibo];
    [Helper removeValueforKey:kBaseUserWeight];
    [Helper removeValueforKey:kBaseUserWeixin];

    [Helper removeValueforKey:kBasefollowCount];
    [Helper removeValueforKey:kBasefansCount];
    
    
    [Helper removeValueforKey:@"newFans"];
    [Helper removeValueforKey:@"praise"];
    [Helper removeValueforKey:@"privateChat"];
    [Helper removeValueforKey:@"reply"];
    [Helper removeValueforKey:@"systemMessage"];
    
    //余额
    [Helper removeValueforKey:@"AccountBalance"];

    
    
    
    //身份证
    [Helper removeValueforKey:@"identityCardUrl"];
    
    //资质证明
    [Helper removeValueforKey:@"certificationUrl"];
    
    
    //账户相关
    [Helper removeValueforKey:@"cardNo"];
    [Helper removeValueforKey:@"openAccountBank"];
    [Helper removeValueforKey:@"openAccountCity"];
    [Helper removeValueforKey:@"openAccountName"];
    
    self.isLog = NO;
    self.birthday = nil;
    self.city = nil;
    self.coachType = nil;
    self.constellation = nil;
    self.infoComplete = nil;
    self.isActivity =nil;
    self.nikeName = nil;
    self.password = nil;
    self.regDate = nil;
    self.status = nil;
    self.token = nil;
    self.userDesc = nil;
    self.userHeight = nil;
    self.userId = nil;
    self.userPhone = nil;
    self.userPhoto = nil;
    self.userQQ = nil;
    self.userSex = nil;
    self.userType = nil;
    self.userWeibo = nil;
    self.userWeight = nil;
    self.userWeixin = nil;

    self.followCount = nil;
    self.fansCount = nil;
    
     [UserDefaultsUtils saveValue:@"" forKey:@"PerfectAccount"];
 
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? @"" : object;
}

-(void)prinf{
    for(NSString *key in [_userDict allKeys]){
        NSLog(@"%@===%@",key,[_userDict objectForKey:key]);
    }
}


@end
