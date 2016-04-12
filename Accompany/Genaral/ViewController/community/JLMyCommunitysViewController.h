//
//  JLMyCommunitysViewController.h
//  Accompany
//
//  Created by 王园园 on 16/2/18.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger,CommunityListType){
    MyCommunity = 0,  //我的社区
    RecommendCommunity= 1 //推荐社区
};

@interface JLMyCommunitysViewController : BaseViewController
@property(nonatomic,assign)CommunityListType type;
@end
