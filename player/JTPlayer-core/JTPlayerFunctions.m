//
//  JTPlayerFunctions.m
//  player
//
//  Created by 金劲通 on 2020/4/24.
//  Copyright © 2020 周超哲. All rights reserved.
//

#import "JTPlayerFunctions.h"

@implementation JTPlayerFunctions

+ (BOOL)is_iPhoneXSerial{
    if (@available(iOS 11.0, *)) {
        if ([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom > 0) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

@end
