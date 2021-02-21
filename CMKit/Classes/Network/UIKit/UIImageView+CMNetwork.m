//
//  UIImageView+CMNetwork.m
//  Pods
//
//  Created by chenjiemin on 16/12/10.
//
//

#import "UIImageView+CMNetwork.h"
#import "CMNetworkHTTPRequest.h"
#import "CMNetworkDataRequest.h"
#import "CMNetworkFileRequest.h"
#import "CMNetworkImageCache.h"
#import "CMNetworkGIFImageDecoder.h"
#import "UIImage+CMNetwork.h"
#import "CMNetworkUtil.h"
#import <objc/runtime.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTType.h>

typedef void (^CMNetworkCancelBlock)(void) ;

NSString * const CMNetworkImageViewURLErrorDomain = @"com.beauty.error.imageview.request";
NSString * const CMNEtworkImageViewURLCancelDomain = @"com.beauty.cancel.imageview.request";

static NSOperationQueue *_sOperationQueue = nil;



static const void *CMNetwork_imageTaskKey = &CMNetwork_imageTaskKey;
static const char *CMNetwork_imageUrlKey = "CMNetwork_imageUrlKey";
static const char *CMNetwork_GIFImageDecoderKey = "CMNetwork_GIFImageDecoderKey";

@implementation UIImageView (CMNetwork)
@dynamic CMNetwork_imageViewTask;

#pragma mark - Accessor

- (NSOperationQueue *)CMNetwork_operationQueue {
    return objc_getAssociatedObject(self, CMNetwork_imageTaskKey);
}

- (id)CMNetwork_task {
    return objc_getAssociatedObject(self, CMNetwork_imageTaskKey);
}

- (void)setCMNetwork_task:(id)CMNetwork_imageViewTask {
    objc_setAssociatedObject(self, CMNetwork_imageTaskKey, CMNetwork_imageViewTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setCMNetwork_imageUrl:(NSString *)CMNetwork_imageUrl {
    objc_setAssociatedObject(self, CMNetwork_imageUrlKey, CMNetwork_imageUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)CMNetwork_imageUrl {
    return objc_getAssociatedObject(self, CMNetwork_imageUrlKey);
}

- (void)setCMNetwork_GIFImageDecoder:(CMNetworkGIFImageDecoder *)CMNetwork_GIFImageDecoder {
    objc_setAssociatedObject(self, CMNetwork_GIFImageDecoderKey, CMNetwork_GIFImageDecoder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CMNetworkGIFImageDecoder *)CMNetwork_GIFImageDecoder {
    return objc_getAssociatedObject(self, CMNetwork_GIFImageDecoderKey);
}


#pragma mark - 外部接口

- (void)setCMNetwork_ImageWithURLString:(nullable NSString *)urlString {
    [self setCMNetwork_ImageWithURLString:urlString
                         placeholderImage:nil
                         animatedDuration:0
                                 progress:nil
                                  success:nil
                                  failure:nil];
}

- (void)setCMNetwork_ImageWithURLString:(nullable NSString *)urlString
                       animatedDuration:(CGFloat)animatedDuration {
    
    [self setCMNetwork_ImageWithURLString:urlString
                         placeholderImage:nil
                         animatedDuration:(CGFloat)animatedDuration
                                 progress:nil
                                  success:nil
                                  failure:nil];
}

- (void)setCMNetwork_ImageWithURLString:(nullable NSString *)urlString
                       placeholderImage:(nullable UIImage *)placeholderImage
                       animatedDuration:(CGFloat)animatedDuration {
    
    [self setCMNetwork_ImageWithURLString:urlString
                         placeholderImage:placeholderImage
                         animatedDuration:(CGFloat)animatedDuration
                                 progress:nil
                                  success:nil
                                  failure:nil];
}

- (void)setCMNetwork_ImageWithURLString:(nullable NSString *)urlString
                       placeholderImage:(nullable UIImage *)placeholderImage
                       animatedDuration:(CGFloat)animatedDuration
                                success:(nullable CMNetworkImageSuccessBlock)successBlock
                                failure:(nullable CMNetworkImageFailureBlock)failureBlock {
    
    [self setCMNetwork_ImageWithURLString:urlString
                         placeholderImage:placeholderImage
                         animatedDuration:(CGFloat)animatedDuration
                                 progress:nil
                                  success:successBlock
                                  failure:failureBlock];
}

- (void)setCMNetwork_ImageWithURLString:(nullable NSString *)urlString
                       placeholderImage:(nullable UIImage *)placeholderImage
                       animatedDuration:(CGFloat)animatedDuration
                               progress:(nullable CMNetworkProgressBlock)progressBlock
                                success:(nullable CMNetworkImageSuccessBlock)successBlock
                                failure:(nullable CMNetworkImageFailureBlock)failureBlock {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setCMNetwork_ImageWithURLRequest:request
                         placeholderImage:placeholderImage
                          animatedDuration:animatedDuration
                                 progress:progressBlock
                                  success:successBlock
                                  failure:failureBlock];
}

- (void)setCMNetwork_ImageWithURLRequest:(nullable NSURLRequest *)urlRequest
                        placeholderImage:(nullable UIImage *)placeholderImage
                        animatedDuration:(CGFloat)animatedDuration
                                progress:(nullable CMNetworkProgressBlock)progressBlock
                                 success:(nullable CMNetworkImageSuccessBlock)successBlock
                                 failure:(nullable CMNetworkImageFailureBlock)failureBlock {
    
    // 取消请求
    [self CMNetwork_cancelImageRequest];
    
    // 移除gif播放动画
    [self.layer removeAnimationForKey:@"contents"];

    // 错误处理
    if (!urlRequest || !urlRequest.URL) {
        self.image = placeholderImage;
        
        if (failureBlock) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"CMNetwork: url is null."                                                                      forKey:NSLocalizedDescriptionKey];
            NSError *error = [[NSError alloc] initWithDomain:CMNetworkImageViewURLErrorDomain
                                                        code:NSURLErrorBadURL
                                                    userInfo:userInfo];
            
            failureBlock(urlRequest, nil, error);
        }
        
        return;
    }
    
    // 获取缓存
    UIImage *cachedImage = [[CMNetworkImageCache sharedInstance] cachedImageForRequest:urlRequest];
    
    if (cachedImage) { // 如果有图片缓存
        
        if (cachedImage.CMNetworkKeyframeAnimation) { // 如果是gif
            self.image = cachedImage;
            [self.layer addAnimation:cachedImage.CMNetworkKeyframeAnimation forKey:@"contents"];
        } else {
            self.image = cachedImage;
        }
        
        if (successBlock) {
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:urlRequest.URL
                                                                MIMEType:nil //MIMEType
                                                   expectedContentLength:-1//imageData.length   // 由于获取Data太久，所以就不直接获取了。
                                                        textEncodingName:nil];
            successBlock(urlRequest, response, cachedImage);
        }
    } else { // 如果没有图片缓存
        
        self.image = placeholderImage;
        
        __weak typeof (self) weakSelf = self;
        
//        // 请求完成block
//        void (^requestCompletionBlock)(NSURLResponse *response, NSData *data, NSError *error) = ^(NSURLResponse *response, NSData *data, NSError *error) {
//
//            __strong typeof (weakSelf) strongSelf = weakSelf;
//
//            if (error) {
//                if (failureBlock) {
//                    failureBlock(urlRequest, response, error);
//                }
//            } else {
//
//                @try {
//                    // 解码图片
//                    CMNetworkGIFImageDecoder *decoder = [[CMNetworkGIFImageDecoder alloc] init];
//                    [decoder decodeImageData:data size:strongSelf.bounds.size scale:1 resizeMode:UIViewContentModeScaleAspectFill completionHandler:^(NSError *error, UIImage *image) {
//
//                        if (image.CMNetworkKeyframeAnimation) {  // 如果是gif
//                            strongSelf.image = image;
//                            [strongSelf.layer addAnimation:image.CMNetworkKeyframeAnimation forKey:@"contents"];
//                        } else {
//
//                            if (animatedDuration < 0.01) {
//                                strongSelf.image = image;
//                            } else {
//                                // 做渐变动画
//                                [UIView transitionWithView:strongSelf duration:animatedDuration options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction animations:^{
//                                    strongSelf.image = image;
//
//                                } completion:nil];
//                            }
//                        }
//                        
//                        if (successBlock) {
//                            successBlock(urlRequest, response, image);
//                        }
//
//                        [[CMNetworkImageCache sharedInstance] setCacheImage:image forRequest:urlRequest];
//
//                    }];
//                 } @catch (NSException *exception) {
//                     NSError *exceptionError = [[NSError alloc] initWithDomain:CMNetworkImageViewURLErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedDescriptionKey:exception.description}];
//                     if (failureBlock) {
//                         failureBlock(urlRequest, response, exceptionError);
//                     }
//                 }
//            }
//
//        };
//
        
        // 请求完成block
        void (^requestCompletionBlock)(NSURLResponse *response, UIImage *image, NSError *error) = ^(NSURLResponse *response, UIImage *image, NSError *error) {
            
            __strong typeof (weakSelf) strongSelf = weakSelf;
            
            if (error) {
                if (failureBlock) {
                    failureBlock(urlRequest, response, error);
                }
            } else if (!image) {
                if (failureBlock) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"CMNetwork: url is not image url"                                                                      forKey:NSLocalizedDescriptionKey];
                    NSError *error = [[NSError alloc] initWithDomain:CMNetworkImageViewURLErrorDomain
                                                                code:NSURLErrorBadURL
                                                            userInfo:userInfo];
                    failureBlock(urlRequest, response, error);
                }
            } else {
                if (image.CMNetworkKeyframeAnimation) {  // 如果是gif
                    strongSelf.image = image;
                    [strongSelf.layer addAnimation:image.CMNetworkKeyframeAnimation forKey:@"contents"];
                } else {
                    
                    if (animatedDuration < 0.01) {
                        strongSelf.image = image;
                    } else {
                        // 做渐变动画
                        [UIView transitionWithView:strongSelf duration:animatedDuration options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction animations:^{
                            strongSelf.image = image;
                            
                        } completion:nil];
                    }
                }
                
                if (successBlock) {
                    successBlock(urlRequest, response, image);
                }
            }            
        };
        

        
        if ([[CMNetworkHTTPRequest standardRequest] canHandleRequest:urlRequest]) { // http请求
            self.CMNetwork_task = [[CMNetworkHTTPRequest standardRequest] getWithRequest:urlRequest response:^(NSURLResponse *response) {
                
            } responseProgress:^(NSURLResponse *response, int64_t progress, int64_t total) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if ([[response URL].absoluteString isEqualToString:strongSelf.CMNetwork_imageUrl]) {
                    if (progressBlock) {
                        progressBlock(progress, total);
                    }
                }
            } completion:^(NSURLResponse *response, NSData *data, NSError *error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf decodeResponse:response date:data error:error requestCompletionBlock:requestCompletionBlock];
            }];
            self.CMNetwork_imageUrl = urlRequest.URL.absoluteString;
        } else if ([[CMNetworkDataRequest standardRequest] canHandleRequest:urlRequest]) { // data请求
            self.CMNetwork_task = [[CMNetworkDataRequest standardRequest] fecthWithRequest:urlRequest completion:^(NSURLResponse *response, NSData *data, NSError *error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf decodeResponse:response date:data error:error requestCompletionBlock:requestCompletionBlock];
            }];
            self.CMNetwork_imageUrl = urlRequest.URL.absoluteString;
        } else if ([[CMNetworkFileRequest standardRequest] canHandleRequest:urlRequest]) { // file请求
            self.CMNetwork_task = [[CMNetworkFileRequest standardRequest] fecthWithRequest:urlRequest completion:^(NSURLResponse *response, NSData *data, NSError *error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf decodeResponse:response date:data error:error requestCompletionBlock:requestCompletionBlock];
            }];
            self.CMNetwork_imageUrl = urlRequest.URL.absoluteString;
        }
    }
}

- (void)decodeResponse:(NSURLResponse*)response date:(NSData*)data error:(NSError*)error requestCompletionBlock:(void(^)(NSURLResponse *response,UIImage *image, NSError *error))requestCompletionBlock {
    if (error ) {
        if (requestCompletionBlock) {
            requestCompletionBlock(response, nil, error);
            return;
        }
    }
    
    @try {
        // 解码图片
        __weak typeof (self) weakSelf = self;
        
        self.CMNetwork_GIFImageDecoder = [[CMNetworkGIFImageDecoder alloc] init];
        [self.CMNetwork_GIFImageDecoder asyncDecodeImageData:data size:self.bounds.size scale:1 resizeMode:UIViewContentModeScaleAspectFill completionHandler:^(NSError *error, UIImage *image) {
            if ([[response URL].absoluteString isEqualToString:weakSelf.CMNetwork_imageUrl]) {
                if (requestCompletionBlock) {
                    requestCompletionBlock(response, image, error);
                }
                weakSelf.CMNetwork_task = nil;
                weakSelf.CMNetwork_imageUrl = nil;
            }
            [[CMNetworkImageCache sharedInstance] setCacheImage:image forRequest:[NSURLRequest requestWithURL:response.URL]];
        }];
        
        
    } @catch (NSException *exception) {
        NSError *exceptionError = [[NSError alloc] initWithDomain:CMNetworkImageViewURLErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedDescriptionKey:exception.description}];
        if ([[response URL].absoluteString isEqualToString:self.CMNetwork_imageUrl]) {
            if (requestCompletionBlock) {
                requestCompletionBlock(response, nil, exceptionError);
            }
            self.CMNetwork_task = nil;
            self.CMNetwork_imageUrl = nil;
        }
    }
    
}

//- (void)decodeResponse *response, NSData *data, NSError *error

- (void)CMNetwork_cancelImageRequest {
    if (self.CMNetwork_task
        && ([self.CMNetwork_task isKindOfClass:[NSURLSessionTask class]]
            || [self.CMNetwork_task isKindOfClass:[NSBlockOperation class]])) {
        [self.CMNetwork_task cancel];
        self.CMNetwork_task = nil;
    }
}

@end
