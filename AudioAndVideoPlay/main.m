//
//  main.m
//  AudioAndVideoPlay
//
//  Created by wangzq on 16/8/15.
//  Copyright © 2016年 HTFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        } @catch (NSException *exception) {
            NSLog(@"很遗憾，系统异常！详见：%@",exception);
        }
    }
}
