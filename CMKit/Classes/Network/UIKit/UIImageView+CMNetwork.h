//
//  UIImageView+CMNetwork.h
//  Pods
//
//  描述：UIImageView 对加载网络图片的扩展，实现对网络资源的图片、gif的加载
//
//  Created by chenjiemin on 16/12/10.
//
//

#import <UIKit/UIKit.h>
#import "CMNetworkHeader.h"

@interface UIImageView (CMNetwork)
@property (nonatomic, strong) id _Nullable CMNetwork_imageViewTask;


/**
 * @brief 设置网络图片
 * @param urlString 图片链接
 */
- (void)setCMNetwork_ImageWithURLString:(nullable NSString *)urlString;

/**
 * @brief 设置网络图片
 * @param urlString 图片链接
 * @param animatedDuration 动画时长
 */
- (void)setCMNetwork_ImageWithURLString:(nullable NSString *)urlString
                       animatedDuration:(CGFloat)animatedDuration;

/**
 * @brief 设置网络图片
 * @param urlString 图片链接
 * @param placeholderImage 默认图片
 * @param animatedDuration 动画时长
 */
- (void)setCMNetwork_ImageWithURLString:(nullable NSString *)urlString
                       placeholderImage:(nullable UIImage *)placeholderImage
                       animatedDuration:(CGFloat)animatedDuration;

/**
 * @brief 设置网络图片
 * @param urlString 图片链接
 * @param placeholderImage 默认图片
 * @param animatedDuration 动画时长
 * @param success 成功block
 * @param failure 失败block
 */
- (void)setCMNetwork_ImageWithURLString:(nullable NSString *)urlString
                       placeholderImage:(nullable UIImage *)placeholderImage
                       animatedDuration:(CGFloat)animatedDuration
                                success:(nullable CMNetworkImageSuccessBlock)success
                                failure:(nullable CMNetworkImageFailureBlock)failure;

/**
 * @brief 设置网络图片
 * @param urlString 图片链接
 * @param placeholderImage 默认图片
 * @param animatedDuration 动画时长
 * @param progress 进度block
 * @param success 成功block
 * @param failure 失败block
 */
- (void)setCMNetwork_ImageWithURLString:(nullable NSString *)urlString
                       placeholderImage:(nullable UIImage *)placeholderImage
                       animatedDuration:(CGFloat)animatedDuration
                               progress:(nullable CMNetworkProgressBlock)progress
                                success:(nullable CMNetworkImageSuccessBlock)success
                                failure:(nullable CMNetworkImageFailureBlock)failure;

/**
 * @brief 设置网络图片
 * @param urlRequest 网络请求
 * @param placeholderImage 默认图片
 * @param animatedDuration 动画时长
 * @param progress 进度block
 * @param success 成功block
 * @param failure 失败block
 */
- (void)setCMNetwork_ImageWithURLRequest:(nullable NSURLRequest *)urlRequest
                       placeholderImage:(nullable UIImage *)placeholderImage
                        animatedDuration:(CGFloat)animatedDuration
                               progress:(nullable CMNetworkProgressBlock)progress
                                success:(nullable CMNetworkImageSuccessBlock)success
                                failure:(nullable CMNetworkImageFailureBlock)failure;

/**
 * @brief 取消图片请求
 */
- (void)CMNetwork_cancelImageRequest;

@end
