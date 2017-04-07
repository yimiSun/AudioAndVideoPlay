//
//  TBPlayer.m
//  TBPlayer
//
//  Created by qianjianeng on 16/1/31.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "TBPlayer.h"
#import "TBloaderURLConnection.h"
#import "TBVideoRequestTask.h"

//系统音量调节组件
#import <MediaPlayer/MediaPlayer.h>

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define IOS_VERSION  ([[[UIDevice currentDevice] systemVersion] floatValue])

NSString *const kTBPlayerStateChangedNotification    = @"TBPlayerStateChangedNotification";
NSString *const kTBPlayerProgressChangedNotification = @"TBPlayerProgressChangedNotification";
NSString *const kTBPlayerLoadProgressChangedNotification = @"TBPlayerLoadProgressChangedNotification";

////////////////////////////////////////////////////////////////////////////////
#pragma mark - 视频播放器 相关设置
////////////////////////////////////////////////////////////////////////////////

//工具栏背景色
#define K_APP_VIDEO_TOOL_BG_COLOR [UIColor colorWithWhite:0.000 alpha:0.35]

//工具栏高度
#define K_APP_VIDEO_TOOL_HEIGHT 25.f

//进度条填充部分颜色
#define K_APP_VIDEO_PROGRESS_FULL_COLOR [UIColor colorWithWhite:0.980 alpha:1.000]

//进度条未填充部分颜色
#define K_APP_VIDEO_PROGRESS_COLOR [UIColor colorWithWhite:0.514 alpha:1.000]

//提示框显示时间(0 表示不自动消失)
#define K_APP_VIDEO_HUD_HIDDEN_TIME 0.5f

// Pan滑动手势方向
typedef enum : NSInteger {
    kCameraMoveDirectionNone,

    kCameraMoveDirectionUp,

    kCameraMoveDirectionDown,

    kCameraMoveDirectionRight,

    kCameraMoveDirectionLeft
} CameraMoveDirection;

CGFloat const gestureMinimumTranslation = 20.0;

static CameraMoveDirection direction;

@interface TBPlayer ()<TBloaderURLConnectionDelegate>{
    CGPoint beginPoint;
    CGPoint endPoint;
}

@property (nonatomic        ) TBPlayerState  state;
@property (nonatomic        ) CGFloat        loadedProgress;//缓冲进度
@property (nonatomic        ) CGFloat        duration;      //视频总时间
@property (nonatomic        ) CGFloat        current;       //当前播放时间

@property (nonatomic, strong) AVURLAsset     *videoURLAsset;
@property (nonatomic, strong) AVAsset        *videoAsset;
@property (nonatomic, strong) TBloaderURLConnection *resouerLoader;
@property (nonatomic, strong) AVPlayer       *player;
@property (nonatomic, strong) AVPlayerItem   *currentPlayerItem;
@property (nonatomic, strong) AVPlayerLayer  *currentPlayerLayer;
@property (nonatomic, strong) NSObject       *playbackTimeObserver;

@property (nonatomic, strong) MPVolumeView   *volumeView;       //系统音量组件
@property (nonatomic, strong) UISlider       *volumeViewSlider; //系统音量组件

@property (nonatomic        ) BOOL           isPauseByUser; //是否被用户暂停
@property (nonatomic,       ) BOOL           isLocalVideo;  //是否播放本地文件
@property (nonatomic,       ) BOOL           isFinishLoad;  //是否下载完毕

@property (nonatomic, weak)   UIView         *showView;

@property (nonatomic, strong) UIView         *navBar;
@property (nonatomic, strong) UILabel        *currentTimeLabel;
@property (nonatomic, strong) UILabel        *totolTimeLabel;
@property (nonatomic, strong) UIProgressView *videoProgressView;//缓冲进度条
@property (nonatomic, strong) UISlider       *playSlider;       //播放进度滑竿
@property (nonatomic, strong) UIButton       *stopButton;       //播放、暂停按钮
@property (nonatomic, strong) UIButton       *smallOrBigButton; //全屏、半屏按钮

////////////////////////////////////////////////////////////////////////

@property (nonatomic, strong) UITapGestureRecognizer   *doubleTapGesture;
@property (nonatomic, strong) UITapGestureRecognizer   *singleTapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer   *panGesture;


@end

@implementation TBPlayer

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id _sInstance;
    dispatch_once(&onceToken, ^{
        _sInstance = [[self alloc] init];
    });
    
    return _sInstance;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _isPauseByUser = YES;
        _isFullScreen = NO;
        _loadedProgress = 0;
        _duration = 0;
        _current  = 0;
        _state = TBPlayerStateStopped;
        _stopWhenAppDidEnterBackground = YES;

        _volumeView = [[MPVolumeView alloc] init];
    }
    return self;
}

#pragma mark - 播放器
//清空播放器监听属性
- (void)releasePlayer{

    if (!self.currentPlayerItem) return;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"status"];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.player removeTimeObserver:self.playbackTimeObserver];

    // [S] 移除相应手势事件
    if (_showView) {
        [_showView removeGestureRecognizer:_doubleTapGesture];

        [_showView removeGestureRecognizer:_singleTapGesture];

        [_showView removeGestureRecognizer:_panGesture];
    }
    // [E] 移除相应手势事件

    self.playbackTimeObserver = nil;
    self.currentPlayerItem = nil;
}

- (void)seekToTime:(CGFloat)seconds{

    if (self.state == TBPlayerStateStopped) return;
    
    seconds = MAX(0, seconds);
    seconds = MIN(seconds, self.duration);
    
    [self.player pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC) completionHandler:^(BOOL finished) {

        self.isPauseByUser = NO;
        [self.player play];

        if (!self.currentPlayerItem.isPlaybackLikelyToKeepUp) {
            self.state = TBPlayerStateBuffering;

            [[XCHudHelper sharedInstance] showHudOnView:_showView caption:nil image:nil acitivity:YES autoHideTime:0];
        }
        
    }];
}


#pragma mark - 播放器手势事件
- (void)videoViewGestureInit{

    // [S] 双击全屏、半屏事件
    if (!_doubleTapGesture) {
        _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullScreenSet:)];
        _doubleTapGesture.numberOfTapsRequired = 2;

        [_showView addGestureRecognizer:_doubleTapGesture];
    }
    // [E] 双击全屏、半屏事件


    // [S] 单击播放、暂停事件
    if (!_singleTapGesture) {
        _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resumeOrPause:)];

        [_showView addGestureRecognizer:_singleTapGesture];
    }
    // [E] 单击播放、暂停事件

    //防止 单击、双击事件冲突
    [_singleTapGesture requireGestureRecognizerToFail:_doubleTapGesture];


    // [S] 拖动事件 快进/倒退(左右拖动)、音量调节(上下)
    if(!_panGesture){
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(volumeOrProgressChange:)];

       [_showView addGestureRecognizer:_panGesture];
    }
    // [E] 拖动事件 快进/倒退(左右拖动)、音量调节(上下)

}


#pragma mark - 外部调用的播放方法
- (void)playWithUrl:(NSURL *)url showView:(UIView *)showView{

    [self.player pause];
    [self releasePlayer];

    self.isPauseByUser = NO;
    self.loadedProgress = 0;
    self.duration = 0;
    self.current  = 0;

    _showView = showView;
    [_showView setBackgroundColor:[UIColor blackColor]];

    // 设置视频操作手势
    [self videoViewGestureInit];


    // [S] 记录半屏的大小，以便还原事使用
    CGSize sizeTemp = _showView.frame.size;

    if (sizeTemp.width < kScreenHeight)
        _vide_small_size = sizeTemp;
    // [E] 记录半屏的大小，以便还原事使用


    NSString *str = [url absoluteString];

    //如果是ios  < 7 或者是本地资源，直接播放
    if (IOS_VERSION < 7.0 || ![str hasPrefix:@"http"]) {
        self.videoAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        self.currentPlayerItem = [AVPlayerItem playerItemWithAsset:_videoAsset];

        if (!self.player)
            self.player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
        else
            [self.player replaceCurrentItemWithPlayerItem:self.currentPlayerItem];

        self.currentPlayerLayer       = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.currentPlayerLayer.frame = CGRectMake(0, 0, showView.bounds.size.width, showView.bounds.size.height);

        _isLocalVideo = YES;

    }
    //ios7以上采用resourceLoader给播放器补充数据
    else {

        self.resouerLoader          = [[TBloaderURLConnection alloc] init];
        self.resouerLoader.delegate = self;
        NSURL *playUrl              = [_resouerLoader getSchemeVideoURL:url];
        self.videoURLAsset          = [AVURLAsset URLAssetWithURL:playUrl options:nil];
        [_videoURLAsset.resourceLoader setDelegate:_resouerLoader queue:dispatch_get_main_queue()];
        self.currentPlayerItem      = [AVPlayerItem playerItemWithAsset:_videoURLAsset];

        if (!self.player)
            self.player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
        else
            [self.player replaceCurrentItemWithPlayerItem:self.currentPlayerItem];

        self.currentPlayerLayer       = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.currentPlayerLayer.frame = CGRectMake(0, 0, showView.bounds.size.width, showView.bounds.size.height);
        _isLocalVideo = NO;

    }

    self.currentPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;


    [showView.layer addSublayer:self.currentPlayerLayer];

    [self.currentPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentPlayerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemPlaybackStalled:) name:AVPlayerItemPlaybackStalledNotification object:self.currentPlayerItem];


    // 本地文件不设置TBPlayerStateBuffering状态
    if ([url.scheme isEqualToString:@"file"]) {

        // 如果已经在TBPlayerStatePlaying，则直接发通知，否则设置状态
        if (self.state == TBPlayerStatePlaying)
            [[NSNotificationCenter defaultCenter] postNotificationName:kTBPlayerStateChangedNotification object:nil];
        else
            self.state = TBPlayerStatePlaying;
    }
    else {

        // 如果已经在TBPlayerStateBuffering，则直接发通知，否则设置状态
        if (self.state == TBPlayerStateBuffering)
            [[NSNotificationCenter defaultCenter] postNotificationName:kTBPlayerStateChangedNotification object:nil];
        else
            self.state = TBPlayerStateBuffering;
    }


    if (!_navBar) {
        _navBar = [[UIView alloc] init];

        [showView addSubview:_navBar];
        [showView bringSubviewToFront:_navBar];
    }

    //初始化顶部工具视图
    [self buildVideoNavBar];

    //加载视频动画
    [[XCHudHelper sharedInstance] showHudOnView:_showView caption:nil image:nil acitivity:YES autoHideTime:0];

    [[NSNotificationCenter defaultCenter] postNotificationName:kTBPlayerProgressChangedNotification object:nil];
}


#pragma mark - 播放、暂停
- (void)resumeOrPause:(id)sender{

    if (!self.currentPlayerItem)
        return;

    // [S] 判断当前触发的位置是否在底部工具栏
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint touchPoint = [sender locationInView:_navBar];

        if ([_navBar pointInside:touchPoint withEvent:nil]) return;
    }
    // [S] 判断当前触发的位置是否在底部工具栏


    // 事件处理
    if (self.state == TBPlayerStatePlaying) {
        [_stopButton setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];

        [self.player pause];
        self.state = TBPlayerStatePause;

        [[XCHudHelper sharedInstance] showHudOnView:_showView caption:nil image:[UIImage imageNamed:@"video_play"] acitivity:NO autoHideTime:K_APP_VIDEO_HUD_HIDDEN_TIME];
    }
    else if (self.state == TBPlayerStatePause) {
        [_stopButton setImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];

        [self.player play];
        self.state = TBPlayerStatePlaying;

        [[XCHudHelper sharedInstance] showHudOnView:_showView caption:nil image:[UIImage imageNamed:@"video_pause"] acitivity:NO autoHideTime:K_APP_VIDEO_HUD_HIDDEN_TIME];
    }

    self.isPauseByUser = YES;
}

- (void)resume{
    if (!self.currentPlayerItem) return;
    
    [_stopButton setImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];

    self.isPauseByUser = NO;
    [self.player play];
}

//暂停
- (void)pause{

    if (!self.currentPlayerItem) return;

    [_stopButton setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];

    self.isPauseByUser = YES;
    self.state = TBPlayerStatePause;

    [self.player pause];
}


#pragma mark - 滑动 播放进度调节(上下拖动) / 音量调节(上下)
- (void)volumeOrProgressChange:(UIPanGestureRecognizer *) sender{

    // [S] 判断当前触发的位置是否在底部工具栏
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint touchPoint = [sender locationInView:_navBar];

        if ([_navBar pointInside:touchPoint withEvent:nil]) return;
    }
    // [S] 判断当前触发的位置是否在底部工具栏


    // [S] 获取滑动的距离，以便设置滑杆需要滑动多少值
    CGPoint translation = [sender translationInView:_showView];

    if (sender.state == UIGestureRecognizerStateBegan) {
        direction = kCameraMoveDirectionNone;

        beginPoint = [sender locationInView:_showView];
        NSLog(@"开始滑动：X => %f, Y => %f",beginPoint.x,beginPoint.y);
    }
    else if(sender.state == UIGestureRecognizerStateChanged && direction == kCameraMoveDirectionNone){
        //获取当前的滑动方向(上下左右)
        direction = [self determineCameraDirectionIfNeeded:translation];
    }
    else if(sender.state == UIGestureRecognizerStateChanged){

        [_player pause];
        _isPauseByUser = YES;

        endPoint = [sender locationInView:_showView];

        // 响应屏幕滑动手势，调节对应信息
        [self volumeOrProgressSet:NO];
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {

        endPoint = [sender locationInView:_showView];
        NSLog(@"滑动结束：X => %f, Y => %f",endPoint.x,endPoint.y);

        // 响应屏幕滑动手势，调节对应信息
        [self volumeOrProgressSet:YES];
    }
    // [E] 获取滑动的距离，以便设置滑杆需要滑动多少值
    
}

//响应屏幕滑动手势，调节对应信息
-(void)volumeOrProgressSet:(BOOL)_isEnd{

    // [S] 响应屏幕滑动手势，调节对应信息
    //滑动值
    float fvalue = [TBPlayer getValueOfPanGesture:beginPoint withAnd:endPoint];

    //上下滑动表示音量调节
    if(direction == kCameraMoveDirectionUp || direction == kCameraMoveDirectionDown)
        [_volumeViewSlider setValue:_volumeViewSlider.value + fvalue animated:YES];

    // [S] 左右滑动表示视频进度调节
    else if(direction == kCameraMoveDirectionLeft || direction == kCameraMoveDirectionRight){

        _playSlider.value = _playSlider.value + fvalue;

        //调用滑杆值改变事件
        [self playSliderChange:_playSlider];

        // 快进(右)
        if (direction == kCameraMoveDirectionRight){
            if(_isEnd){
               [[XCHudHelper sharedInstance] showHudOnView:_showView caption:nil image:[UIImage imageNamed:@"video_forward"] acitivity:NO autoHideTime:K_APP_VIDEO_HUD_HIDDEN_TIME];
            }
        }
        // 回退(左)
        else if(direction == kCameraMoveDirectionLeft){
            if(_isEnd){
                [[XCHudHelper sharedInstance] showHudOnView:_showView caption:nil image:[UIImage imageNamed:@"video_backward"] acitivity:NO autoHideTime:K_APP_VIDEO_HUD_HIDDEN_TIME];
            }
        }

        //重新加载进度
        [self playSliderChangeEnd:_playSlider];
    }
    // [E] 响应屏幕滑动手势，调节对应信息
}

//根据滑动的距离得到对应比例的 音量值或 播放进度值
+(float)getValueOfPanGesture:(CGPoint)beginPoint withAnd:(CGPoint)endPoint{

    float fvalue = 0.f;
    float fProportion = 0.1f;//比例

    CGSize sizeShowView = [[TBPlayer sharedInstance] showView].frame.size;

    // [S] 获取滑动距离已计算对应比例
    float offsetX = endPoint.x - beginPoint.x;
    float offsetY = endPoint.y - beginPoint.y;

    //滑动的距离
    float distance = sqrtf((float)(offsetX * offsetX) + (float)(offsetY * offsetY));
    NSLog(@"滑动距离：%f",distance);

    //上下滑动表示音量调节
    if(direction == kCameraMoveDirectionUp || direction == kCameraMoveDirectionDown){
        distance = distance > sizeShowView.height?sizeShowView.height:distance;

        //对应比例
        fProportion = fabs(distance / sizeShowView.height);

        //系统最大音量 为1.f
        fvalue = fabsf(1.f * fProportion);
        if (direction == kCameraMoveDirectionDown) //向下滑，减音量
            fvalue = -fvalue;
    }
    //左右滑动表示视频进度调节
    else if(direction == kCameraMoveDirectionLeft || direction == kCameraMoveDirectionRight){
        distance = distance > sizeShowView.width?sizeShowView.width:distance;

        //对应比例
        fProportion = fabsf((float)(distance / sizeShowView.width));

        //duration 视频总时长
        fvalue = fabsf([[TBPlayer sharedInstance] playSlider].maximumValue * fProportion);
        if (direction == kCameraMoveDirectionLeft) //向左滑，回退
            fvalue = -fvalue;
    }
    // [E] 获取滑动距离已计算对应比例

    return fvalue;
}


//UIPanGestureRecognizer 滑动方向判断
-(CameraMoveDirection)determineCameraDirectionIfNeeded:(CGPoint)translation{

    if (direction != kCameraMoveDirectionNone)
        return direction;

    // determine if horizontal swipe only if you meet some minimum velocity
    if (fabs(translation.x) > gestureMinimumTranslation){
        BOOL gestureHorizontal = NO;

        if (translation.y == 0.0 )
            gestureHorizontal = YES;
        else
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );

        if (gestureHorizontal){
            if (translation.x > 0.0 )
                return kCameraMoveDirectionRight;
            else
                return kCameraMoveDirectionLeft;
        }
    }

    // determine if vertical swipe only if you meet some minimum velocity
    else if (fabs(translation.y) > gestureMinimumTranslation){
        BOOL gestureVertical = NO;

        if (translation.x == 0.0 )
            gestureVertical = YES;
        else
            gestureVertical = (fabs(translation.y / translation.x) > 5.0 );

        if (gestureVertical){
            if (translation.y > 0.0 )
                return kCameraMoveDirectionDown;
            else
                return kCameraMoveDirectionUp;
        }
    }
    
    return direction;
}


#pragma mark - 播放结束
//播放结束
- (void)stop{

    //播放状态
    self.isPauseByUser = YES;

    self.state = TBPlayerStatePause;
    [self.player pause];

    NSLog(@"播放完毕");
}

- (CGFloat)progress{

    if (self.duration > 0)
        return self.current / self.duration;

    return 0;
}


#pragma mark - 全屏、半屏设置
- (void)fullScreenSet:(id) sender{

    // [S] 判断当前触发的位置是否在底部工具栏
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint touchPoint = [sender locationInView:_navBar];

        if ([_navBar pointInside:touchPoint withEvent:nil]) return;
    }
    // [S] 判断当前触发的位置是否在底部工具栏

    CGSize sizeTemp = [self initBigOrSmallBackgroundImage];

    _isFullScreen = !_isFullScreen;

    [_tbPlayerVideoScreenDelegate reviseVideoView:sizeTemp andFullScreen:_isFullScreen];

}

- (CGSize)initBigOrSmallBackgroundImage{

    CGSize sizeTemp = CGSizeZero;

    //当前为全屏
    if(_isFullScreen){
        [self.smallOrBigButton setImage:[UIImage imageNamed:@"video_big"] forState:UIControlStateNormal];

        sizeTemp = _vide_small_size;

        [[XCHudHelper sharedInstance] showHudOnView:_showView caption:nil image:[UIImage imageNamed:@"video_small"] acitivity:NO autoHideTime:K_APP_VIDEO_HUD_HIDDEN_TIME];

        //隐藏状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    //当前为半屏
    else{
        [self.smallOrBigButton setImage:[UIImage imageNamed:@"video_small"] forState:UIControlStateNormal];

        sizeTemp = CGSizeMake(kScreenHeight,kScreenWidth);

        [[XCHudHelper sharedInstance] showHudOnView:_showView caption:nil image:[UIImage imageNamed:@"video_big"] acitivity:NO autoHideTime:K_APP_VIDEO_HUD_HIDDEN_TIME];

        //显示状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
    return sizeTemp;
}

-(void)reviseVideView:(CGSize)_size andMarginTop:(float)_marginTop{

    if (_size.width <= 0 || _size.height <= 0) return;

    CGRect rectShowView = self.showView.frame;
    rectShowView.size = _size;
    rectShowView.origin.y = _marginTop;
    rectShowView.origin.x = 0.f;
    self.showView.frame = rectShowView;

    self.currentPlayerLayer.frame = CGRectMake(0, 0, _size.width, _size.height);

    [self buildVideoNavBar];
}


#pragma mark - observer

- (void)appDidEnterBackground{
    if (self.stopWhenAppDidEnterBackground) {
        [self pause];

        self.state = TBPlayerStatePause;
        self.isPauseByUser = NO;
    }
}

- (void)appDidEnterPlayGround{

    if (!self.isPauseByUser) {
        [self resume];

        self.state = TBPlayerStatePlaying;
    }
}

- (void)playerItemDidPlayToEnd:(NSNotification *)notification{

    if (_playSlider.value < _duration) return;

    [self stop];

}

//在监听播放器状态中处理比较准确
- (void)playerItemPlaybackStalled:(NSNotification *)notification{
    // 这里网络不好的时候，就会进入，不做处理，会在playbackBufferEmpty里面缓存之后重新播放
    NSLog(@"buffing...");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        // 给播放器添加计时器
        if ([playerItem status] == AVPlayerStatusReadyToPlay)
            [self monitoringPlayback:playerItem];
        else if ([playerItem status] == AVPlayerStatusFailed || [playerItem status] == AVPlayerStatusUnknown)
            [self stop];
    }

    //监听播放器的下载进度
    else if ([keyPath isEqualToString:@"loadedTimeRanges"])
        [self calculateDownloadProgress:playerItem];

    //监听播放器在缓冲数据的状态
    else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {

        [[XCHudHelper sharedInstance] showHudOnView:_showView caption:nil image:nil acitivity:YES autoHideTime:0];

        if (playerItem.isPlaybackBufferEmpty) {
            self.state = TBPlayerStateBuffering;

            [self bufferingSomeSecond];
        }
    }
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem{

    self.duration = playerItem.duration.value / playerItem.duration.timescale; //视频总时间
    [self.player play];
    [self updateTotolTime:self.duration];
    [self setPlaySliderValue:self.duration];
    
    __weak __typeof(self)weakSelf = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        CGFloat current = playerItem.currentTime.value/playerItem.currentTime.timescale;
        [strongSelf updateCurrentTime:current];
        [strongSelf updateVideoSlider:current];
        if (strongSelf.isPauseByUser == NO) {
            strongSelf.state = TBPlayerStatePlaying;
        }
        
        // 不相等的时候才更新，并发通知，否则seek时会继续跳动
        if (strongSelf.current != current) {
            strongSelf.current = current;

            if (strongSelf.current > strongSelf.duration) {
                strongSelf.duration = strongSelf.current;
            }

            [[NSNotificationCenter defaultCenter] postNotificationName:kTBPlayerProgressChangedNotification object:nil];
        }
        
    }];

}

- (void)calculateDownloadProgress:(AVPlayerItem *)playerItem{

    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域

    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);

    NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
    CMTime duration = playerItem.duration;
    CGFloat totalDuration = CMTimeGetSeconds(duration);

    self.loadedProgress = timeInterval / totalDuration;
    [self.videoProgressView setProgress:timeInterval / totalDuration animated:YES];
}

- (void)bufferingSomeSecond{
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    static BOOL isBuffering = NO;
    if (isBuffering) return;

    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        
        [self.player play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.currentPlayerItem.isPlaybackLikelyToKeepUp) {
            [self bufferingSomeSecond];
        }
    });
}

- (void)setLoadedProgress:(CGFloat)loadedProgress{

    if (_loadedProgress == loadedProgress) return;
    
    _loadedProgress = loadedProgress;
    [[NSNotificationCenter defaultCenter] postNotificationName:kTBPlayerLoadProgressChangedNotification object:nil];
}

- (void)setState:(TBPlayerState)state{

    if (state != TBPlayerStateBuffering)
        [[XCHudHelper sharedInstance] hideHud];

    if (_state == state)
        return;
    
    _state = state;
    [[NSNotificationCenter defaultCenter] postNotificationName:kTBPlayerStateChangedNotification object:nil];
    
}

#pragma mark - UI界面
- (void)buildVideoNavBar{

    _navBar.backgroundColor = K_APP_VIDEO_TOOL_BG_COLOR;
    _navBar.frame = CGRectMake(0,
                               _showView.frame.size.height - K_APP_VIDEO_TOOL_HEIGHT, _showView.frame.size.width,
                               K_APP_VIDEO_TOOL_HEIGHT);

    //暂停按钮
    if (!self.stopButton) {
        self.stopButton = [UIButton buttonWithType:UIButtonTypeCustom];

        _stopButton.frame = CGRectMake(0, 0, 40, K_APP_VIDEO_TOOL_HEIGHT);
        [_stopButton addTarget:self action:@selector(resumeOrPause:) forControlEvents:UIControlEventTouchUpInside];
        [_stopButton setImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];

        //自适应
        _stopButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;

        [_navBar addSubview:_stopButton];
    }


    //当前时间
    if (!self.currentTimeLabel) {
        self.currentTimeLabel = [[UILabel alloc] init];

        _currentTimeLabel.textColor = [AFUtils UIColorFromRGB:0xffffff alpha:1];
        _currentTimeLabel.font = [UIFont systemFontOfSize:10.0];

        _currentTimeLabel.frame = CGRectMake(15, 0, 52, K_APP_VIDEO_TOOL_HEIGHT);
        _currentTimeLabel.textAlignment = NSTextAlignmentRight;
        _currentTimeLabel.text = @"00:00";

        //自适应
        _currentTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;

        [_navBar addSubview:_currentTimeLabel];
    }

    
    //进度条
    if (!self.videoProgressView) {
        self.videoProgressView = [[UIProgressView alloc] init];

        //填充部分颜色
        _videoProgressView.progressTintColor = K_APP_VIDEO_PROGRESS_FULL_COLOR;

        //未填充部分颜色
        _videoProgressView.trackTintColor = K_APP_VIDEO_PROGRESS_COLOR;

        _videoProgressView.frame = CGRectMake(78,K_APP_VIDEO_TOOL_HEIGHT/2, kScreenWidth-153, 20);

        _videoProgressView.layer.cornerRadius = 1.5;
        _videoProgressView.layer.masksToBounds = YES;

        CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.5);

        //自适应
        _videoProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        _videoProgressView.transform = transform;
        [_navBar addSubview:_videoProgressView];
    }
    
    
    //滑竿
    if (!self.playSlider) {
        
        self.playSlider = [[UISlider alloc] init];
        _playSlider.frame = CGRectMake(78, 0, kScreenWidth - 153.f, K_APP_VIDEO_TOOL_HEIGHT);
        [_playSlider setThumbImage:[UIImage imageNamed:@"video_slider_bg.png"] forState:UIControlStateNormal];

        _playSlider.minimumTrackTintColor = [UIColor clearColor];
        _playSlider.maximumTrackTintColor = [UIColor clearColor];

        [_playSlider addTarget:self action:@selector(playSliderChange:) forControlEvents:UIControlEventValueChanged]; //拖动滑竿更新时间

        [_playSlider addTarget:self action:@selector(playSliderChangeEnd:) forControlEvents:UIControlEventTouchUpInside]; //松手,滑块拖动停止

        [_playSlider addTarget:self action:@selector(playSliderChangeEnd:) forControlEvents:UIControlEventTouchUpOutside];
        [_playSlider addTarget:self action:@selector(playSliderChangeEnd:) forControlEvents:UIControlEventTouchCancel];

        //自适应
        _playSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [_navBar addSubview:_playSlider];
    }


    //总时间
    if (!self.totolTimeLabel) {
        self.totolTimeLabel = [[UILabel alloc] init];

        _totolTimeLabel.textColor = [AFUtils UIColorFromRGB:0xffffff alpha:1];
        _totolTimeLabel.font = [UIFont systemFontOfSize:10.0];

        _totolTimeLabel.frame = CGRectMake(kScreenWidth - 65, 0, 52, K_APP_VIDEO_TOOL_HEIGHT);
        _totolTimeLabel.textAlignment = NSTextAlignmentLeft;
        _totolTimeLabel.text = @"00:00";

        //自适应
        _totolTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

        [_navBar addSubview:_totolTimeLabel];
    }


    //全屏、半屏
    if (!self.smallOrBigButton) {
        self.smallOrBigButton = [UIButton buttonWithType:UIButtonTypeCustom];

        _smallOrBigButton.frame = CGRectMake(kScreenWidth - 40, 0, 40, K_APP_VIDEO_TOOL_HEIGHT);
        [_smallOrBigButton addTarget:self action:@selector(fullScreenSet:) forControlEvents:UIControlEventTouchUpInside];

        [_smallOrBigButton setImage:[UIImage imageNamed:@"video_big"] forState:UIControlStateNormal];

        //自适应
        _smallOrBigButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

        [_navBar addSubview:_smallOrBigButton];
    }


    // [S] 系统音量初始化设置
    /**
     *  volumeViewSlider.value   当前系统音量
     *
     *  change system volume, the value is between 0.0f and 1.0f
     *  [volumeViewSlider setValue:1.0f animated:NO];
     */
    if (!_volumeViewSlider) {

        if (!_volumeView)
            _volumeView = [[MPVolumeView alloc] init];

        for (UIView *view in [_volumeView subviews]) {
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                _volumeViewSlider = (UISlider *)view;
                break;
            }
        }

    }
    // [E] 系统音量初始化设置

}


#pragma mark - 快进或倒退播放
//手指结束拖动，播放器从当前点开始播放，开启滑竿的时间走动
- (void)playSliderChangeEnd:(UISlider *)slider{

    [self seekToTime:slider.value];
    [self updateCurrentTime:slider.value];

    [_stopButton setImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];

}

//手指正在拖动，播放器继续播放，但是停止滑竿的时间走动
- (void)playSliderChange:(UISlider *)slider{

    [self updateCurrentTime:slider.value];

    if (_isPauseByUser) {
        [self.player play];

        _isPauseByUser = YES;
    }
}


#pragma mark - 控件拖动
- (void)setPlaySliderValue:(CGFloat)time{
    _playSlider.minimumValue = 0.0;
    _playSlider.maximumValue = (NSInteger)time;
}

- (void)updateCurrentTime:(CGFloat)time{

    long videocurrent = ceil(time);
    
    NSString *str = nil;
    if (videocurrent < 3600) {
        str =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(videocurrent/60.f)),lround(floor(videocurrent/1.f))%60];
    }
    else {
        str =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(videocurrent/3600.f)),lround(floor(videocurrent%3600)/60.f),lround(floor(videocurrent/1.f))%60];
    }
    
    _currentTimeLabel.text = str;
}

- (void)updateTotolTime:(CGFloat)time{

    long videoLenth = ceil(time);
    NSString *strtotol = nil;

    if (videoLenth < 3600)
        strtotol =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(videoLenth/60.f)),lround(floor(videoLenth/1.f))%60];
    else
        strtotol =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(videoLenth/3600.f)),lround(floor(videoLenth%3600)/60.f),lround(floor(videoLenth/1.f))%60];
    
    _totolTimeLabel.text = strtotol;
}


- (void)updateVideoSlider:(CGFloat)currentSecond {
    [self.playSlider setValue:currentSecond animated:YES];
}


#pragma mark - TBloaderURLConnectionDelegate

- (void)didFinishLoadingWithTask:(TBVideoRequestTask *)task{
    _isFinishLoad = task.isFinishLoad;
}

/**
 *  didFailLoadingWithTask
 *
 *  @param task      TBVideoRequestTask
 *  @param errorCode 
                 网络中断：-1005
                 无网络连接：-1009
                 请求超时：-1001
                 服务器内部错误：-1004
                 找不到服务器：-1003
 */
- (void)didFailLoadingWithTask:(TBVideoRequestTask *)task WithError:(NSInteger)errorCode{
    
    NSString *str = nil;
    switch (errorCode) {
        case -1001:
            str = @"请求超时";
            break;
        case -1003:
        case -1004:
            str = @"服务器错误";
            break;
        case -1005:
            str = @"网络中断";
            break;
        case -1009:
            str = @"无网络连接";
            break;
            
        default:
            str = [NSString stringWithFormat:@"%@", @"(_errorCode)"];
            break;
    }
    
    [XCHudHelper showMessage:str];
    
}

- (void)dealloc{
    
    [self releasePlayer];
}


@end
