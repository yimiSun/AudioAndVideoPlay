//
//  AppDelegate.h
//  AudioAndVideoPlay
//
//  Created by wangzq on 16/8/15.
//  Copyright © 2016年 HTFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow               *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UITabBarController     *tabBarController;

/** 是否允许横屏的标记 */
@property (nonatomic,assign)  BOOL                   allowRotation;

+(AppDelegate *)app;

@end

