//
//  HtVideoPlayer.h
//  AudioAndVideoPlay
//
//  Created by wangzq on 16/8/15.
//  Copyright © 2016年 HTFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

//视屏框架导入
#import <AVFoundation/AVFoundation.h>

#import "TBPlayer.h"

/**
 *  视屏播放 Demo
 */
@interface HtVideoPlayer : AppViewController<UITableViewDelegate,UITableViewDataSource,TBPlayerVideoScreenDelegate>

//头部视图
@property (weak, nonatomic) IBOutlet UIView *headView;

//视图标题
@property (weak, nonatomic) IBOutlet UILabel *labPageTitle;

//////////////////////////////////////////////////////////

//播放视图
@property (weak, nonatomic) IBOutlet UIView *VideoView;

//////////////////////////////////////////////////////////

//播放列表视图
@property (weak, nonatomic) IBOutlet UITableView *playListTableView;

//////////////////////////////////////////////////////////

+(HtVideoPlayer *)manager;

//进入前台视频布局修正
-(void) didBecomeReviseVideoView;


@end
