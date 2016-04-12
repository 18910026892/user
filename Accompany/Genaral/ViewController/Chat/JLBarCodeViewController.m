//
//  JLBarCodeViewController.m
//  Accompany
//
//  Created by 巩鑫 on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLBarCodeViewController.h"
#import "JLApplyViewController.h"
#import "JLAddFriendCell.h"
#import "InvitationManager.h"

@implementation JLBarCodeViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:YES];
    [_readView flushCache];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _lineView.frame = CGRectMake(10*Proportion, 10*Proportion, 220*Proportion, 2*Proportion);
    _num = 0;
    _upOrdown = NO;
    [_readView stop];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _num = 0;
    _upOrdown = NO;
    [self setNavTitle:@"扫一扫"];
    [self showBackButton:YES];
    [self setNavigationBarHide:NO];
    [self setupViews];
}

-(void)setupViews
{
    [self.view addSubview:self.readView];
    [self.view addSubview:self.alertLabel];
    //定时器，设定时间过0.02秒，
    _timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    [_readView start];
}
-(ZBarReaderView*)readView
{
    if (!_readView) {
        _readView = [ZBarReaderView new];
        _readView.readerDelegate = self;
        _readView.torchMode = 0;
        _readView.allowsPinchZoom = NO;
        _readView.tracksSymbols = NO;
        _readView.frame =  CGRectMake(-(kMainBoundsHeight-kMainBoundsWidth-64)/2, 64,kMainBoundsHeight-64, kMainBoundsHeight-64);
        _readView.layer.borderColor = RGBACOLOR(1, 1, 1,0.4).CGColor;
        _readView.layer.borderWidth = 164*Proportion-32;
        //扫描区域
        CGRect scanMaskRect = CGRectMake((kMainBoundsHeight-kMainBoundsWidth-64)/2+40*Proportion, kMainBoundsHeight/2-120*Proportion-32, 240*Proportion, 240*Proportion);
        _readView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:_readView.bounds];
        
         [_readView addSubview:self.centerImageView];
    }
    return _readView;
}

-(UIImageView*)lineView
{
    if(!_lineView)
    {
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10*Proportion, 10*Proportion, 220*Proportion, 2*Proportion)];
        _lineView.image = [UIImage imageNamed:@"barcodeLine"];
        
    }
    return _lineView;

}
-(UIImageView*)centerImageView
{
    if(!_centerImageView)
    {
        _centerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barcodeCenter"]];
        _centerImageView.frame =  CGRectMake((kMainBoundsHeight-kMainBoundsWidth-64)/2+40*Proportion,kMainBoundsHeight/2-120*Proportion-32, 240*Proportion, 240*Proportion);
        [_centerImageView addSubview:self.lineView];
       
    }
    return _centerImageView;
}

-(UILabel*)alertLabel

{
    if(!_alertLabel)
    {
        _alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, kMainBoundsHeight/2-120*Proportion-12,kMainBoundsWidth-40, 20)];
        _alertLabel.text = @"对准二维码/条形码到框内即可扫描";
        _alertLabel.textColor = [UIColor whiteColor];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.font = [UIFont boldSystemFontOfSize:14.0];
        
        
    }
    return _alertLabel;

}
-(UIButton*)lightButton
{
    if (!_lightButton) {
        _lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lightButton.frame = CGRectMake(kMainBoundsWidth/2-22, kMainBoundsHeight-88, 44, 44);
        [_lightButton setImage:[UIImage imageNamed:@"lightclose"] forState:UIControlStateNormal];
        [_lightButton addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _lightButton;
}

//计算扫描区域的函数
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x,y, width, height);
}
//打开手电筒的方法
-(void)openLight:(UIButton *)sender;
{
    if (_readView.torchMode == 0 ) {
        _readView.torchMode = 1 ;
        [_lightButton setImage:[UIImage imageNamed:@"lightopen"] forState:UIControlStateNormal];
    } else
    {
        _readView.torchMode = 0 ;
        [_lightButton setImage:[UIImage imageNamed:@"lightclose"] forState:UIControlStateNormal];
    }
}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{

    
    for (ZBarSymbol *symbol in symbols) {

        _result = [NSString stringWithFormat:@"%@",symbol.data];
        NSLog(@"%@",_result);
        
        NSString * buddyName = _result;
        
        
        if ([self didBuddyExist:buddyName]) {
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.repeat", @"'他'has been your friend!")];
                
                [EMAlertView showAlertWithTitle:message
                                        message:nil
                                completionBlock:nil
                              cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                              otherButtonTitles:nil];
                
                
                
            }
            else if([self hasSendBuddyRequest:buddyName])
            {
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.repeatApply", @"you have send fridend request to '%@'!"), buddyName];
                [EMAlertView showAlertWithTitle:message
                                        message:nil
                                completionBlock:nil
                              cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                              otherButtonTitles:nil];
                
            }else{
                [self showMessageAlertView];
            }

 
        
        
        
        
        break;
    }
    
    [_timer invalidate];
    
    _lineView.frame = CGRectMake(10*Proportion, 10*Proportion, 220*Proportion, 2*Proportion);
    _num = 0;
    _upOrdown = NO;
    [_readView stop];
    
}
//动画
-(void)animation
{
    if (_upOrdown == NO) {
        _num ++;
        _lineView.frame = CGRectMake(10*Proportion, 10*Proportion+2*_num*Proportion, 220*Proportion, 2*Proportion);
        if (2*_num == 220) {
            _upOrdown = YES;
        }
    }
    else {
        _num = 0;
        _upOrdown = NO;
    }
    
    
}
- (BOOL)hasSendBuddyRequest:(NSString *)buddyName
{
    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
    for (EMBuddy *buddy in buddyList) {
        if ([buddy.username isEqualToString:buddyName] &&
            buddy.followState == eEMBuddyFollowState_NotFollowed &&
            buddy.isPendingApproval) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)didBuddyExist:(NSString *)buddyName
{
    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
    for (EMBuddy *buddy in buddyList) {
        if ([buddy.username isEqualToString:buddyName] &&
            buddy.followState != eEMBuddyFollowState_NotFollowed) {
            return YES;
        }
    }
    return NO;
}

- (void)showMessageAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"saySomething", @"say somthing")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                                          otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        UITextField *messageTextField = [alertView textFieldAtIndex:0];
        
        NSString *messageStr = @"";
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *username = [loginInfo objectForKey:kSDKUsername];
        if (messageTextField.text.length > 0) {
            messageStr = [NSString stringWithFormat:@"%@：%@", username, messageTextField.text];
        }
        else{
            messageStr = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyInvite", @"%@ invite you as a friend"), username];
        }
        [self sendFriendApplyWithMessage:messageStr];
    }
}

- (void)sendFriendApplyWithMessage:(NSString *)message
{
  
    
    NSString *buddyName = _result;
    if (buddyName && buddyName.length > 0) {
        [self showHudInView:self.view hint:NSLocalizedString(@"friend.sendApply", @"sending application...")];
        EMError *error;
        [[EaseMob sharedInstance].chatManager addBuddy:buddyName message:message error:&error];
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"friend.sendApplyFail", @"send application fails, please operate again")];
        }
        else{
            [self showHint:NSLocalizedString(@"friend.sendApplySuccess", @"send successfully")];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//-(void)backClick:(UIButton*)sender
//{
//    [_timer invalidate];
//    _lineView.frame = CGRectMake(10*Proportion, 10*Proportion, 220*Proportion, 2*Proportion);
//    _num = 0;
//    _upOrdown = NO;
//    [_readView stop];
//    
//    NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
//    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:index-1] animated:NO];
//
@end

