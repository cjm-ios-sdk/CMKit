//
//  CMNetworkHTTPRequest.h
//  Pods
//
//  缓存采用系统自带的NSURLCache实现，默认为
//  @code
//  + (void)load {
//      [[NSURLCache sharedURLCache] setDiskCapacity:1024 * 1024 * 100]; // 500M
//      [[NSURLCache sharedURLCache] setMemoryCapacity:1024 * 1024 * 10]; // 10M
//  }
//  @endcode
//
//  可根据具体需求来修改。
//
//  http网络请求
//
//  Created by chenjm on 2016/12/6.
//
//

#import <Foundation/Foundation.h>
#import "CMNetworkHTTPParam.h"
#import "CMNetworkConfiguration.h"
#import "CMNetworkHeader.h"


@interface CMNetworkHTTPRequest : NSObject

/**
 * @brief 返回全局的对象
 */
+ (CMNetworkHTTPRequest *)standardRequest;

/**
 * @brief 创建一个对象， ⚠️清除内存需要调用 invalidate
 */
+ (CMNetworkHTTPRequest *)createObject;

/**
 * @brief 全部无效。如果要释放该类，需要调用这个方法。
 */
- (void)invalidate;

/**
 * @brief 能否请求
 */
- (BOOL)canHandleRequest:(NSURLRequest *)request;

/**
 * @brief get请求
 * @param urlString 请求的链接
 * @param param 参数
 * @param completion 请求完成的回调
 */
- (NSURLSessionTask *)getWithURLString:(NSString *)urlString
                                 param:(NSDictionary *)param
                            completion:(CMNetworkCompletionBlock)completion;

/**
 * @brief get请求
 * @param request 请求
 * @param response 请求响应的回调
 * @param progress 请求进度的回调
 * @param completion 请求完成的回调
 */
- (NSURLSessionTask *)getWithRequest:(NSURLRequest *)request
                            response:(CMNetworkResponseBlock)response
                            progress:(CMNetworkProgressBlock)progress
                          completion:(CMNetworkCompletionBlock)completion;

/**
 * @brief post请求
 * @param urlString 请求的链接
 * @param param 请求的参数
 * @param completion 请求完成的回调
 */
- (NSURLSessionTask *)postWithURLString:(NSString *)urlString
                                  param:(NSDictionary *)param
                             completion:(CMNetworkCompletionBlock)completion;

/**
 * @brief post请求
 * @param request 请求
 * @param response 请求响应的回调
 * @param progress 请求进度的回调
 * @param completion 请求完成的回调
 */
- (NSURLSessionTask *)postWithRequest:(NSURLRequest *)request
                             response:(CMNetworkResponseBlock)response
                             progress:(CMNetworkProgressBlock)progress
                           completion:(CMNetworkCompletionBlock)completion;

/**
 * @brief post请求
 * @param request 请求
 * @param response 请求响应的回调
 * @param responseProgress 请求进度的回调(返回参数多加了response)
 * @param completion 请求完成的回调
 */
- (NSURLSessionTask *)getWithRequest:(NSURLRequest *)request
                            response:(CMNetworkResponseBlock)response
                    responseProgress:(CMNetworkResponseProgressBlock)responseProgress
                          completion:(CMNetworkCompletionBlock)completion;

/**
 * @brief 通用型的请求
 * @param configuration 请求的配置
 * @param completion 请求完成的回调
 */
- (NSURLSessionTask *)fecthWithParam:(CMNetworkHTTPParam *)param
                       configuration:(CMNetworkConfiguration *)configuration
                          completion:(CMNetworkCompletionBlock)completion;

/**
 * @brief 通用型的请求
 * @param param 请求的参数
 * @param configuration 请求配置
 * @param progress 请求进度的回调
 * @param completion 请求完成的回调
 */
- (NSURLSessionTask *)fecthWithParam:(CMNetworkHTTPParam *)param
                       configuration:(CMNetworkConfiguration *)configuration
                            response:(CMNetworkResponseBlock)response
                            progress:(CMNetworkProgressBlock)progress
                          completion:(CMNetworkCompletionBlock)completion;

/**
 * @brief 通用型的请求
 * @param param 请求的参数
 * @param configuration 请求配置
 * @param progress 请求进度的回调
 * @param responseProgress 请求进度的回调(返回多了response参数)
 * @param completion 请求完成的回调
 */
- (NSURLSessionTask *)fecthWithParam:(CMNetworkHTTPParam *)param
                       configuration:(CMNetworkConfiguration *)configuration
                            response:(CMNetworkResponseBlock)response
                            progress:(CMNetworkProgressBlock)progress
                    responseProgress:(CMNetworkResponseProgressBlock)responseProgress
                          completion:(CMNetworkCompletionBlock)completion;



@end
