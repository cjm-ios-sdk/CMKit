//
//  NSTimer+CMTimer.h
//  CMKit
//
//  Created by chenjm on 2021/2/20.
//

#import "NSTimer+CMTimer.h"

@implementation NSTimer (CMTimer)

+ (void)cm_ExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)cm_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(cm_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)cm_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer timerWithTimeInterval:interval target:self selector:@selector(cm_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

@end
