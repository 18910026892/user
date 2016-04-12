//
//  JLComRequestManager.m
//  Accompany
//
//  Created by 王园园 on 16/2/24.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLComRequestManager.h"
#import "HttpRequest.h"
#import "HDHud.h"
@implementation JLComRequestManager

//点赞
+(void)AdmirePostWithPostInfoModel:(JLPostListModel *)infoModel Success:(successGetData)success Fail:(failureData)fail netFail:(failureGetData)netFail;
{
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",infoModel.postId,@"postsId",nil];
    NSLog(@"%@,%@",URL_AdmirePost,pragma);
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_AdmirePost pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        success(response);
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        fail(message);
    } Failure:^(id error) {
        netFail(error);
    }];
}
//评论(回复)
+(void)CommentPostWithPostInfoModel:(JLPostListModel *)infoModel ReplyUserId:(NSString *)replyUserId Content:(NSString *)cotent Success:(successGetData)success Fail:(failureData)fail netFail:(failureGetData)netFail;
{
    NSMutableDictionary *pragma = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",cotent,@"content",infoModel.postId,@"postsId",nil];
    if(![Helper isBlankString:replyUserId]){
        [pragma setObject:replyUserId forKey:@"replyUserId"];
    }
    NSLog(@"%@%@",URL_PostCommentReply,pragma);
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_PostCommentReply pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        success(response);
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        fail(message);
    } Failure:^(id error) {
        netFail(error);
    }];
}

//关注/取消关注
+(void)attentionUserWithPostInfoModel:(JLPostUserInfoModel *)infoModel Success:(successGetData)success Fail:(failureData)fail netFail:(failureGetData)netFail;
{
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",infoModel.userId,@"userId",nil];
    NSString *url = URL_AttentionUser;
    if(infoModel.followRelationship.integerValue!=0){
        url = URL_CancelAttentionUser;
    }
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:url pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        success(response);
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        fail(message);
    } Failure:^(id error) {
        netFail(error);
    }];
}


//转帖
+(void)repasteWithPostInfoModel:(JLPostListModel *)infoModel Success:(successGetData)success Fail:(failureData)fail netFail:(failureGetData)netFail;
{
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",infoModel.postId,@"postsId",nil];
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_RepastePost pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        success(response);
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        fail(message);
    } Failure:^(id error) {
        netFail(error);
    }];
}

//删帖
+(void)deleteWithPostInfoModel:(JLPostListModel *)infoModel Success:(successGetData)success Fail:(failureData)fail netFail:(failureGetData)netFail;
{
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",infoModel.postId,@"postsId",nil];
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_DeletePost pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        success(response);
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        fail(message);
    } Failure:^(id error) {
        netFail(error);
    }];
}
@end
