//
//  CMNetworkConfiguration.m
//  Pods
//
//  Created by chenjm on 2016/12/8.
//
//

#import "CMNetworkConfiguration.h"

@implementation CMNetworkConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _timeoutInterval = 20.0;
        _isShowNetworkActivity = YES;
        _cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    
    return self;
}

@end
