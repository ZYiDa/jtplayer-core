//
//  JTPlayer.m
//  player
//
//  Created by 周超哲 on 2020/4/22.
//  Copyright © 2020 周超哲. All rights reserved.
//

#import "JTPlayer.h"
#import "Masonry.h"
#import "JTPlayerControlView.h"
#import "JTPlayerDefines.h"
#import <MediaPlayer/MediaPlayer.h>
#import <VideoToolbox/VideoToolbox.h>

@interface JTPlayer ()<JTPlayerControlViewDelegate>
{
    NSURL *_ijkplayerUrl;
    CGRect _orignFrame;
}
@property (nonatomic,retain) id<IJKMediaPlayback> ijkplayer;
@property (nonatomic,strong) JTPlayerControlView *controlView;
@property (nonatomic,strong) UIView *playingView;

@property (nonatomic,readonly) IJKFFOptions *options;
@end

@implementation JTPlayer

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.contentMode = UIViewContentModeScaleAspectFit;
        FunctonLog;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    FunctonLog;
}

#pragma mark ========== UI ==========

#pragma mark 配置playView
- (void)setupPlayView{
    if (self.ijkplayer) {
        _playingView = [self.ijkplayer view];
        _playingView.frame = self.bounds;
        _playingView.center = self.center;
        _playingView.contentMode = UIViewContentModeScaleAspectFit;
        _playingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self insertSubview:_playingView atIndex:0];
        FunctonLog;
    }
}

#pragma mark 设置controlView
- (void)setupControlView{
    self.controlView = [[JTPlayerControlView alloc]init];
    self.controlView.userInteractionEnabled = YES;
    self.controlView.delegate = self;
    [self addSubview:self.controlView];
    [self bringSubviewToFront:self.controlView];
    [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self);
    }];
    FunctonLog;
}

#pragma mark ========== Actions ==========
#pragma mark 设置播放地址和参数
- (void)playWithUrl:(NSURL *)url options:(JTPlayerOptions)options{
    
    if (!url) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerDidPlayFailedWithMessage:)]) {
            [self.delegate playerDidPlayFailedWithMessage:MESSAGE_ERROR_PATH];
        }
        return;
    }
    
    @try {
        [self destory];
    } @catch (NSException *exception) {
        NSLog(@"- %s : %@",__func__,exception.description);
    } @finally {
    }
    
    //TODO:调整参数
    IJKFFOptions *optionss = [IJKFFOptions optionsByDefault];
    
    //TODO:rtsp参数配置
    [optionss setFormatOptionValue:@"tcp" forKey:@"rtsp-tcp"];
    
    //TODO:其它参数配置
    [optionss setPlayerOptionIntValue:59.9  forKey:@"max-fps"];
    [optionss setPlayerOptionIntValue:30 forKey:@"r"];
    [optionss setPlayerOptionIntValue:8  forKey:@"framedrop"];
    [optionss setPlayerOptionIntValue:1  forKey:@"start-on-prepared"];
    [optionss setPlayerOptionIntValue:0  forKey:@"http-detect-range-support"];
    [optionss setPlayerOptionIntValue:48  forKey:@"skip_loop_filter"];
    [optionss setPlayerOptionIntValue:1  forKey:@"packet-buffering"];
    [optionss setPlayerOptionIntValue:2000 forKey:@"analyzeduration"];
    [optionss setPlayerOptionIntValue:1  forKey:@"start-on-prepared"];
    [optionss setCodecOptionIntValue:8 forKey:@"skip_frame"];
    [optionss setFormatOptionValue:@"8192" forKey:@"probsize"];
    [optionss setPlayerOptionIntValue:1 forKey:@"enable-accurate-seek"];
    //自动转屏开关
    [optionss setFormatOptionIntValue:0 forKey:@"auto_convert"];
    //重连次数
    [optionss setFormatOptionIntValue:1 forKey:@"reconnect"];
    
    switch (options) {
        case JTPlayerOptionsDefault:
        case JTPlayerOptionsSoftDec:
        {
            //TODO:开启硬解码 0 关闭硬解码，1 开启硬解码
            [optionss setOptionIntValue:0 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
            [optionss setPlayerOptionIntValue:256000 forKey:@"videotoolbox-max-frame-width"]; // 指定最大宽度
            [optionss setPlayerOptionValue:@"0" forKey:@"videotoolbox-async"];
        }
            break;
        case JTPlayerOptionsVideoToolbox:
        {
            [optionss setOptionIntValue:1 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
            [optionss setPlayerOptionIntValue:256000 forKey:@"videotoolbox-max-frame-width"]; // 指定最大宽度
            [optionss setPlayerOptionValue:@"1" forKey:@"videotoolbox-async"];
        }
            break;
        default:
            break;
    }
    
    self.ijkplayer = [[IJKFFMoviePlayerController alloc]initWithContentURL:url withOptions:optionss];
    [self.ijkplayer setScalingMode:IJKMPMovieScalingModeAspectFit];
    [self.ijkplayer setPauseInBackground:YES];
    
    [self addMovieNotificationObservers];
    if(![self.ijkplayer isPlaying]){
        [self.ijkplayer prepareToPlay];
    }
    
    [self setupPlayView];
    [self setupControlView];
    FunctonLog;
}

#pragma mark 播放
- (void)play{
    _controlView.playBtn.hidden = YES;
    _controlView.pauseBtn.hidden = NO;
    if (self.ijkplayer) {
        [self.ijkplayer play];
    }
}

#pragma mark 暂停
- (void)pause{
    _controlView.playBtn.hidden = NO;
    _controlView.pauseBtn.hidden = YES;
    if (self.ijkplayer) {
        [self.ijkplayer pause];
    }
}

#pragma mark 停止播放
- (void)stop{
    _controlView.playBtn.hidden = NO;
    _controlView.pauseBtn.hidden = YES;
    if (self.ijkplayer) {
        [self.ijkplayer stop];
    }
}

#pragma mark 释放资源
- (void)destory{
    if (_controlView.activityIndicatiorView.animating == YES) {
        [_controlView.activityIndicatiorView stopAnimating ];
    }
    if (self.ijkplayer) {
        [self removeMovieNotificationObservers];
        [self.ijkplayer stop];
        [self.ijkplayer shutdown];
        self.ijkplayer = nil;
        [_playingView removeFromSuperview];
        _playingView = nil;
        [self.controlView removeFromSuperview];
        self.controlView = nil;
    }
}

#pragma mark 显示或隐藏Log信息HUD
- (void)showOrHideLogHUD{
    //TODO:播放信息展示的 view
    /* 展示的信息字段说明
     * vdec 解码方式
     * fps 视频解码帧率和播放帧率
     * tcp-spd 视频下载速度
     */
    static int i = 0;
    [(IJKFFMoviePlayerController *)self.ijkplayer setShouldShowHudView:i%2==0];
    i++;
}

#pragma mark ====== notification ======
#pragma mark -- 添加播放相关的通知
- (void)addMovieNotificationObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:self.ijkplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:self.ijkplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:self.ijkplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.ijkplayer];
}

#pragma mark ====== 加载状态发生改变 ======
- (void)loadStateDidChange:(NSNotification *)notification{
    NSLog(@"- %s : %@",__func__,notification);
    
    /*
     * 0 未知
     * 1 可以播放
     * 2 shouldAutoplay=YES 时，可以自动播放
     * 3 当播放开始加载时，在此状态下，播放将会自动暂停
     */
    IJKMPMovieLoadState loadState = self.ijkplayer.loadState;
    switch (loadState) {
        case IJKMPMovieLoadStatePlaythroughOK:
        case IJKMPMovieLoadStatePlayable:
            _controlView.playBtn.hidden = YES;
            _controlView.pauseBtn.hidden = NO;
            [_controlView.activityIndicatiorView stopAnimating];
            NSLog(@"IJKMPMovieLoadStatePlaythroughOK -- IJKMPMovieLoadStatePlayable");
            break;
        case IJKMPMovieLoadStateStalled:
            NSLog(@"IJKMPMovieLoadStateStalled");
            break;
        default:
            break;
    }
}

#pragma mark ====== 播放结束 ======
- (void)moviePlayBackFinish:(NSNotification *)notification{
    NSLog(@"- %s : %@",__func__,notification);
    _controlView.playBtn.hidden = NO;
    _controlView.pauseBtn.hidden = YES;
}

#pragma mark ====== 预加载即将播放状态发生改变 ======
- (void)mediaIsPreparedToPlayDidChange:(NSNotification *)notification{
    NSLog(@"- %s : %@",__func__,notification);
}

#pragma mark ====== 播放状态发生改变 ======
- (void)moviePlayBackStateDidChange:(NSNotification *)notification{
    NSLog(@"- %s : %@",__func__,notification);
    NSLog(@"%s : %ld",__func__,self.ijkplayer.playbackState);
    NSLog(@"%s : %@",__func__,[(IJKFFMoviePlayerController *)self.ijkplayer isVideoToolboxOpen]==YES?@"已开启 VideoToolbox 硬解码":@"未开启 VideoToolbox 硬解码");
    
    switch (_ijkplayer.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlaybackStateStopped");
            //TODO:针对本地视频的循环播放
            _controlView.playBtn.hidden = NO;
            _controlView.pauseBtn.hidden = YES;
//            if (![self.ijkplayer isPlaying]) {
//                [self.ijkplayer play];
//            }
            break;
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlaybackStatePlaying");
            _controlView.playBtn.hidden = YES;
            _controlView.pauseBtn.hidden = NO;
            [_controlView.activityIndicatiorView stopAnimating];
            break;
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlaybackStatePaused");
            break;
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlaybackStateInterrupted");
            break;
        case IJKMPMoviePlaybackStateSeekingForward:
            NSLog(@"IJKMPMoviePlaybackStateSeekingForward");
            break;
        case IJKMPMoviePlaybackStateSeekingBackward:
            NSLog(@"IJKMPMoviePlaybackStateSeekingBackward");
            break;
        default:
            break;
    }
}

#pragma mark -- 移除相关的通知
- (void)removeMovieNotificationObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:self.ijkplayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:self.ijkplayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:self.ijkplayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:self.ijkplayer];
}

#pragma mark ====== ControlViewDelegate ======
- (void)playerWillPauseOrPlay{
    if ([self.ijkplayer isPlaying]) {
        [self pause];
    }else{
        [self play];
    }
}

- (void)playerWillPlay{
    if (![self.ijkplayer isPlaying]) {
        [self play];
    }
}

- (void)playerWillPause{
    if ([self.ijkplayer isPlaying]) {
        [self pause];
    }
}

- (void)playerWillBeFullScreen{
    if (_controlView.fullScreenMode == NO) {
        _orignFrame = self.bounds;
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeRotation(0);
            self.frame = _orignFrame;
        }];
    }
    _controlView.fullScreenMode = !_controlView.fullScreenMode;
}



@end
