//
//  AppDelegate.m
//  AudioAndVideoPlay
//
//  Created by wangzq on 16/8/15.
//  Copyright © 2016年 HTFinance. All rights reserved.
//

#import "AppDelegate.h"

#import "HtVideoPlayer.h"
#import "HTWebVideo.h"

@interface AppDelegate ()

@end

static AppDelegate *app = nil;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    app = self;

    // [S] 状态栏 设置为 白色
    // 1、设置Info.plist中的View controller-based status bar appearance为YES
    // 2、设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // [E] 状态栏 设置为 白色


    // [S] 设置底部选项视图
    UIViewController *vc1 = [[HtVideoPlayer alloc] initWithNibName:@"HtVideoPlayer" bundle:nil];
    UIViewController *vc2 = [[HTWebVideo alloc] initWithNibName:@"HTWebVideo" bundle:nil];

    vc1.title = @"Demo1";
    vc2.title = @"Demo2";

    _tabBarController = [[UITabBarController alloc] init];
    [_tabBarController setViewControllers:@[vc1,vc2]];
    // [E] 设置底部选项视图


    // [S] 设置导航视图
    _navigationController = [[UINavigationController alloc] init];
    [_navigationController pushViewController:_tabBarController animated:NO];

    _navigationController.navigationBar.hidden = YES;
    _navigationController.toolbar.hidden = YES;
    // [E] 设置导航视图


    // [S] 填充到window 视图
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _navigationController;

    [self.window makeKeyAndVisible];
    // [E] 填充到window 视图

    return YES;
}

// 将要进入后台
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// 已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

// 将要从后台转为前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

/**
 *  已经进入前台
 *  这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 *
 *  @return void
 */

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    // 从后台进入前台视频布局修正
    [[HtVideoPlayer manager] didBecomeReviseVideoView];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//设备屏幕方向支持设置
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{

    if (self.allowRotation)
        return UIInterfaceOrientationMaskLandscape;

    //默认只支持竖屏
    return UIInterfaceOrientationMaskPortrait;
}


//////////////////////////////////////////////////////////////
#pragma mark - Custom Method
//////////////////////////////////////////////////////////////
+(AppDelegate *)app{
    return app;
}

@end
