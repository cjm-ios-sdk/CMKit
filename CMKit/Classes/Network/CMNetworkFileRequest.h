//
//  CMNetworkFileRequest.h
//  Pods
//
//  描述：对于文件的请求
//
//  Created by chenjm on 2016/11/29.
//
//

#import <Foundation/Foundation.h>
#import "CMNetworkHeader.h"

/**
 * 文件请求
 * 格式：file:///filepath
 */
@interface CMNetworkFileRequest : NSObject

/**
 * @brief 返回全局的对象
 */
+ (CMNetworkFileRequest *)standardRequest;

/**
 * @brief 创建一个对象
 */
+ (CMNetworkFileRequest *)createObject;

/**
 * @brief 全部无效
 */
- (void)invalidate;

/**
 * @brief 能否请求
 */
- (BOOL)canHandleRequest:(NSURLRequest *)request;

/**
 * @brief 请求
 */
- (NSOperation *)fecthWithRequest:(NSURLRequest *)request
                       completion:(CMNetworkCompletionBlock)completion;

/**
 * 取消请求
 */
- (void)cancelRequest:(NSOperation *)op;


@end
