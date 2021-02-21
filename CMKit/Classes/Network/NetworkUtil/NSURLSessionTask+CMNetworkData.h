//
//  NSURLSessionDataTask+CMNetworkData.h
//  Pods
//
//  Created by chenjm on 2016/12/9.
//
//

#import <Foundation/Foundation.h>

typedef void (^CMNetworkTaskProgressBlock)(int64_t progress, int64_t total);
typedef void (^CMNetworkTaskResponseBlock)(NSURLResponse *response);
typedef void (^CMNetworkTaskCompletionBlock)(NSURLResponse *response, NSData *data, NSError *error);
typedef void (^CMNetworkTaskResponseProgressBlock)(NSURLResponse *response, int64_t progress, int64_t total);

@interface NSURLSessionTask (CMNetworkData)
@property (atomic, strong) NSMutableData *CMNetwork_data;
@property (nonatomic, copy) CMNetworkTaskProgressBlock CMNetwork_progressBlock;
@property (nonatomic, copy) CMNetworkTaskCompletionBlock CMNetwork_completionBlock;
@property (nonatomic, copy) CMNetworkTaskResponseBlock CMNetwork_responseBlock;
@property (nonatomic, copy) CMNetworkTaskResponseProgressBlock CMNetwork_responseProgressBlock;
@end
