//
//  JLPostCommentListModel.h
//  Accompany
//
//  Created by 王园园 on 16/2/24.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseModel.h"

@interface JLPostCommentListModel : BaseModel

@property(nonatomic,copy)NSString *postsId;
@property(nonatomic,copy)NSString *postsUserId;
@property(nonatomic,copy)NSString *replyUserId;
@property(nonatomic,copy)NSString *remarkDate;
@property(nonatomic,copy)NSString *remarkUserImg;
@property(nonatomic,copy)NSString *replyName;
@property(nonatomic,copy)NSString *remarkName;
@property(nonatomic,copy)NSString *replyId;
@property(nonatomic,copy)NSString *remarkUserId;
@property(nonatomic,copy)NSString *content;
@end
