//
//  JTPlayerControlView.m
//  player
//
//  Created by 周超哲 on 2020/4/22.
//  Copyright © 2020 周超哲. All rights reserved.
//

#import "JTPlayerControlView.h"
#import "Masonry.h"
#import "JTPlayerDefines.h"
@interface JTPlayerControlView ()<UIGestureRecognizerDelegate>
{
    BOOL _isFullScreenMode;
}
@end

@implementation JTPlayerControlView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.fullScreenMode = NO;
        [self setupBtnAction];
        [self setupRecognizer];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
}


#pragma mark 配置按钮操作
- (void)setupBtnAction{
    
    //TODO:loading
    _activityIndicatiorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatiorView.color = [UIColor redColor];
    [_activityIndicatiorView hidesWhenStopped];
    [self addSubview:_activityIndicatiorView];
    [self bringSubviewToFront:_activityIndicatiorView];
    [_activityIndicatiorView startAnimating];
    [_activityIndicatiorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_offset(77);
    }];
    
    
    //TODO:bottomBar
    _bottomBar = [[UIView alloc]init];
    _bottomBar.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
    [self addSubview:_bottomBar];
    [_bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing);
        make.leading.equalTo(self.mas_leading);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(ControlViewBottomBarHeight);
    }];
    
    
    
    //TODO:播放或暂停
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.hidden = NO;
    [_playBtn setImage:[UIImage imageNamed:@"item_play"] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:_playBtn];
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomBar).with.offset(ControlViewBottomBarPadding);
        make.centerY.equalTo(_bottomBar);
        make.height.width.mas_equalTo(ControlViewBottomBarPlayOrPauseWidth);
    }];
    
    _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _pauseBtn.hidden = YES;
    [_pauseBtn setImage:[UIImage imageNamed:@"item_pause"] forState:UIControlStateNormal];
    [_pauseBtn addTarget:self action:@selector(pauseAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:_pauseBtn];
    [_pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomBar).with.offset(ControlViewBottomBarPadding);
        make.centerY.equalTo(_bottomBar);
        make.height.width.mas_equalTo(ControlViewBottomBarPlayOrPauseWidth);
    }];
    
    //TODO:全屏按钮
    _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fullScreenBtn setImage:[UIImage imageNamed:@"item_fullscreen"] forState:UIControlStateNormal];
    [_fullScreenBtn addTarget:self action:@selector(fullScreenAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:_fullScreenBtn];
    [_bottomBar addSubview:_fullScreenBtn];
    [_fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomBar).with.offset(-ControlViewBottomBarPadding);
        make.centerY.equalTo(_bottomBar);
        make.height.width.mas_equalTo(ControlViewBottomBarPlayOrPauseWidth);
    }];
}

#pragma mark 配置手势操作
- (void)setupRecognizer{
    
    //TODO:单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.cancelsTouchesInView = NO;
    singleTap.delegate = self;
    [self addGestureRecognizer:singleTap];
    
    //TODO:双击手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.delegate = self;
    [self addGestureRecognizer:doubleTap];
}

#pragma mark 单击手势操作
- (void)singleTapAction{
    [self delayDismissBottomBar];
}

#pragma mark 双击手势操作
- (void)doubleTapAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerWillPauseOrPlay)]) {
        [self.delegate playerWillPauseOrPlay];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_bottomBar]) {
        return NO;
    }
    return YES;
}

#pragma mark 播放
- (void)playAction{
    _playBtn.hidden = YES;
    _pauseBtn.hidden = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerWillPlay)]) {
        [self.delegate playerWillPlay];
    }
}

#pragma mark 暂停
- (void)pauseAction{
    _playBtn.hidden = NO;
    _pauseBtn.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerWillPause)]) {
        [self.delegate playerWillPause];
    }
}

#pragma mark 全屏
- (void)fullScreenAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerWillBeFullScreen)]) {
        [self.delegate playerWillBeFullScreen];
    }
}

- (void)setFullScreenMode:(BOOL)fullScreenMode{
    _isFullScreenMode = fullScreenMode;
}

- (BOOL)fullScreenMode{
    return _isFullScreenMode;
}

#pragma mark 延时消失bottomBar
- (void)delayDismissBottomBar{
    if (self.bottomBar.alpha == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomBar.alpha = 0;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomBar.alpha = 1;
        }];
    }
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint p = [self.superview convertPoint:point fromView:self];
    if (CGRectContainsPoint(self.frame, p)) {
        return YES;
    }
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
