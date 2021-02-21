//
//  CMNetworkInfo.m
//  Pods
//
//  Created by chenjm on 2016/11/29.
//
//

#import "CMNetworkInfo.h"
#import <SystemConfiguration/SystemConfiguration.h>


NSString *const CMNetworkStatusDidChangeNotification = @"CMNetworkStatusDidChangeNotification";
NSString *const CMNetworkStatusUnknown = @"unknown";
NSString *const CMNetworkStatusNone = @"none";
NSString *const CMNetworkStatusWifi = @"wifi";
NSString *const CMNetworkStatusCell = @"cell";

@implementation CMNetworkInfo {
    SCNetworkReachabilityRef _reachability;
}


static void SLReachabilityCallback(__unused SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
    CMNetworkInfo *self = (__bridge id)info;
    NSString *status = CMNetworkStatusUnknown;
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0 ||
        (flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0) {
        status = CMNetworkStatusNone;
    }
    
#if TARGET_OS_IPHONE
    
    else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        status = CMNetworkStatusCell;
    }
    
#endif
    
    else {
        status = CMNetworkStatusWifi;
    }
    
    if (![status isEqualToString:self->_status]) {
        self->_status = status;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CMNetworkStatusDidChangeNotification object:status];
    }
}

+ (CMNetworkInfo *)shareInstance {
    static CMNetworkInfo *info = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[CMNetworkInfo alloc] init];
    });
    
    return info;
}

+ (void)load {
    [CMNetworkInfo shareInstance];
}

- (instancetype)initWithHost:(NSString *)host {
    NSParameterAssert(host);
    NSAssert(![host hasPrefix:@"http"], @"Host value should just contain the domain, not the URL scheme.");
    
    if ((self = [super init])) {
        _status = CMNetworkStatusUnknown;
        _reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, host.UTF8String);
        SCNetworkReachabilityContext context = { 0, ( __bridge void *)self, NULL, NULL, NULL };
        SCNetworkReachabilitySetCallback(_reachability, SLReachabilityCallback, &context);
        SCNetworkReachabilityScheduleWithRunLoop(_reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    }
    return self;
}

- (instancetype)init {
    return [self initWithHost:@"apple.com"];
}

- (void)dealloc {
    SCNetworkReachabilityUnscheduleFromRunLoop(_reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    CFRelease(_reachability);
}

@end
