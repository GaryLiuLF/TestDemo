//
//  DeviceTool.m
//  Rabbit
//
//  Created by wei on 2018/10/31.
//  Copyright © 2018年 wei. All rights reserved.
//

#import "BDeviceTool.h"

@implementation BDeviceTool

+ (BOOL)isIphonX;{
    if (@available(iOS 11.0, *)) {
        // 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X以上设备。
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        if (window.safeAreaInsets.bottom > 0.0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

@end
