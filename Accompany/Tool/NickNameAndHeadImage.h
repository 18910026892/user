//
//  NickNameAndHeadImage.h
//  Accompany
//
//  Created by GongXin on 16/2/19.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NickNameAndHeadImage : NSObject
//初始化单例
+(instancetype) shareInstance;

-(void)loadUserProfileInBackgroundWithBuddy:(NSArray*)buddyList;

-(void)loadUserProfileInBackgroundWithMessage:(NSArray*)messageList;

-(void)loadUserProfileInBackgroundWithApplicant:(NSArray*)applicantList;


-(void)loadUserProfileInBackgroundWithUserId:(NSString*)userId;


- (NSString*)getNicknameByUserName:(NSString*)username;

- (NSString*)getUserPhotoByUserName:(NSString*)username;

@end
