//
//  JLComRequestManager.h
//  Accompany
//
//  Created by 王园园 on 16/2/24.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLPostListModel.h"
#import "JLPostUserInfoModel.h"
typedef void(^successGetData)(id response);
typedef void(^failureData)(id error);
typedef void(^failureGetData)(id error);

@interface JLComRequestManager : NSObject

@property(nonatomic,strong) successGetData successBlock;
@property(nonatomic,strong) failureData failureDataBlock;
@property(nonatomic,strong) failureGetData failureBlock;

//点赞
+(void)AdmirePostWithPostInfoModel:(JLPostListModel *)infoModel Success:(successGetData)success Fail:(failureData)fail netFail:(failureGetData)netFail;

//评论(回复)
+(void)CommentPostWithPostInfoModel:(JLPostListModel *)infoModel ReplyUserId:(NSString *)replyUserId Content:(NSString *)cotent Success:(successGetData)success Fail:(failureData)fail netFail:(failureGetData)netFail;

//关注
+(void)attentionUserWithPostInfoModel:(JLPostUserInfoModel *)infoModel Success:(successGetData)success Fail:(failureData)fail netFail:(failureGetData)netFail;
//转帖
+(void)repasteWithPostInfoModel:(JLPostListModel *)infoModel Success:(successGetData)success Fail:(failureData)fail netFail:(failureGetData)netFail;
//删帖
+(void)deleteWithPostInfoModel:(JLPostListModel *)infoModel Success:(successGetData)success Fail:(failureData)fail netFail:(failureGetData)netFail;
@end
