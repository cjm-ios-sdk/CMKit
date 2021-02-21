//
//  NSURLSessionDataTask+CMNetworkData.m
//  Pods
//
//  Created by chenjm on 2016/12/9.
//
//

#import "NSURLSessionTask+CMNetworkData.h"
#import <objc/runtime.h>

static const void *CMNetwork_dataKey = &CMNetwork_dataKey;
static const void *CMNetwork_completionKey = &CMNetwork_completionKey;
static const void *CMNetwork_progressKey = &CMNetwork_progressKey;
static const void *CMNetwork_responseProgressKey = &CMNetwork_responseProgressKey;
static const void *CMNetwork_responseKey = &CMNetwork_responseKey;

@implementation NSURLSessionTask (CMNetworkData)



#pragma mark - CMNetwork_data

- (void)setCMNetwork_data:(NSMutableData *)CMNetwork_data {
    objc_setAssociatedObject(self, CMNetwork_dataKey, CMNetwork_data, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableData *)CMNetwork_data {
    return objc_getAssociatedObject(self, CMNetwork_dataKey);
}


#pragma mark - CMNetwork_completionBlock

- (void)setCMNetwork_completionBlock:(CMNetworkTaskCompletionBlock)CMNetwork_completionBlock {
    objc_setAssociatedObject(self, CMNetwork_completionKey, CMNetwork_completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CMNetworkTaskCompletionBlock)CMNetwork_completionBlock {
    return objc_getAssociatedObject(self, CMNetwork_completionKey);
}


#pragma mark - CMNetwork_progressBlock

- (void)setCMNetwork_progressBlock:(CMNetworkTaskProgressBlock)CMNetwork_progressBlock {
    objc_setAssociatedObject(self, CMNetwork_progressKey, CMNetwork_progressBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CMNetworkTaskProgressBlock)CMNetwork_progressBlock {
    return objc_getAssociatedObject(self, CMNetwork_progressKey);
}

#pragma mark - CMNetwork_responseProgressBlock

- (void)setCMNetwork_responseProgressBlock:(CMNetworkTaskResponseProgressBlock)CMNetwork_responseProgressBlock {
    objc_setAssociatedObject(self, CMNetwork_responseProgressKey, CMNetwork_responseProgressBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CMNetworkTaskResponseProgressBlock)CMNetwork_responseProgressBlock {
    return objc_getAssociatedObject(self, CMNetwork_responseProgressKey);
}


#pragma mark - CMNetwork_responseBlock

- (void)setCMNetwork_responseBlock:(CMNetworkTaskResponseBlock)CMNetwork_responseBlock {
    objc_setAssociatedObject(self, CMNetwork_responseKey, CMNetwork_responseBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CMNetworkTaskResponseBlock)CMNetwork_responseBlock {
    return objc_getAssociatedObject(self, CMNetwork_responseKey);

}


@end
