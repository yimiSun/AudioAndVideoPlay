//
//  TBPlayer.h
//  TBPlayer
//
//  Created by qianjianeng on 16/1/31.
//  Copyright © 2016年 SF. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const kTBPlayerStateChangedNotification;
FOUNDATION_EXPORT NSString *const kTBPlayerProgressChangedNotification;
FOUNDATION_EXPORT NSString *const kTBPlayerLoadProgressChangedNotification;

//播放器的几种状态
typedef NS_ENUM(NSInteger, TBPlayerState) {
    TBPlayerStateBuffering = 1,
    TBPlayerStatePlaying   = 2,
    TBPlayerStateStopped   = 3,
    TBPlayerStatePause     = 4
};

/**
 *  视频设置委托
 */
@protocol TBPlayerVideoScreenDelegate <NSObject>

-(void)reviseVideoView:(CGSize)_size andFullScreen:(BOOL)_isFullScreen;

@end


/**
 *  TBPlayer
 */
@interface TBPlayer : NSObject

@property (nonatomic, readonly) TBPlayerState state;
@property (nonatomic, readonly) CGFloat       loadedProgress;   //缓冲进度
@property (nonatomic, readonly) CGFloat       duration;         //视频总时间
@property (nonatomic, readonly) CGFloat       current;          //当前播放时间
@property (nonatomic, readonly) CGFloat       progress;         //播放进度 0~1

@property (nonatomic          ) BOOL          stopWhenAppDidEnterBackground;// default is YES
@property (nonatomic          ) BOOL          isFullScreen;     //是否为全屏(默认为 NO)
@property (nonatomic, assign  ) CGSize        vide_small_size;  //用来记录半屏播放的大小

@property (nonatomic, assign  ) id<TBPlayerVideoScreenDelegate> tbPlayerVideoScreenDelegate;

////////////////////////////////////////////////////////////////////////////


+ (instancetype)sharedInstance;

//播放调用
- (void)playWithUrl:(NSURL *)url showView:(UIView *)showView;

//修正播放视频大小
- (void)reviseVideView:(CGSize)_size andMarginTop:(float)_marginTop;

//修正屏幕状态显示图
- (CGSize)initBigOrSmallBackgroundImage;


@end


