//
//  JTPlayer.h
//  player
//
//  Created by 周超哲 on 2020/4/22.
//  Copyright © 2020 周超哲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JTPlayerOptions) {
    JTPlayerOptionsDefault,//默认
    JTPlayerOptionsVideoToolbox,//硬解码
    JTPlayerOptionsSoftDec,//软解码
};


@protocol JTPlayerDelegate <NSObject>

- (void)playerDidPlayFailedWithMessage:(NSString *)failMesssage;

@end

@interface JTPlayer : UIView

/**
 * 播放器对象
 */
@property (nonatomic,readonly) id<IJKMediaPlayback> ijkplayer;

/**
 * 播放器代理对象
 */
@property (nonatomic,weak) id<JTPlayerDelegate> delegate;

/**
 * @param url 播放地址
 * @param options 播放参数设置
 */
- (void)playWithUrl:(NSURL *)url options:(JTPlayerOptions)options;

/**
 * 播放
 */
- (void)play;

/**
 * 暂停
 */
- (void)pause;

/**
 * 停止
 */
- (void)stop;

/**
 * 释放播放器资源
 */
- (void)destory;

/**
 * 显示或隐藏Log信息层
 */
- (void)showOrHideLogHUD;

@end

NS_ASSUME_NONNULL_END
