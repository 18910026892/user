//
//  URLPathMacro.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#ifndef URLPathMacro_h
#define URLPathMacro_h


//API


//项目API
#define MainURL @"http://grss.goodbuild.cn/grss/api/"

#define BaseURL(urlName) [MainURL stringByAppendingString:urlName]

//*注册接口1
#define URL_Register [MainURL stringByAppendingString:[NSString stringWithFormat:@"register"]]

//短信验证码2
#define URL_sendVerifyCode [MainURL stringByAppendingString:[NSString stringWithFormat:@"sendVerifyCode"]]

//*忘记密码3
#define URL_forgetPassword [MainURL stringByAppendingString:[NSString stringWithFormat:@"forgetPassword"]]

//*登录4
#define URL_login [MainURL stringByAppendingString:[NSString stringWithFormat:@"login"]]

//*修改密码 5
#define URL_updatePassword [MainURL stringByAppendingString:[NSString stringWithFormat:@"updatePassword"]]

//*绑定手机号6
#define URL_bindingPhone [MainURL stringByAppendingString:[NSString stringWithFormat:@"bindingPhone"]]

//*修改手机号7
#define URL_changePhone [MainURL stringByAppendingString:[NSString stringWithFormat:@"changePhone"]]

//*修改个人信息8
#define URL_updateUser [MainURL stringByAppendingString:[NSString stringWithFormat:@"updateUser"]]


//*首页9
#define URL_homePage [MainURL stringByAppendingString:[NSString stringWithFormat:@"homePage"]]


//*场馆列表10
#define URL_listByGrssClub [MainURL stringByAppendingString:[NSString stringWithFormat:@"listByGrssClub"]]

//*教练列表11
#define URL_listCoachByClub [MainURL stringByAppendingString:[NSString stringWithFormat:@"listCoachByClub"]]

//*用户反馈12
#define URL_feedback [MainURL stringByAppendingString:[NSString stringWithFormat:@"feedback"]]


//*我的关注
#define URL_followUserList [MainURL stringByAppendingString:[NSString stringWithFormat:@"followUserList"]]

//*我的粉丝
#define URL_fansUserList [MainURL stringByAppendingString:[NSString stringWithFormat:@"fansUserList"]]


//用户信息获取
#define URL_getUser [MainURL stringByAppendingString:[NSString stringWithFormat:@"getUser"]]
//绑定银行卡
#define URL_bindingBank [MainURL stringByAppendingString:[NSString stringWithFormat:@"bindingBank"]]

//系统设置
#define URL_userSysSetup [MainURL stringByAppendingString:[NSString stringWithFormat:@"userSysSetup"]]

//我的消息
#define URL_getSysMessage [MainURL stringByAppendingString:[NSString stringWithFormat:@"getSysMessage"]]

//删除消息
#define URL_delSysMessage [MainURL stringByAppendingString:[NSString stringWithFormat:@"delSysMessage"]]
//场馆收藏
#define URL_collectClub [MainURL stringByAppendingString:[NSString stringWithFormat:@"collectClub"]]
//取消收藏
#define URL_cancelCollect [MainURL stringByAppendingString:[NSString stringWithFormat:@"cancelCollect"]]

//我的收藏
#define URL_collectClubList [MainURL stringByAppendingString:[NSString stringWithFormat:@"collectClubList"]]

//绑定身份证
#define URL_uploadIdentityCardImg [MainURL stringByAppendingString:[NSString stringWithFormat:@"uploadIdentityCardImg"]]
//绑定资格证书
#define URL_uploadCertificationImg [MainURL stringByAppendingString:[NSString stringWithFormat:@"uploadCertificationImg"]]
//申请教练
#define URL_applyCoachAualification [MainURL stringByAppendingString:[NSString stringWithFormat:@"applyCoachAualification"]]

//根据用户ID差用户
#define URL_listUsersByIds [MainURL stringByAppendingString:[NSString stringWithFormat:@"listUsersByIds"]]

//用户订单量查询
#define URL_getOrderCounts  [MainURL stringByAppendingString:[NSString stringWithFormat:@"getOrderCounts"]]

//订单列表
#define URL_getCourseOrder  [MainURL stringByAppendingString:[NSString stringWithFormat:@"getCourseOrder"]]

//设置课程信息
#define URL_setUpCourse  [MainURL stringByAppendingString:[NSString stringWithFormat:@"setUpCourse"]]

//用户资产
#define URL_getUserAssets  [MainURL stringByAppendingString:[NSString stringWithFormat:@"getUserAssets"]]

//获取优惠券
#define URL_getUserPromos  [MainURL stringByAppendingString:[NSString stringWithFormat:@"getUserPromos"]]

//用户详情页权限
#define URL_getUserSetUp  [MainURL stringByAppendingString:[NSString stringWithFormat:@"getUserSetUp"]]

//用户经纬度更新
#define URL_renewCoordinate  [MainURL stringByAppendingString:[NSString stringWithFormat:@"renewCoordinate"]]

//附近的人
#define URL_searchNearbyUser  [MainURL stringByAppendingString:[NSString stringWithFormat:@"searchNearbyUser"]]
//搜索好友
#define URL_searchUser  [MainURL stringByAppendingString:[NSString stringWithFormat:@"searchUser"]]

//教练评论列表
#define URL_coachCommentList  [MainURL stringByAppendingString:[NSString stringWithFormat:@"coachCommentList"]]

//兑换券
#define URL_exchangePromo  [MainURL stringByAppendingString:[NSString stringWithFormat:@"exchangePromo"]]

//我参与的动态
#define URL_involvementPosts  [MainURL stringByAppendingString:[NSString stringWithFormat:@"involvementPosts"]]
//提现
#define URL_drawMoney  [MainURL stringByAppendingString:[NSString stringWithFormat:@"drawMoney"]]
//订单创建
#define URL_creatOrder  [MainURL stringByAppendingString:[NSString stringWithFormat:@"createOrder"]]


#pragma mark - 社区
//创建社区
#define URL_CreatCommunity BaseURL(@"createCommunity")
//我的社区列表
#define URL_MyCommunity BaseURL(@"getMyCommunity")
//推荐社区列表
#define URL_RecommentCommunity BaseURL(@"recommendCommunity")
//社区详情——帖子列表
#define URL_CommunityDetail BaseURL(@"getCommunityDetail")
//所有的帖子列表
#define URL_CommunityAllPostList BaseURL(@"getCommunityPosts")
//星级帖子列表
#define URL_CommunityStarPostList BaseURL(@"starLevel")
//关注的帖子列表
#define URL_CommunityAttentionPostList BaseURL(@"getFollowPosts")
//关注的帖子列表
#define URL_CommunityMyPostList BaseURL(@"getMyPostsList")
//发布帖子
#define URL_PublishPosts BaseURL(@"publishPosts")
//举报社区
#define URL_JubaoCommunity BaseURL(@"snitch")
//搜索社区
#define URL_SearchCommunity BaseURL(@"searchCommunity")
//帖子点赞
#define URL_AdmirePost BaseURL(@"admireOrCancelPosts")
//帖子动态
#define URL_PostDetail BaseURL(@"getDynamic")
//帖子点赞人员
#define URL_AdmireLimitPeoples BaseURL(@"getAdmireLimit")
//帖子点赞所有人员(加分页)
#define URL_AdmirePeoples BaseURL(@"getAdmireList")
//帖子品论列表
#define URL_PostCommentList BaseURL(@"getComment")
//帖子评论回复
#define URL_PostCommentReply BaseURL(@"replyPosts")
//关注用户
#define URL_AttentionUser BaseURL(@"followUser")
//取消关注用户
#define URL_CancelAttentionUser BaseURL(@"unFollowUser")
//转帖
#define URL_RepastePost BaseURL(@"repaste")
//删帖
#define URL_DeletePost BaseURL(@"deletePosts")
//加入社区
#define URL_JoinCommunity BaseURL(@"joinCommunity")
//退出社区
#define URL_QuitCommunity BaseURL(@"quitCommunity")
//社区信息
#define URL_GetCommunityInfo BaseURL(@"getCommunityInfo")
//社区居民
#define URL_GetCommunityUsers BaseURL(@"getCommunityUser")
//邀请好友
#define URL_InvitationFriend BaseURL(@"invitationFriend")
//其他人的动态
#define URL_GetUserPostList BaseURL(@"getUserPostsList")
//社区踢人
#define URL_CommunityRemoveUsers BaseURL(@"removeCommunityUser")
//处理订单
#define URL_handleOrder BaseURL(@"handleOrder")


///////////////Video////////////////
//视频一级分类
#define URL_VideoParentList BaseURL(@"getParentCategoryList")
//视频子分类
#define URL_VideoSubList BaseURL(@"getSubCategoryList")
//视频列表
#define URL_VideoList BaseURL(@"getVideoList")

#endif /* URLPathMacro_h */
