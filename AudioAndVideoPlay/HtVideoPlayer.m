//
//  HtVideoPlayer.m
//  AudioAndVideoPlay
//
//  Created by wangzq on 16/8/15.
//  Copyright © 2016年 HTFinance. All rights reserved.
//

#import "HtVideoPlayer.h"
#import "TBPlayer.h"
#import "AppDelegate.h"

static HtVideoPlayer *htVideoPLayer = nil;
#define K_ONEVIDEOPLAYER_CELL_HEIGHT 60

@interface HtVideoPlayer (){
    NSArray *arrVideoUrlDatas;
}

@end

//视频地址
static NSString *strVideoUrl = nil;
static NSString *strVideoTitle = nil;

@implementation HtVideoPlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initView];

    htVideoPLayer = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(HtVideoPlayer *)manager{
    return htVideoPLayer;
}


////////////////////////////////////////////////////////////////////////////
#pragma mark - initView
////////////////////////////////////////////////////////////////////////////
-(void) initView{

    // [S] 布局调整
    if ([AFUtils currentResolution] < UIDevice_iPhone5) {
        CGRect rectListTableView = self.playListTableView.frame;
        rectListTableView.size.height -= AF_IPHONE5_H_OFFSET;
        self.playListTableView.frame = rectListTableView;
    }
    // [E] 布局调整


    // [S] 视频地址
    arrVideoUrlDatas = @[
       @{@"Title":@"汇视直播：您身边的专业金融直播专家",@"Url":@"http://192.168.0.132:93/static/video/220160810.mov",@"PubData":@"2016-08-12 09:21"},
       @{@"Title":@"微录客搞笑短视频集锦",@"Url":@"http://zyvideo1.oss-cn-qingdao.aliyuncs.com/zyvd/7c/de/04ec95f4fd42d9d01f63b9683ad0",@"PubData":@"2016-08-10 09:21"}
    ];

    strVideoUrl = [NSString stringWithFormat:@"%@",[[arrVideoUrlDatas firstObject] objectForKey:@"Url"]];

    strVideoTitle = [NSString stringWithFormat:@"%@",[[arrVideoUrlDatas firstObject] objectForKey:@"Title"]];

    [self.playListTableView reloadData];
    // [E] 视频地址


    // 空白行
    self.playListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.navigationController.hidesBarsOnTap = YES;
}

//进入前台视频布局修正
-(void) didBecomeReviseVideoView{

    if ([[TBPlayer sharedInstance] isFullScreen]){

        //修正屏幕状态显示图
        [[TBPlayer sharedInstance] initBigOrSmallBackgroundImage];

        //修正视频显示大小
        [self reviseVideoView:[[TBPlayer sharedInstance] vide_small_size] andFullScreen:NO];

        //显示状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:NO];

        [TBPlayer sharedInstance].isFullScreen = NO;

        NSLog(@"已经入前台，视频布局已修正");
    }
}


////////////////////////////////////////////////////////////////////////////
#pragma mark - 视屏播放器
////////////////////////////////////////////////////////////////////////////

//播放
-(void)playVideo{

    if (!strVideoUrl || [strVideoUrl isEqualToString:@""]) {
        [AFUtils alertMessage:@"播放地址错误"];
        return;
    }

    //当前视频标题
    self.labPageTitle.text = strVideoTitle;

    //播放
    [[TBPlayer sharedInstance] playWithUrl:[NSURL URLWithString:strVideoUrl] showView:self.VideoView];
    [TBPlayer sharedInstance].tbPlayerVideoScreenDelegate = self;
}


////////////////////////////////////////////////////////////////////////////
#pragma mark - 视频列表
////////////////////////////////////////////////////////////////////////////
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (arrVideoUrlDatas)
        return [arrVideoUrlDatas count];
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return K_ONEVIDEOPLAYER_CELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (arrVideoUrlDatas && indexPath.row < arrVideoUrlDatas.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

        NSDictionary *dicTemp = [arrVideoUrlDatas objectAtIndex:indexPath.row];

        cell.textLabel.text = [NSString stringWithFormat:@"%@",dicTemp[@"Title"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",dicTemp[@"PubData"]];

        cell.accessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        return cell;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (arrVideoUrlDatas && indexPath.row < arrVideoUrlDatas.count) {

        NSDictionary *dicTemp = [arrVideoUrlDatas objectAtIndex:indexPath.row];

        strVideoUrl = [NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"Url"]];

        strVideoTitle = [NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"Title"]];

        [self playVideo];

        dicTemp = nil;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


////////////////////////////////////////////////////////////////////////////
#pragma mark - TBPlayerVideoScreenDelegate
////////////////////////////////////////////////////////////////////////////
-(void)reviseVideoView:(CGSize)_size andFullScreen:(BOOL)_isFullScreen{

    if (_size.height < 0 || _size.width < 0) return;

    CGRect rectVideoView = self.VideoView.frame;
    rectVideoView.size = _size;
    rectVideoView.origin.x = 0;

    float top = 0.f;
    if (!_isFullScreen)
        top = self.headView.frame.size.height;

    rectVideoView.origin.y = top;

    self.VideoView.frame = rectVideoView;

    //修正播放视频的尺寸
    [[TBPlayer sharedInstance] reviseVideView:_size andMarginTop:top];


    // [S] 强制旋转屏幕
    float fversion = [[[UIDevice currentDevice] systemVersion] floatValue];

    if(_isFullScreen){
        [AFUtils orientationToPortrait:UIInterfaceOrientationLandscapeRight];

        // [S] IOS系统横屏兼容处理
        if (fversion < 9.0) {

            self.VideoView.transform = CGAffineTransformMakeRotation(M_PI/2);//旋转90度
            rectVideoView = self.VideoView.frame;

            rectVideoView.origin.x = 0.f;
            rectVideoView.origin.y = 0.f;
            self.VideoView.frame = rectVideoView;
        }
        // [S] IOS系统横屏兼容处理
    }
    else{
        [AFUtils orientationToPortrait:UIInterfaceOrientationPortrait];

        // [S] IOS系统横屏兼容处理
        if (fversion < 9.0) {

            self.VideoView.transform = CGAffineTransformMakeRotation(0);

            rectVideoView.origin.x = 0.f;
            rectVideoView.origin.y = 0.f;
            self.VideoView.frame = rectVideoView;
        }
        // [S] IOS系统横屏兼容处理
    }
    // [E] 强制旋转屏幕

}


@end
