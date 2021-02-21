//
//  NSURLSessionTask+CMNetworkConfiguration.m
//  Pods
//
//  Created by chenjm on 2016/12/8.
//
//

#import "NSURLSessionTask+CMNetworkConfiguration.h"
#import <objc/runtime.h>

static const void *CMNetwork_configurationKey = &CMNetwork_configurationKey;

@implementation NSURLSessionTask (CMNetworkConfiguration)
@dynamic CMNetwork_configuration;

- (NSString *)CMNetwork_configuration {
    return objc_getAssociatedObject(self, CMNetwork_configurationKey);
}
- (void)setCMNetwork_configuration:(CMNetworkConfiguration *)CMNetwork_configuration {
    objc_setAssociatedObject(self, CMNetwork_configurationKey, CMNetwork_configuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
