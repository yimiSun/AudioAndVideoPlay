//
//  HTWebVideo.h
//  AudioAndVideoPlay
//
//  Created by wangzq on 16/8/23.
//  Copyright © 2016年 HTFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  视频Demo Web版
 */
@interface HTWebVideo : AppViewController<UIWebViewDelegate>

//头部视图
@property (weak, nonatomic) IBOutlet UIView *headView;

//页标题
@property (weak, nonatomic) IBOutlet UILabel *labPageTitle;

//网页视频视图
@property (weak, nonatomic) IBOutlet UIWebView *webVideoView;

//暂停
@property (weak, nonatomic) IBOutlet UIButton *btnPlayOrPause;

/////////////////////////////////////////////////////////////////

//播放、暂停
-(IBAction)btnPlayOrPauseAction:(id)sender;

@end
