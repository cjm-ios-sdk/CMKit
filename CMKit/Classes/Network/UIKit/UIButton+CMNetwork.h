//
//  UIButton+CMNetwork.h
//  Pods
//
//  UIButton对加载网络图片的扩展
//
//  Created by chenjm on 2016/12/13.
//
//

#import <UIKit/UIKit.h>
#import "CMNetworkHeader.h"

@interface UIButton (CMNetwork)


#pragma mark - 通过urlString 设置button的图片

- (void)setCMNetwork_imageURLString:(nullable NSString *)urlString
                           forState:(UIControlState)state;

- (void)setCMNetwork_imageURLString:(nullable NSString *)urlString
                   animatedDuration:(CGFloat)animatedDuration
                           forState:(UIControlState)state;

- (void)setCMNetwork_imageURLString:(nullable NSString *)urlString
                   placeholderImage:(nullable UIImage *)placeholderImage
                           forState:(UIControlState)state;

- (void)setCMNetwork_imageURLString:(nullable NSString *)urlString
                   placeholderImage:(nullable UIImage *)placeholderImage
                   animatedDuration:(CGFloat)animatedDuration
                           forState:(UIControlState)state;

#pragma mark - 通过url 设置button的图片

- (void)setCMNetwork_imageURL:(nullable NSURL *)url
                     forState:(UIControlState)state;

- (void)setCMNetwork_imageURL:(nullable NSURL *)url
             animatedDuration:(CGFloat)animatedDuration
                     forState:(UIControlState)state;

- (void)setCMNetwork_imageURL:(nullable NSURL *)url
             placeholderImage:(nullable UIImage *)placeholderImage
                     forState:(UIControlState)state;

- (void)setCMNetwork_imageURL:(nullable NSURL *)url
             placeholderImage:(nullable UIImage *)placeholderImage
             animatedDuration:(CGFloat)animatedDuration
                     forState:(UIControlState)state;

#pragma mark - 通过urlRequest 设置button的图片

- (void)setCMNetwork_imageURLRequest:(nullable NSURLRequest *)urlRequest
                    placeholderImage:(nullable UIImage *)placeholderImage
                    animatedDuration:(CGFloat)animatedDuration
                            forState:(UIControlState)state
                            progress:(nullable CMNetworkProgressBlock)progressBlock
                             success:(nullable CMNetworkImageSuccessBlock)successBlock
                             failure:(nullable CMNetworkImageFailureBlock)failureBlock;


#pragma mark - 通过urlString 设置button的的背景图片

- (void)setCMNetwork_backgroundImageURLString:(nullable NSString *)urlString
                               forState:(UIControlState)state;

- (void)setCMNetwork_backgroundImageURLString:(nullable NSString *)urlString
                             animatedDuration:(CGFloat)animatedDuration
                                     forState:(UIControlState)state;

- (void)setCMNetwork_backgroundImageURLString:(nullable NSString *)urlString
                             placeholderImage:(nullable UIImage *)placeholderImage
                                     forState:(UIControlState)state;

- (void)setCMNetwork_backgroundImageURLString:(nullable NSString *)urlString
                             placeholderImage:(nullable UIImage *)placeholderImage
                             animatedDuration:(CGFloat)animatedDuration
                                     forState:(UIControlState)state;

#pragma mark - 通过url 设置button的背景图片

- (void)setCMNetwork_backgroundImageURL:(nullable NSURL *)url
                               forState:(UIControlState)state;

- (void)setCMNetwork_backgroundImageURL:(nullable NSURL *)url
                       animatedDuration:(CGFloat)animatedDuration
                               forState:(UIControlState)state;

- (void)setCMNetwork_backgroundImageURL:(nullable NSURL *)url
                       placeholderImage:(nullable UIImage *)placeholderImage
                               forState:(UIControlState)state;

- (void)setCMNetwork_backgroundImageURL:(nullable NSURL *)url
                       placeholderImage:(nullable UIImage *)placeholderImage
                       animatedDuration:(CGFloat)animatedDuration
                               forState:(UIControlState)state;


#pragma mark - 通过urlRequest 设置button的背景图片

- (void)setCMNetwork_backgroundImageURLRequest:(nullable NSURLRequest *)urlRequest
                              placeholderImage:(nullable UIImage *)placeholderImage
                              animatedDuration:(CGFloat)animatedDuration
                                      forState:(UIControlState)state
                                      progress:(nullable CMNetworkProgressBlock)progressBlock
                                       success:(nullable CMNetworkImageSuccessBlock)successBlock
                                       failure:(nullable CMNetworkImageFailureBlock)failureBlock;

#pragma mark - 取消button的图片请求

- (void)CMNetwork_cancelImageRequestForState:(UIControlState)state;
- (void)CMNetwork_cancelBackgroundImageRequestForState:(UIControlState)state;




@end
