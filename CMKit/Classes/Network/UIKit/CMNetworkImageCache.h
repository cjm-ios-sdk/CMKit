//
//  CMNetworkImageCache.h
//  Pods
//
//  描述：网络图片的缓存
//
//  Created by chenjm on 2016/12/13.
//
//

#import <Foundation/Foundation.h>

@interface CMNetworkImageCache : NSCache

+ (CMNetworkImageCache *)sharedInstance;

/**
 * @brief 获取缓存中的图片，忽略url的参数部分
 * @param request 请求参数
 */
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;

/**
 * @brief 设置图片到缓存中
 * @param request 请求参数
 */
- (void)setCacheImage:(UIImage *)image forRequest:(NSURLRequest *)request;

/**
 * @brief 获取缓存中的图片，忽略url的参数部分
 * @param request 请求参数
 * @param ignoreURLParameter 是否忽略url的参数部分
 */
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request ignoreURLParameter:(BOOL)ignoreURLParameter;

/**
 * @brief 设置图片到缓存中
 * @param request 请求参数
 * @param ignoreURLParameter 是否忽略url的参数部分
 */
- (void)setCacheImage:(UIImage *)image forRequest:(NSURLRequest *)request ignoreURLParameter:(BOOL)ignoreURLParameter;
@end
