//
//  JLChatViewController.m
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLChatViewController.h"
#import "JLSegmentView.h"
#import "JLAddFriendViewController.h"
#import "JLNearbyPeopleViewController.h"
#import "JLBarCodeViewController.h"
#import "JLMessageListViewController.h"
#import "JLSystemMessageViewController.h"
#import "JLStarLevelViewController.h"
#import "ChatViewController.h"
#import "JLWebViewController.h"
#import "JLPostDetailViewController.h"
#import "JLContactsViewController.h"
#import "JLApplyViewController.h"
const static CGFloat headerHeight = 44.0f;
static NSString *segOneTitle = @"聊天";
static NSString *segTwoTitle = @"好友";
static NSString *segThreeTitle = @"消息";
@interface JLChatViewController ()<UIScrollViewDelegate,messageListVCDelegate,SystemMessageVCDelegate,ContactsListVCDelegate>

@property(nonatomic,strong)JLMessageListViewController *messageListVC;
@property(nonatomic,strong)JLSystemMessageViewController *systemMessageVC;
@property(nonatomic,strong)JLContactsViewController * contactsVC;

@property(nonatomic,strong)JLStarLevelViewController *friendDynamicVC;

/**
 *  顶部SegView
 */
@property (nonatomic, strong) JLSegmentView *headerSegView;
@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation JLChatViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:NO];
    
    [self ContactsListReloadApplyView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarHide:NO];
    [self setupViews];
    [self setupDatas];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatmenuClick:) name:@"ChatMenuClick" object:nil];
    
    // Do any additional setup after loading the view.
 
}

-(void)setupViews
{
    [self.view addSubview:self.headerSegView];
    [self.view addSubview:self.scrollView];
   
     [self.RightBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    
    [self.RightBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)menuClick:(UIButton*)sender;
{
    [JLChatMenuView showOnWindow];
    
}
-(void)chatmenuClick:(NSNotification*)notification
{
    id obj = [notification object];
    
    NSString * String = [NSString stringWithFormat:@"%@",obj];
    
    if ([String isEqualToString:@"0"]) {
        JLAddFriendViewController *addController = [JLAddFriendViewController viewController];
        [self.navigationController pushViewController:addController animated:YES];
    }else if ([String isEqualToString:@"1"])
    {
        [self.navigationController pushViewController:[JLNearbyPeopleViewController viewController] animated:YES];
    }else if ([String isEqualToString:@"2"])
    {
        [self.navigationController pushViewController:[JLBarCodeViewController viewController] animated:YES];
    }
    
}


- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsWidth, kMainBoundsHeight-64)];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kMainBoundsWidth*3, _scrollView.height);
        _scrollView.scrollEnabled=  NO; 
        [self setChildViewController];
    }
    return _scrollView;
}
- (JLSegmentView *)headerSegView
{
    if(!_headerSegView){
        float margin = 60;
        _headerSegView = [[JLSegmentView alloc]initWithFrame:CGRectMake(margin,20, kMainBoundsWidth-margin*2, headerHeight)];
        _headerSegView.backgroundColor = [UIColor clearColor];
        [_headerSegView setTitleArr:@[segOneTitle,segTwoTitle,segThreeTitle] OneItemWidth:(kMainBoundsWidth-margin*2)/3 TitleFont:[UIFont boldSystemFontOfSize:15.]];
        _headerSegView.sliderWidth = 50;
        //点击切换
        __weak JLChatViewController *vc = self;
        _headerSegView.SegmentSelectedItemIndex = ^(NSInteger index){
            _headerIndex = index;
            [vc.scrollView setContentOffset:CGPointMake(vc.scrollView.width*index,0) animated:YES];
            [vc.headerSegView SegmentChangeWithScrollView:vc.scrollView contentOffset:vc.scrollView.contentOffset.x];
        };
    }
    return _headerSegView;
}



-(void)setChildViewController
{
    _messageListVC = [JLMessageListViewController viewController];
    _messageListVC.view.frame = CGRectMake(0,0, kMainBoundsWidth, kMainBoundsHeight-64-49);
    _messageListVC.MessageListdelegate = self;
    [_scrollView addSubview:_messageListVC.view];


    _contactsVC = [[JLContactsViewController alloc]init];
    _contactsVC.view.frame = CGRectMake(kMainBoundsWidth,0, kMainBoundsWidth, kMainBoundsHeight-113);
    _contactsVC.contactsDelegate = self;
    [_scrollView addSubview:_contactsVC.view];
    
    

    _systemMessageVC = [[JLSystemMessageViewController alloc]init];
    _systemMessageVC.view.frame = CGRectMake(kMainBoundsWidth*2,0, kMainBoundsWidth, kMainBoundsHeight-64-49);
    _systemMessageVC.delegate = self;
    [_scrollView addSubview:_systemMessageVC.view];
}
-(void)MessageListRefreshDataSource;
{
    if (!_messageListVC) {
        _messageListVC = [JLMessageListViewController viewController];
        _messageListVC.MessageListdelegate = self;
    }
    
    [_messageListVC refreshDataSource];
}

-(void)ContactsListReloadApplyView;
{
    if (!_contactsVC) {
        _contactsVC = [JLContactsViewController viewController];
        _contactsVC.contactsDelegate = self;
    }
    [_contactsVC reloadApplyView];
    
}
-(void)ContactsListRefreshDataSource;
{
    if (!_contactsVC) {
        _contactsVC = [JLContactsViewController viewController];
        _contactsVC.contactsDelegate = self;
    }
    [_contactsVC reloadDataSource];
}


-(void)setHeaderIndex:(NSInteger)headerIndex
{
    [_headerSegView itemSelectIndex:headerIndex];
    [_headerSegView SegmentChangeWithScrollView:_scrollView contentOffset:_scrollView.contentOffset.x];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    float page = _scrollView.contentOffset.x/_scrollView.width;
    if(page-(int)page==0){
        _headerIndex= (int)page;
        [_headerSegView itemSelectIndex:page];
    }else{
        [_headerSegView SegmentChangeWithScrollView:scrollView contentOffset:_scrollView.contentOffset.x];
    }
}


#pragma vc Delegat
-(void)viewcontroller:(JLMessageListViewController *)messageVC didSelectRowData:(id<IConversationModel>)conversationModel;
{
    
    EMConversation *conversation = conversationModel.conversation;
    
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.chatter conversationType:conversation.conversationType];
    chatController.title = conversationModel.title;
    [self.navigationController pushViewController:chatController animated:YES];
}
-(void)SearchViewController:(JLContactsViewController *)contactsVC didSelectRowmodel:(EMBuddy *)buddy;

{
    EMBuddy *Buddy = buddy;
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if (loginUsername && loginUsername.length > 0) {
        if ([loginUsername isEqualToString:Buddy.username]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
    }
    

    ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:Buddy.username
                                                                        conversationType:eConversationTypeChat];
 
    [self.navigationController pushViewController:chatVC animated:YES];
}
-(void)ViewController:(JLContactsViewController *)contactsVC didSelectRowmodel:(EaseUserModel*)UserModel;
{
    
    EaseUserModel * model = UserModel;
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if (loginUsername && loginUsername.length > 0) {
        if ([loginUsername isEqualToString:model.buddy.username]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
    }
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:model.buddy.username conversationType:eConversationTypeChat];
    chatController.title = model.nickname.length > 0 ? model.nickname : model.buddy.username;
    
    [self.navigationController pushViewController:chatController animated:YES];
}
-(void)gotoApplyViewController;
{
      [self.navigationController pushViewController:[JLApplyViewController viewController]animated:YES];
}


-(void)viewcontroller:(JLSystemMessageViewController*)messageVC didSelectSystemModel:(MessageModel*)messageModel;
{

    JLWebViewController * WebVc = [JLWebViewController viewController];
    WebVc.RequestUlr = messageModel.linkUrl;
    WebVc.WebTitle = messageModel.title;
    [self.navigationController pushViewController:WebVc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
