//
//  JLPostListModel.h
//  Accompany
//
//  Created by 王园园 on 16/2/23.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseModel.h"

#import "JLPostUserInfoModel.h"

@interface JLPostListModel : BaseModel

@property(nonatomic,strong)NSArray *imageUrls;
@property(nonatomic,copy)NSString *remarkTotal;
@property(nonatomic,copy)NSString *sendDate;
@property(nonatomic,copy)NSString *vidosUrl;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *idea;
@property(nonatomic,copy)NSString *admireTotal;
@property(nonatomic,copy)NSString *postId;
@property(nonatomic,copy)NSString *communityId;
@property(nonatomic,copy)NSString *isAdmire;
@property(nonatomic,strong)JLPostUserInfoModel *grssUser;

@end

