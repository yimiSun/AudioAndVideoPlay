//
//  HTWebVideo.m
//  AudioAndVideoPlay
//
//  Created by wangzq on 16/8/23.
//  Copyright © 2016年 HTFinance. All rights reserved.
//

#import "HTWebVideo.h"
#import "AppDelegate.h"

/**
 *  kHTWEB_VIDEO_URL
 *  http://v.hv678.com/vod/20160812/921873a635a44eb78a40e382a94f7802/mp4
 *  http://192.168.0.9:90/_v/220160810.mov 格式视频 点击播放会自动全屏，其他格式没这个现象
 *
 *  @return NSString
 */
#define kHTWEB_VIDEO_URL @"http://192.168.0.9:90/_v/220160810.mov"

#define kHTWEB_VIDEO_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface HTWebVideo ()

@end

@implementation HTWebVideo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
   [AppDelegate app].allowRotation = NO;
}


//////////////////////////////////////////////////////////////////////
#pragma mark - initView
//////////////////////////////////////////////////////////////////////
- (void) initView{

    // [S] 布局调整
    if ([AFUtils currentResolution] < UIDevice_iPhone5) {
        
        
    }
    // [E] 布局调整

    //屏幕改变监听
    [self WebVideoScreenlisten];
}

//屏幕改变监听
-(void)WebVideoScreenlisten{

    if (kHTWEB_VIDEO_SYSTEM_VERSION < 8.f) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(exitFullScreen:)
                                                     name:UIWindowDidBecomeVisibleNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterFullScreen:)
                                                     name:UIWindowDidBecomeHiddenNotification
                                                   object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterFullScreen:)
                                                     name:UIWindowDidBecomeVisibleNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(exitFullScreen:)
                                                     name:UIWindowDidBecomeHiddenNotification
                                                   object:nil];
    }

}

/**
 *  播放或暂停
 *
 *  @param sender void
 */
-(IBAction)btnPlayOrPauseAction:(id)sender{

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kHTWEB_VIDEO_URL]];
    [self.webVideoView loadRequest:request];

    //[self noFullScreen];
}


//////////////////////////////////////////////////////////////////////
#pragma mark - 屏幕调整回调处理
//////////////////////////////////////////////////////////////////////
//进入全屏
-(void)enterFullScreen:(id)sender{

    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    // [S] IOS系统横屏兼容处理
    if(kHTWEB_VIDEO_SYSTEM_VERSION < 8.0)
        [AppDelegate app].allowRotation = YES;

    else if (kHTWEB_VIDEO_SYSTEM_VERSION < 9.0) {

        UIWindow *window = [sender object];
        CGRect rectVideoView = window.frame;
        window.transform = CGAffineTransformMakeRotation(M_PI/2);//旋转90度

        rectVideoView = window.frame;
        rectVideoView.origin.x = 0.f;
        rectVideoView.origin.y = 0.f;
        rectVideoView.size.height = 568.f;
        rectVideoView.size.width = 320.f;
        window.frame = rectVideoView;
    }

    //横屏处理
    [AFUtils orientationToPortrait:UIInterfaceOrientationLandscapeRight];
    // [S] IOS系统横屏兼容处理
}

//退出全屏
-(void)exitFullScreen:(id)sender{

    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    //不允许横屏
    [AppDelegate app].allowRotation = NO;

    //竖屏处理
    [AFUtils orientationToPortrait:UIInterfaceOrientationPortrait];

}

//禁止自动全屏播放
-(void)noFullScreen{

    self.webVideoView.allowsInlineMediaPlayback = NO;

    NSString *strJs = @"<script>window.onload = function() {var de = document;if (de.exitFullscreen) {de.exitFullscreen();} else if (de.mozCancelFullScreen) {de.mozCancelFullScreen(); } else if (de.webkitCancelFullScreen) {de.webkitCancelFullScreen();}} </script>";

    [self.webVideoView stringByEvaluatingJavaScriptFromString:strJs];
}


//////////////////////////////////////////////////////////////////////
#pragma mark - UIWebViewDelegate
//////////////////////////////////////////////////////////////////////
-(void)webViewDidFinishLoad:(UIWebView *)webView{

}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    //[self noFullScreen];
}


@end
