//
//  JTPlayerControlView.h
//  player
//
//  Created by 周超哲 on 2020/4/22.
//  Copyright © 2020 周超哲. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JTPlayerControlViewDelegate <NSObject>


- (void)playerWillPauseOrPlay;
- (void)playerWillPlay;
- (void)playerWillPause;
- (void)playerWillBeFullScreen;

@end

@interface JTPlayerControlView : UIView

@property (nonatomic,weak) id<JTPlayerControlViewDelegate> delegate;

@property (nonatomic,strong) UIView *bottomBar;
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,strong) UIButton *pauseBtn;
@property (nonatomic,strong) UIButton *fullScreenBtn;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatiorView;

@property (nonatomic,assign) BOOL fullScreenMode;

@end

NS_ASSUME_NONNULL_END
