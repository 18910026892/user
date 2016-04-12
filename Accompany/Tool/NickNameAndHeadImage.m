//
//  NickNameAndHeadImage.m
//  Accompany
//
//  Created by GongXin on 16/2/19.
//  Copyright © 2016年 GX. All rights reserved.
//
#define dUserDefaults_Dic_NickName @"dUserDefaults_Dic_NickName"
#define dUserDefaults_Dic_UserPhoto @"dUserDefaults_Dic_UserPhoto"
#define dUserDefaults_String_LoginToken @"dUserDefaults_String_LoginToken"

#import "NickNameAndHeadImage.h"
#import "InvitationManager.h"

@interface NickNameAndHeadImage()

@property (strong, nonatomic) NSMutableArray *UserNames;

@property (strong, nonatomic) NSMutableDictionary *NickNames;

@property (nonatomic,strong) NSMutableDictionary * UserPhotos;

@property (nonatomic) BOOL DownloadHasDone;

@property (nonatomic) BOOL LoadFromLocalDickDone;


@end

@implementation NickNameAndHeadImage
{
    UserInfo * userInfo;
}
static NickNameAndHeadImage* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _DownloadHasDone = NO;
        _LoadFromLocalDickDone = NO;
        _UserNames = [NSMutableArray array];
        NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:dUserDefaults_Dic_NickName];
        if (dic == nil || [dic count] == 0) {
            _NickNames = [NSMutableDictionary dictionary];
            _LoadFromLocalDickDone = YES;
        }
        else
        {
            _LoadFromLocalDickDone = YES;
            _NickNames = [NSMutableDictionary dictionaryWithDictionary:dic];
        }
        
        
         NSMutableDictionary *dic1 = [[NSUserDefaults standardUserDefaults] objectForKey:dUserDefaults_Dic_UserPhoto];
        
        
        if (dic1 == nil || [dic1 count] == 0) {
            _UserPhotos = [NSMutableDictionary dictionary];
            _LoadFromLocalDickDone = YES;
        }
        else
        {
            _LoadFromLocalDickDone = YES;
            _UserPhotos = [NSMutableDictionary dictionaryWithDictionary:dic1];
        }
        
    }
    return self;
}


- (void)loadUserProfileInBackgroundWithBuddy:(NSArray*)buddyList
{
    _DownloadHasDone = NO;
    [_UserNames removeAllObjects];
    [_NickNames removeAllObjects];
    [_UserPhotos removeAllObjects];
    
    if (buddyList == nil || [buddyList count] == 0)
    {
        return;
    }
    else
    {
        for (EMBuddy *buddy in buddyList)
        {
            [_UserNames addObject:buddy.username];
        }
    }
    
    [self loadUserProfileInBackgroundWithUsernames];
}

-(void)loadUserProfileInBackgroundWithApplicant:(NSArray*)applicantList;
{
    _DownloadHasDone = NO;
    [_UserNames removeAllObjects];
    [_NickNames removeAllObjects];
    [_UserPhotos removeAllObjects];
    
    if (applicantList == nil || [applicantList count] == 0)
    {
        return;
    }
    else
    {
        for (ApplyEntity * entity in applicantList)
        {
            NSLog(@"%@",entity.applicantUsername);
            [_UserNames addObject:entity.applicantUsername];
        }
    }
    
    [self loadUserProfileInBackgroundWithUsernames1];
}

-(void)loadUserProfileInBackgroundWithMessage:(NSArray*)messageList;
{
    _DownloadHasDone = NO;
    [_UserNames removeAllObjects];
    [_NickNames removeAllObjects];
    [_UserPhotos removeAllObjects];
    
    if (messageList == nil || [messageList count] == 0)
    {
        return;
    }
    else
    {
        for (id<IConversationModel> model in messageList)
        {
            [_UserNames addObject:model.title];
        }
    }
    
    [self loadUserProfileInBackgroundWithUsernames];
}
-(void)loadUserProfileInBackgroundWithUserId:(NSString*)userId;
{
    _DownloadHasDone = NO;
    [_UserNames removeAllObjects];
    [_NickNames removeAllObjects];
    [_UserPhotos removeAllObjects];
    
    if (userId == nil )
    {
        return;
    }
    else
    {
        [_UserNames addObject:userId];
     
    }
    [self loadUserProfileInBackgroundWithUsernames];
}

- (void)loadUserProfileInBackgroundWithUsernames
{
    
    _DownloadHasDone = NO;
  
    NSString *  ids =  [_UserNames componentsJoinedByString:@","];
  
    userInfo = [UserInfo sharedUserInfo];
    
    NSString * token = userInfo.token;
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",ids,@"userIds", nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    
    [request RequestDataWithUrl:URL_listUsersByIds pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        
       // NSLog(@"_______%@",obj);
     
        for (NSDictionary *dic in obj) {
            [_NickNames setObject: [dic objectForKey:@"nikeName"] forKey: [dic objectForKey:@"userId"]];
            
            [_UserPhotos setObject: [dic objectForKey:@"userPhoto"] forKey: [dic objectForKey:@"userId"]];
        }
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:_NickNames forKey:dUserDefaults_Dic_NickName];
        [ud setObject:_UserPhotos forKey:dUserDefaults_Dic_UserPhoto];
        [ud synchronize];
        _LoadFromLocalDickDone = YES;
        
        _DownloadHasDone = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNickNameAndPhoto" object:nil];
        
    };
    request.failureDataBlock = ^(id error)
    {
    
        NSString * message = (NSString *)error;
        NSLog(@"%@",message);
    };
    request.failureBlock = ^(id obj){

    };
    
 
}

- (void)loadUserProfileInBackgroundWithUsernames1
{
    _DownloadHasDone = NO;
    
    NSString *  ids =  [_UserNames componentsJoinedByString:@","];
    
    userInfo = [UserInfo sharedUserInfo];
    
    NSString * token = userInfo.token;
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",ids,@"userIds", nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    
    [request RequestDataWithUrl:URL_listUsersByIds pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        
        // NSLog(@"_______%@",obj);
        
        for (NSDictionary *dic in obj) {
            [_NickNames setObject: [dic objectForKey:@"nikeName"] forKey: [dic objectForKey:@"userId"]];
            
            [_UserPhotos setObject: [dic objectForKey:@"userPhoto"] forKey: [dic objectForKey:@"userId"]];
        }
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:_NickNames forKey:dUserDefaults_Dic_NickName];
        [ud setObject:_UserPhotos forKey:dUserDefaults_Dic_UserPhoto];
        [ud synchronize];
        _LoadFromLocalDickDone = YES;
        
        _DownloadHasDone = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNickNameAndPhoto1" object:nil];
        
    };
    request.failureDataBlock = ^(id error)
    {
        
        NSString * message = (NSString *)error;
        NSLog(@"%@",message);
    };
    request.failureBlock = ^(id obj){
        
    };
}



- (NSString*)getUserPhotoByUserName:(NSString*)username;
{
    
    if(_DownloadHasDone == YES)
    {
        NSString *string = [_UserPhotos objectForKey:username];
        
        NSLog(@"%@",string);
        
        if (string == nil || [string length] == 0) {
            return username;
        }
        return string;
    }
    
    else if(_LoadFromLocalDickDone == YES)
    {
        NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:dUserDefaults_Dic_UserPhoto];
        NSString *string = [dic objectForKey:username];
        if (string == nil || [string length] == 0) {
            return username;
        }
        return string;
    }
    return username;
}
- (NSString*)getNicknameByUserName:(NSString*)username
{
    if(_DownloadHasDone == YES)
    {
        NSString *string = [_NickNames objectForKey:username];
        if (string == nil || [string length] == 0) {
            return username;
        }
        return string;
    }
    
    else if(_LoadFromLocalDickDone == YES)
    {
        NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:dUserDefaults_Dic_NickName];
        NSString *string = [dic objectForKey:username];
        if (string == nil || [string length] == 0) {
            return username;
        }
        return string;
    }
    return username;
}
@end
