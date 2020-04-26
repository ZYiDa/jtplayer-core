//
//  JTPlayerDefines.h
//  player
//
//  Created by 金劲通 on 2020/4/23.
//  Copyright © 2020 周超哲. All rights reserved.
//

#ifndef JTPlayerDefines_h
#define JTPlayerDefines_h

#import "JTPlayerFunctions.h"

#define isiPhoneXSerial [JTPlayerFunctions is_iPhoneXSerial]

#define ControlViewBottomBarHeight 64.f

#ifdef isiPhoneXSerial
#define ControlViewBottomBarPadding 15.f
#else
#define ControlViewBottomBarPadding 15.f
#endif


#define ControlViewBottomBarPlayOrPauseWidth 44.f

#define FunctonLog         NSLog(@"*** %s ***",__func__)

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height


#define MESSAGE_ERROR_PATH @"播放失败:资源地址错误"

#endif /* JTPlayerDefines_h */
