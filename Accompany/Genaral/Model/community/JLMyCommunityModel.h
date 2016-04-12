//
//  JLMyCommunityModel.h
//  Accompany
//
//  Created by 王园园 on 16/2/23.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseModel.h"
#import "JLPostUserInfoModel.h"
@interface JLMyCommunityModel : BaseModel

@property(nonatomic,copy)NSString *createUserId;
@property(nonatomic,copy)NSString *residentTotal;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *comment;
@property(nonatomic,copy)NSString *communityId;
@property(nonatomic,copy)NSString *topicTotal;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *isJoin;

@property(nonatomic,strong)JLPostUserInfoModel *grssUser;
@end
