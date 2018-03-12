//
//  NSTimer+Addition.m
//
//  Created by 余洪江 on 16/03/01.
//  Copyright © MRJ. All rights reserved.
//
#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)

/// 暂停NSTimer
- (void)pauseTimer {
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}

/// 开始NSTimer
- (void)resumeTimer {
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

/// 延迟开始NSTimer
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval {
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
