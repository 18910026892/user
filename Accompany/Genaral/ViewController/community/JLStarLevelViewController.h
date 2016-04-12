//
//  JLStarLevelViewController.h
//  Accompany
//
//  Created by 王园园 on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JLStarLevelViewController;
@class JLPostListModel;
@class JLPostListCell;
@protocol StarLevelVCDelegate <NSObject>

-(void)starLevelViewController:(JLStarLevelViewController *)commVC didSelectData:(id)communityData;

//评论
-(void)starLeverVCcommentBtn:(UIButton *)commentBtn clickedWithData:(JLPostListModel *)celldata;
-(void)starPostCell:(JLPostListCell *)cell userImageTapWithData:(id)celldata;

@end

typedef NS_ENUM(NSUInteger,CommunityType){
    StarCommunity = 0,  //星级
    AttentionCommunity= 1, //关注
    PostCommunity= 2, //建外社区
    MyPostCommunity= 3,//我的动态
    FriendPostCommunity= 4,//好友的动态
    InvolvementPosts = 5 //我参与的动态
};

@interface JLStarLevelViewController : UIViewController

@property(nonatomic,assign)CommunityType type;
@property(nonatomic,copy)NSString *communityId;
@property(nonatomic,strong) id<StarLevelVCDelegate>delegate;
@end
