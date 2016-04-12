//
//  JLVideoPlayerViewController.m
//  Accompany
//
//  Created by 王园园 on 16/1/26.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLVideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "JLAVPlayerHelper.h"
#import "HDHud.h"
#define TOPVIEW_HEIGHT 40
#define BOTTOMVIEW_HEIGHT 40

#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
//#define IOS7 NLSystemVersionGreaterOrEqualThan(7.0)

@interface JLVideoPlayerViewController ()<UIGestureRecognizerDelegate>
{
    AVPlayerItem *playItem;
    float progressSlider;
    BOOL isPlay;
}
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) JLAVPlayerHelper *playerHelper;
@property (nonatomic, assign)CMTime currentTime;
@property (nonatomic, assign) BOOL isFirstRotatorTap;//  横屏下第一次点击
@property (nonatomic, assign) BOOL isPlayOrParse;   //暂停
@property (nonatomic, assign) CGFloat totalMovieDuration;//保存该视频资源的总时长(快进或快退)

//  View
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *ratotarBottomView;
@property (weak, nonatomic) IBOutlet UILabel *TitltLable;

@property (strong, nonatomic) IBOutlet UILabel *topPastTimeLabel;   //start Time
@property (strong, nonatomic) IBOutlet UISlider *topProgressSlider; //time Slider
@property (strong, nonatomic) IBOutlet UILabel *topRemainderLabel;  //end Time

//@property (strong, nonatomic) IBOutlet UIImageView *rotatorSoundImageView; //声音图片
//@property (strong, nonatomic) IBOutlet UISlider *rotatorBottomSlider;      //  声音进度slider

@property (strong, nonatomic) IBOutlet UIButton *rotatorPlayButton;        //  播放button
@property (weak, nonatomic) IBOutlet UIButton *nextPlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *viewPlayerButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewCpnstraint;


- (IBAction)topSliderValueChangedAction:(id)sender;

- (IBAction)rotatorPlayAction:(UIButton *)sender;
- (IBAction)rotatorNextAction:(UIButton *)sender;
- (IBAction)viewPlayerButtonAction:(id)sender;

//- (IBAction)bottomSoundSliderAction:(UISlider *)sender;
- (IBAction)finishAction:(UIButton *)sender;
@end


@implementation JLVideoPlayerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViewData];
}
-(void)initViewData
{
    if((_currentIndex+1)>=_videosList.count){
        _nextPlayerButton.enabled = NO;
    }
    _TitltLable.text = _movieModel.name;
    _movieURL = [NSURL URLWithString:_movieModel.url];

    
    [self setUpViews];
    [HDHud showHUDInView:self.view title:@"缓冲中"];
}
-(void)setUpViews
{
    _topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    _ratotarBottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    //  添加观察者
    [self addNotificationCenters];
    self.topProgressSlider.value = 0.0;
    [self addGestureRecognizer];
    [self addAVPlayer];
    //  设置topProgressSlider图片
    //UIImage *thumbImage = [UIImage imageNamed:@"sliderDoc"];
    //    [self.topProgressSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    //    [self.topProgressSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    [self.topProgressSlider setTintColor:kTabBarItemSelectColor];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setMoviePlay];
}

- (void)addAVPlayer{
    playItem = [AVPlayerItem playerItemWithURL: _movieURL];
    if(!self.playerHelper){
        self.playerHelper = [[JLAVPlayerHelper alloc] init];
    }
    [_playerHelper initAVPlayerWithAVPlayerItem:playItem];
    //  创建显示层
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer: _playerHelper.getAVPlayer];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    //  横屏的时候frame
    [self setPlayerLayerFrame];
    //  这是视频的填充模式, 默认为AVLayerVideoGravityResizeAspect
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //  插入到view层上面, 没有用addSubLayer
    [self.view.layer insertSublayer:_playerLayer atIndex:0];
    //  添加进度观察
    [self addProgressObserver];
    [self addObserverToPlayerItem: playItem];
}



//  播放页面添加轻拍手势
- (void)addGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAllSubViews:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - 观察者 观察播放完毕 观察屏幕旋转
- (void)addNotificationCenters {
    //  注册观察者用来观察，是否播放完毕
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //  注册观察者来观察屏幕的旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark - 横屏的时候frame的设置
//  横屏的时候frame
- (void)setPlayerLayerFrame {
    CGRect frame = self.view.bounds;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = kMainBoundsWidth;
    frame.size.height = kMainBoundsHeight;
    _playerLayer.frame = frame;
}

//  动画(出现或隐藏top - right - bottom)
- (void)dismissAllSubViews:(UITapGestureRecognizer *)tap {
    if(isPlay){
        _isFirstRotatorTap = !_isFirstRotatorTap;
    }
    [self setTopRightBottomFrame];
}
//  设置TopRightBottomFrame
- (void)setTopRightBottomFrame {
    if (!self.isFirstRotatorTap && isPlay==YES) {
        [UIView animateWithDuration:0.2f animations:^{
            _topViewConstraint.constant = -BOTTOMVIEW_HEIGHT;
            _bottomViewCpnstraint.constant = -BOTTOMVIEW_HEIGHT;
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            _topViewConstraint.constant = 0;
            _bottomViewCpnstraint.constant = 0;
        }];
    }
}


#pragma mark - 暂停
- (void)setMovieParse {
    [_playerHelper.getAVPlayer pause];
    isPlay = NO;
    self.isFirstRotatorTap = NO;
    [_rotatorPlayButton setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateNormal];
    _viewPlayerButton.hidden = NO;
    if(_topProgressSlider.value==1){
        [_viewPlayerButton setImage:[UIImage imageNamed:@"rePlayer"] forState:UIControlStateNormal];
    }else{
        [_viewPlayerButton setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateNormal];
    }
    [self setTopRightBottomFrame];
}
#pragma mark - 播放
- (void)setMoviePlay {
    if(_topProgressSlider.value==1.0){
        [self setmoviePlayerProcessWithCurrentTime:0.0];
    }
    [_playerHelper.getAVPlayer play];
    isPlay = YES;
    self.isFirstRotatorTap = YES;
    [_rotatorPlayButton setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
    _viewPlayerButton.hidden = YES;
}

#pragma mark -  添加进度观察 - addProgressObserver
- (void)addProgressObserver {
    //  设置每秒执行一次
    [_playerHelper.getAVPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue: NULL usingBlock:^(CMTime time) {
        [HDHud hideHUDInView:self.view];
        NSLog(@"进度观察 + %f", _topProgressSlider.value);
        //  获取当前时间
        CMTime currentTime = _playerHelper.getAVPlayer.currentItem.currentTime;
        //  转化成秒数
        CGFloat currentPlayTime = (CGFloat)currentTime.value / currentTime.timescale;
        //  总时间
        CMTime totalTime = playItem.duration;
        //  转化成秒
        _totalMovieDuration = (CGFloat)totalTime.value / totalTime.timescale;
        //  相减后
        _topProgressSlider.value = CMTimeGetSeconds(currentTime) / _totalMovieDuration;
        progressSlider = CMTimeGetSeconds(currentTime) / _totalMovieDuration;
        NSLog(@"剩余时间%f", _topProgressSlider.value);
        NSDate *pastDate = [NSDate dateWithTimeIntervalSince1970: currentPlayTime];
        _topPastTimeLabel.text = [self getTimeByDate:pastDate byProgress: currentPlayTime];
        CGFloat remainderTime = _totalMovieDuration ;//- currentPlayTime;
        NSDate *remainderDate = [NSDate dateWithTimeIntervalSince1970: remainderTime];
        _topRemainderLabel.text = [self getTimeByDate:remainderDate byProgress: remainderTime];
    }];
}


- (NSString *)getTimeByDate:(NSDate *)date byProgress:(float)current {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (current / 3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    return [formatter stringFromDate:date];
}


- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}


//  观察者的方法, 会在加载好后触发, 可以在这个方法中, 保存总文件的大小, 用于后面的进度的实现
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"正在播放...,视频总长度: %.2f",CMTimeGetSeconds(playerItem.duration));
            CMTime totalTime = playerItem.duration;
            self.totalMovieDuration = (CGFloat)totalTime.value / totalTime.timescale;
        }
    }
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = playerItem.loadedTimeRanges;
        //  本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //  缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        NSLog(@"共缓冲%.2f", totalBuffer);
        NSLog(@"进度 + %f", progressSlider);
        if(self.topProgressSlider.value == progressSlider){
            [self setMoviePlay];
        }
        self.topProgressSlider.value = progressSlider;
    }
}

#pragma mark - UIGestureRecognizerDelegate Method 方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //  不让子视图响应点击事件
    if( CGRectContainsPoint(self.topView.frame, [gestureRecognizer locationInView:self.view]) ||  CGRectContainsPoint(self.ratotarBottomView.frame, [gestureRecognizer locationInView:self.view])) {
        return NO;
    } else{
        return YES;
    };
}

#pragma mark - 播放进度条
- (IBAction)topSliderValueChangedAction:(id)sender {
    UISlider *test = (UISlider *)sender;
    NSLog(@"进度条进度 + %f", test.value);
    UISlider *senderSlider = sender;
    double currentTime = floor(_totalMovieDuration * senderSlider.value);
    [self setmoviePlayerProcessWithCurrentTime:currentTime];
}
#pragma mark - 播放进度
-(void)setmoviePlayerProcessWithCurrentTime:(double)currentTime
{
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(currentTime, 1);
    [_playerHelper.getAVPlayer seekToTime:dragedCMTime completionHandler:^(BOOL finished) {
        if (_isPlayOrParse) {
            [_playerHelper.getAVPlayer play];
        }
    }];
}

#pragma mark - 播放...
- (IBAction)rotatorPlayAction:(UIButton *)sender {
    if (isPlay) {
        [self setMovieParse];
    } else {
        [self setMoviePlay];
    }
}

#pragma mark 播放结束后的代理回调
- (void)moviePlayDidEnd:(NSNotification *)notify
{
    [self setMovieParse];
    //  让这个视频循环播放...
}


#pragma mark - 播放下一个...
-(IBAction)rotatorNextAction:(UIButton *)sender {
    NSLog(@"下一个~~~");
    _currentIndex++;
    if(_currentIndex>=_videosList.count){
        _nextPlayerButton.enabled = NO;
    }
    _movieModel = [_videosList objectAtIndex:_currentIndex];
    [self initViewData];
    playItem = [AVPlayerItem playerItemWithURL: _movieURL];
    [_playerHelper initAVPlayerWithAVPlayerItem:playItem];
    [self setMoviePlay];
}

- (IBAction)viewPlayerButtonAction:(id)sender {
    [self setMoviePlay];
}

#pragma mark - 返回按钮...
- (IBAction)finishAction:(UIButton *)sender {
    NSLog(@"完成~~~");
    [self dismissViewControllerAnimated:YES completion:nil];
}



//#pragma mark - 音量slider
//- (IBAction)bottomSoundSliderAction:(UISlider *)sender {
//    //  0 - 1
//    [_playerHelper setAVPlayerVolume:sender.value];
//    
//    self.rotatorBottomSlider.value = sender.value;
//    self.verticalBottomSlider.value = sender.value;
//    if (sender.value == 0) {
//        self.rotatorSoundImageView.image = [UIImage imageNamed:@"播放器_静音"];
//        self.verticalSoundImageView.image = [UIImage imageNamed:@"播放器_静音"];
//    } else {
//        self.rotatorSoundImageView.image = [UIImage imageNamed:@"播放器_音量"];
//        self.verticalSoundImageView.image = [UIImage imageNamed:@"播放器_音量"];
//    }
//}



#pragma mark -
#pragma mark - 横屏
//  进入该视图控制器自动横屏进行播放
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (void)statusBarOrientationChange:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight) {
        [self setPlayerLayerFrame];
    }
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        [self setPlayerLayerFrame];
    }
    if (orientation == UIInterfaceOrientationPortrait) {
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeObserverFromPlayerItem: _playerHelper.getAVPlayer.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    //  返回前一个页面的时候释放内存
    [self.playerHelper.getAVPlayer replaceCurrentItemWithPlayerItem:nil];
    _playerLayer.delegate = nil;
    _playerLayer = nil;
}

//没执行？？？？
- (void)dealloc {
    //  移除观察者,使用观察者模式的时候,记得在不使用的时候,进行移除
    [self removeObserverFromPlayerItem: _playerHelper.getAVPlayer.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    //  返回前一个页面的时候释放内存
    [self.playerHelper.getAVPlayer replaceCurrentItemWithPlayerItem:nil];
    _playerLayer.delegate = nil;
    _playerLayer = nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
