//
//  JLPublicViewController.h
//  Accompany
//
//  Created by 王园园 on 16/2/18.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger,EnterPostType){
    postListType= 0, //建外社区
    AllPostListType = 1,  //首页的社区
    StarPostListType = 2,  //星级／关注社区
};

@interface JLPublicViewController : BaseViewController

@property(nonatomic,copy)NSString *communityId;
@property(nonatomic,assign)EnterPostType enterType;
@end
