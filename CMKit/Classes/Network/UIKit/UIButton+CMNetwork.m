//
//  UIButton+CMNetwork.m
//  Pods
//
//  Created by chenjm on 2016/12/13.
//
//

#import "UIButton+CMNetwork.h"
#import "CMNetworkImageCache.h"
#import "CMNetworkHTTPRequest.h"
#import "CMNetworkDataRequest.h"
#import "CMNetworkFileRequest.h"
#import <objc/runtime.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTType.h>


NSString * const CMNetworkButtonImageURLErrorDomain = @"com.beauty.error.button.request";
NSString * const CMNetworkButtonImageURLCancelDomain = @"com.beauty.cancel.button.request";

static NSOperationQueue *_sOperationQueue = nil;

static inline BOOL hasAlpha(UIImage *image) {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}


@implementation UIButton (CMNetwork)


#pragma mark - Accessor

static char CMNetworkButtonImageTaskNormal;
static char CMNetworkButtonImageTaskHighlighted;
static char CMNetworkButtonImageTaskSelected;
static char CMNetworkButtonImageTaskDisabled;

static char CMNetworkButtonImageUrlNormalKey;
static char CMNetworkButtonImageUrlHighlightedKey;
static char CMNetworkButtonImageUrlSelectedKey;
static char CMNetworkButtonImageUrlDisabledKey;

static const char * CMNetwork_buttonImageTaskKeyForState(UIControlState state) {
    switch (state) {
        case UIControlStateHighlighted:
            return &CMNetworkButtonImageTaskHighlighted;
        case UIControlStateSelected:
            return &CMNetworkButtonImageTaskSelected;
        case UIControlStateDisabled:
            return &CMNetworkButtonImageTaskDisabled;
        case UIControlStateNormal:
        default:
            return &CMNetworkButtonImageTaskNormal;
    }
}

static const char * CMNetwork_buttonImageUrlKeyForState(UIControlState state) {
    switch (state) {
        case UIControlStateHighlighted:
            return &CMNetworkButtonImageUrlHighlightedKey;
        case UIControlStateSelected:
            return &CMNetworkButtonImageUrlSelectedKey;
        case UIControlStateDisabled:
            return &CMNetworkButtonImageUrlDisabledKey;
        case UIControlStateNormal:
        default:
            return &CMNetworkButtonImageUrlNormalKey;
    }
}

- (id)CMNetwork_buttonImageTaskForState:(UIControlState)state {
    return objc_getAssociatedObject(self, CMNetwork_buttonImageTaskKeyForState(state));
}

- (void)setCMNetwork_buttonImageTask:(id)CMNetwork_buttonImageTask forState:(UIControlState)state {
    objc_setAssociatedObject(self, CMNetwork_buttonImageTaskKeyForState(state), CMNetwork_buttonImageTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)CMNetwork_buttonImageUrlForState:(UIControlState)state {
    return objc_getAssociatedObject(self, CMNetwork_buttonImageUrlKeyForState(state));
}

- (void)setCMNetwork_buttonImageUrl:(id)CMNetwork_buttonImageUrl forState:(UIControlState)state {
    objc_setAssociatedObject(self, CMNetwork_buttonImageUrlKeyForState(state), CMNetwork_buttonImageUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -

static char SLButtonBackgoundImageTaskNormal;
static char SLButtonBackgoundImageTaskHighlighted;
static char SLButtonBackgoundImageTaskSelected;
static char SLButtonBackgoundImageTaskDisabled;

static const char * CMNetwork_buttonBackgoundImageTaskKeyForState(UIControlState state) {
    switch (state) {
        case UIControlStateHighlighted:
            return &SLButtonBackgoundImageTaskHighlighted;
        case UIControlStateSelected:
            return &SLButtonBackgoundImageTaskSelected;
        case UIControlStateDisabled:
            return &SLButtonBackgoundImageTaskDisabled;
        case UIControlStateNormal:
        default:
            return &SLButtonBackgoundImageTaskNormal;
    }
}

- (id)CMNetwork_buttonBackgoundImageTaskForState:(UIControlState)state {
    return objc_getAssociatedObject(self, CMNetwork_buttonBackgoundImageTaskKeyForState(state));
}

- (void)setCMNetwork_buttonBackgoundImageTask:(id)backgoundImageTask
                                     forState:(UIControlState)state {
    objc_setAssociatedObject(self, CMNetwork_buttonBackgoundImageTaskKeyForState(state), backgoundImageTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - setImage:forState:

- (void)setCMNetwork_imageURLString:(nullable NSString *)urlString
                           forState:(UIControlState)state {
    if (!urlString) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setCMNetwork_imageURLRequest:urlRequest
                      placeholderImage:nil
                      animatedDuration:0
                              forState:state
                              progress:nil
                               success:nil
                               failure:nil];
}

- (void)setCMNetwork_imageURLString:(nullable NSString *)urlString
                   animatedDuration:(CGFloat)animatedDuration
                           forState:(UIControlState)state {
    if (!urlString) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setCMNetwork_imageURLRequest:urlRequest
                      placeholderImage:nil
                      animatedDuration:animatedDuration
                              forState:state
                              progress:nil
                               success:nil
                               failure:nil];
}

- (void)setCMNetwork_imageURLString:(nullable NSString *)urlString
                   placeholderImage:(nullable UIImage *)placeholderImage
                           forState:(UIControlState)state {
    if (!urlString) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setCMNetwork_imageURLRequest:urlRequest
                      placeholderImage:placeholderImage
                      animatedDuration:0
                              forState:state
                              progress:nil
                               success:nil
                               failure:nil];
}

- (void)setCMNetwork_imageURLString:(nullable NSString *)urlString
                   placeholderImage:(nullable UIImage *)placeholderImage
                   animatedDuration:(CGFloat)animatedDuration
                           forState:(UIControlState)state {
    if (!urlString) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setCMNetwork_imageURLRequest:urlRequest
                      placeholderImage:placeholderImage
                      animatedDuration:animatedDuration
                              forState:state
                              progress:nil
                               success:nil
                               failure:nil];
}


#pragma mark -

- (void)setCMNetwork_imageURL:(nullable NSURL *)url
                     forState:(UIControlState)state {
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setCMNetwork_imageURLRequest:urlRequest
                      placeholderImage:nil
                      animatedDuration:0
                              forState:state
                              progress:nil
                               success:nil
                               failure:nil];
}

- (void)setCMNetwork_imageURL:(nullable NSURL *)url
             animatedDuration:(CGFloat)animatedDuration
                     forState:(UIControlState)state {
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setCMNetwork_imageURLRequest:urlRequest
                      placeholderImage:nil
                      animatedDuration:animatedDuration
                              forState:state
                              progress:nil
                               success:nil
                               failure:nil];
}

- (void)setCMNetwork_imageURL:(nullable NSURL *)url
             placeholderImage:(nullable UIImage *)placeholderImage
                     forState:(UIControlState)state {
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setCMNetwork_imageURLRequest:urlRequest
                      placeholderImage:placeholderImage
                      animatedDuration:0
                              forState:state
                              progress:nil
                               success:nil
                               failure:nil];
}

- (void)setCMNetwork_imageURL:(nullable NSURL *)url
             placeholderImage:(nullable UIImage *)placeholderImage
             animatedDuration:(CGFloat)animatedDuration
                     forState:(UIControlState)state {
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self setCMNetwork_imageURLRequest:urlRequest
                      placeholderImage:placeholderImage
                      animatedDuration:animatedDuration
                              forState:state
                              progress:nil
                               success:nil
                               failure:nil];
}


#pragma mark -

- (void)setCMNetwork_imageURLRequest:(nullable NSURLRequest *)urlRequest
                    placeholderImage:(nullable UIImage *)placeholderImage
                    animatedDuration:(CGFloat)animatedDuration
                            forState:(UIControlState)state
                            progress:(CMNetworkProgressBlock)progressBlock
                             success:(CMNetworkImageSuccessBlock)successBlock
                             failure:(CMNetworkImageFailureBlock)failureBlock {
    
    [self CMNetwork_cancelImageRequestForState:state];
    
    if (!urlRequest || !urlRequest.URL) {
        [self setImage:placeholderImage forState:state];

        if (failureBlock) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"CMNetwork: url is null."                                                                      forKey:NSLocalizedDescriptionKey];
            NSError *error = [[NSError alloc] initWithDomain:CMNetworkButtonImageURLErrorDomain
                                                        code:NSURLErrorBadURL
                                                    userInfo:userInfo];

            failureBlock(urlRequest, nil, error);
        }
        
        return;
    }
    
    UIImage *cachedImage = [[CMNetworkImageCache sharedInstance] cachedImageForRequest:urlRequest];
    
    if (cachedImage) {
        [self setImage:cachedImage forState:state];

        if (successBlock) {
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:urlRequest.URL
                                                                MIMEType:nil //MIMEType
                                                   expectedContentLength:-1 //imageData.length
                                                        textEncodingName:nil];
            
            successBlock(urlRequest, response, cachedImage);
        }
    } else {
        [self setImage:placeholderImage forState:state];
        
        __weak typeof (self) weakSelf = self;
        
        // 请求完成block
        void (^requestCompletionBlock)(NSURLResponse *response, NSData *data, NSError *error) = ^(NSURLResponse *response, NSData *data, NSError *error) {
            
            __strong typeof (weakSelf) strongSelf = weakSelf;

            @try {
                if (error) {
                    if (failureBlock) {
                        failureBlock(urlRequest, response, error);
                    }
                } else if (!data) {
                    if (failureBlock) {
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"CMNetwork: url is not image url"                                                                      forKey:NSLocalizedDescriptionKey];
                        NSError *error = [[NSError alloc] initWithDomain:CMNetworkButtonImageURLErrorDomain
                                                                    code:NSURLErrorBadURL
                                                                userInfo:userInfo];
                        failureBlock(urlRequest, response, error);
                    }
                } else {
                    UIImage *image = [UIImage imageWithData:data];
                    
                    if (animatedDuration < 0.01) {
                        [strongSelf setImage:image forState:state];
                    } else {
                        [UIView transitionWithView:strongSelf duration:animatedDuration options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction animations:^{
                            [strongSelf setImage:image forState:state];
                        } completion:^(BOOL finished) {
                            
                        }];
                    }
                    
                    if (successBlock) {
                        successBlock(urlRequest, response, image);
                    }
                
                }
            } @catch (NSException *exception) {
                NSError *exceptionError = [[NSError alloc] initWithDomain:CMNetworkButtonImageURLErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedDescriptionKey:exception.description}];
                if (failureBlock) {
                    failureBlock(urlRequest, response, exceptionError);
                }
            }
        };
        
        if ([[CMNetworkHTTPRequest standardRequest] canHandleRequest:urlRequest]) {
            NSURLSessionTask *task = [[CMNetworkHTTPRequest standardRequest] getWithRequest:urlRequest response:^(NSURLResponse *response) {
                
            } responseProgress:^(NSURLResponse *response , int64_t progress, int64_t total) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if ([[response URL].absoluteString isEqualToString:[strongSelf CMNetwork_buttonImageUrlForState:state]]) {
                    if (progressBlock) {
                        progressBlock(progress, total);
                    }
                }
            } completion:^(NSURLResponse *response, NSData *data, NSError *error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if ([[response URL].absoluteString isEqualToString:[strongSelf CMNetwork_buttonImageUrlForState:state]]) {
                    requestCompletionBlock(response, data, error);
                    [strongSelf setCMNetwork_buttonImageUrl:nil forState:state];
                    [strongSelf setCMNetwork_buttonImageTask:nil forState:state];
                }
                if (data && !error) {
                    UIImage *image = [UIImage imageWithData:data];
                    [[CMNetworkImageCache sharedInstance] setCacheImage:image forRequest:urlRequest];
                }
            }];
            [self setCMNetwork_buttonImageTask:task forState:state];
            [self setCMNetwork_buttonImageUrl:urlRequest.URL.absoluteString forState:state];
        } else if ([[CMNetworkDataRequest standardRequest] canHandleRequest:urlRequest]) { // data请求
            NSOperation *task = [[CMNetworkDataRequest standardRequest] fecthWithRequest:urlRequest completion:^(NSURLResponse *response, NSData *data, NSError *error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if ([[response URL].absoluteString isEqualToString:[strongSelf CMNetwork_buttonImageUrlForState:state]]) {
                    requestCompletionBlock(response, data, error);
                    [strongSelf setCMNetwork_buttonImageUrl:nil forState:state];
                    [strongSelf setCMNetwork_buttonImageTask:nil forState:state];
                }
                if (data && !error) {
                    UIImage *image = [UIImage imageWithData:data];
                    [[CMNetworkImageCache sharedInstance] setCacheImage:image forRequest:urlRequest];
                }
            }];
            
            [self setCMNetwork_buttonImageTask:task forState:state];
        } else if ([[CMNetworkFileRequest standardRequest] canHandleRequest:urlRequest]) { // file请求
            NSOperation *task = [[CMNetworkFileRequest standardRequest] fecthWithRequest:urlRequest completion:^(NSURLResponse *response, NSData *data, NSError *error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if ([[response URL].absoluteString isEqualToString:[strongSelf CMNetwork_buttonImageUrlForState:state]]) {
                    requestCompletionBlock(response, data, error);
                    [strongSelf setCMNetwork_buttonImageUrl:nil forState:state];
                    [strongSelf setCMNetwork_buttonImageTask:nil forState:state];
                }
                if (data && !error) {
                    UIImage *image = [UIImage imageWithData:data];
                    [[CMNetworkImageCache sharedInstance] setCacheImage:image forRequest:urlRequest];
                }
            }];
            
            [self setCMNetwork_buttonImageTask:task forState:state];
        }
    }
}


#pragma mark - setBackgroundImage:forState:

- (void)setCMNetwork_backgroundImageURLString:(nullable NSString *)urlString
                                     forState:(UIControlState)state {
    if (!urlString) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self setCMNetwork_backgroundImageURLRequest:urlRequest
                                placeholderImage:nil
                                animatedDuration:0
                                        forState:state
                                        progress:nil
                                         success:nil
                                         failure:nil];
}

- (void)setCMNetwork_backgroundImageURLString:(nullable NSString *)urlString
                             animatedDuration:(CGFloat)animatedDuration
                                     forState:(UIControlState)state {
    if (!urlString) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self setCMNetwork_backgroundImageURLRequest:urlRequest
                                placeholderImage:nil
                                animatedDuration:animatedDuration
                                        forState:state
                                        progress:nil
                                         success:nil
                                         failure:nil];
}

- (void)setCMNetwork_backgroundImageURLString:(nullable NSString *)urlString
                             placeholderImage:(nullable UIImage *)placeholderImage
                                     forState:(UIControlState)state {
    if (!urlString) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self setCMNetwork_backgroundImageURLRequest:urlRequest
                                placeholderImage:placeholderImage
                                animatedDuration:0
                                        forState:state
                                        progress:nil
                                         success:nil
                                         failure:nil];
}

- (void)setCMNetwork_backgroundImageURLString:(nullable NSString *)urlString
                             placeholderImage:(nullable UIImage *)placeholderImage
                             animatedDuration:(CGFloat)animatedDuration
                                     forState:(UIControlState)state {
    if (!urlString) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self setCMNetwork_backgroundImageURLRequest:urlRequest
                                placeholderImage:placeholderImage
                                animatedDuration:animatedDuration
                                        forState:state
                                        progress:nil
                                         success:nil
                                         failure:nil];
}

#pragma mark -

- (void)setCMNetwork_backgroundImageURL:(nullable NSURL *)url
                               forState:(UIControlState)state {
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self setCMNetwork_backgroundImageURLRequest:urlRequest
                                placeholderImage:nil
                                animatedDuration:0
                                        forState:state
                                        progress:nil
                                         success:nil
                                         failure:nil];
}

- (void)setCMNetwork_backgroundImageURL:(nullable NSURL *)url
                       animatedDuration:(CGFloat)animatedDuration
                               forState:(UIControlState)state {
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self setCMNetwork_backgroundImageURLRequest:urlRequest
                                placeholderImage:nil
                                animatedDuration:animatedDuration
                                        forState:state
                                        progress:nil
                                         success:nil
                                         failure:nil];
}

- (void)setCMNetwork_backgroundImageURL:(nullable NSURL *)url
                       placeholderImage:(nullable UIImage *)placeholderImage
                               forState:(UIControlState)state {
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self setCMNetwork_backgroundImageURLRequest:urlRequest
                         placeholderImage:placeholderImage
                         animatedDuration:0
                                 forState:state
                                 progress:nil
                                  success:nil
                                  failure:nil];
}

- (void)setCMNetwork_backgroundImageURL:(nullable NSURL *)url
                       placeholderImage:(nullable UIImage *)placeholderImage
                       animatedDuration:(CGFloat)animatedDuration
                               forState:(UIControlState)state {
    if (!url) {
        return;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self setCMNetwork_backgroundImageURLRequest:urlRequest
                                placeholderImage:placeholderImage
                                animatedDuration:animatedDuration
                                        forState:state
                                        progress:nil
                                         success:nil
                                         failure:nil];
}

#pragma mark -

- (void)setCMNetwork_backgroundImageURLRequest:(nullable NSURLRequest *)urlRequest
                              placeholderImage:(nullable UIImage *)placeholderImage
                              animatedDuration:(CGFloat)animatedDuration
                                      forState:(UIControlState)state
                                      progress:(nullable CMNetworkProgressBlock)progressBlock
                                       success:(nullable CMNetworkImageSuccessBlock)successBlock
                                       failure:(nullable CMNetworkImageFailureBlock)failureBlock {
    
    [self CMNetwork_cancelBackgroundImageRequestForState:state];
    
    if (!urlRequest || !urlRequest.URL) {
        if (failureBlock) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"CMNetwork: url is null."                                                                      forKey:NSLocalizedDescriptionKey];
            NSError *error = [[NSError alloc] initWithDomain:CMNetworkButtonImageURLErrorDomain
                                                        code:NSURLErrorBadURL
                                                    userInfo:userInfo];
            
            failureBlock(urlRequest, nil, error);
        }

        [self setBackgroundImage:placeholderImage forState:state];

        return;
    }
    
    UIImage *cachedImage = [[CMNetworkImageCache sharedInstance] cachedImageForRequest:urlRequest];
    
    if (cachedImage) {
        
        [self setBackgroundImage:cachedImage forState:state];
        
        if (successBlock) {
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:urlRequest.URL
                                                                MIMEType:nil
                                                   expectedContentLength:-1
                                                        textEncodingName:nil];                                                       
            successBlock(urlRequest, response, cachedImage);
        }
    } else {
        if (placeholderImage) {
            [self setBackgroundImage:placeholderImage forState:state];
        }
        
        __weak typeof (self) weakSelf = self;

        // 请求完成block
        void (^requestCompletionBlock)(NSURLResponse *response, NSData *data, NSError *error) = ^(NSURLResponse *response, NSData *data, NSError *error) {
            
            __strong typeof (weakSelf) strongSelf = weakSelf;
            
            @try {
                if (error) {
                    if (failureBlock) {
                        failureBlock(urlRequest, response, error);
                    }
                } else if (!data) {
                    if (failureBlock) {
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"CMNetwork: url is not image url"                                                                      forKey:NSLocalizedDescriptionKey];
                        NSError *error = [[NSError alloc] initWithDomain:CMNetworkButtonImageURLErrorDomain
                                                                    code:NSURLErrorBadURL
                                                                userInfo:userInfo];
                        failureBlock(urlRequest, response, error);
                    }
                } else {
                    UIImage *image = [UIImage imageWithData:data];
                    
                    if (animatedDuration < 0.01) {
                        [strongSelf setBackgroundImage:image forState:state];
                    } else {
                        [UIView transitionWithView:strongSelf duration:animatedDuration options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction animations:^{
                            [strongSelf setBackgroundImage:image forState:state];
                        } completion:^(BOOL finished) {
                            
                        }];
                    }
                    
                    if (successBlock) {
                        successBlock(urlRequest, response, image);
                    }
                    
                    [[CMNetworkImageCache sharedInstance] setCacheImage:image forRequest:urlRequest];
                }
            } @catch (NSException *exception) {
                NSError *exceptionError = [[NSError alloc] initWithDomain:CMNetworkButtonImageURLErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedDescriptionKey:exception.description}];
                if (failureBlock) {
                    failureBlock(urlRequest, response, exceptionError);
                }
            }
        };
        
        if ([[CMNetworkHTTPRequest standardRequest] canHandleRequest:urlRequest]) { // http请求
            NSURLSessionTask *task = [[CMNetworkHTTPRequest standardRequest] getWithRequest:urlRequest response:^(NSURLResponse *response) {
                
            } progress:^(int64_t progress, int64_t total) {
                if (progressBlock) {
                    progressBlock(progress, total);
                }
            } completion:^(NSURLResponse *response, NSData *data, NSError *error) {
                requestCompletionBlock(response, data, error);
            }];
            
            [self setCMNetwork_buttonBackgoundImageTask:task forState:state];
                
        } else if ([[CMNetworkDataRequest standardRequest] canHandleRequest:urlRequest]) { // data请求
            NSOperation *task = [[CMNetworkDataRequest standardRequest] fecthWithRequest:urlRequest completion:^(NSURLResponse *response, NSData *data, NSError *error) {
                requestCompletionBlock(response, data, error);
            }];
            
            [self setCMNetwork_buttonBackgoundImageTask:task forState:state];

        } else if ([[CMNetworkFileRequest standardRequest] canHandleRequest:urlRequest]) { // file请求
            NSOperation *task = [[CMNetworkFileRequest standardRequest] fecthWithRequest:urlRequest completion:^(NSURLResponse *response, NSData *data, NSError *error) {
                requestCompletionBlock(response, data, error);
            }];
            
            [self setCMNetwork_buttonBackgoundImageTask:task forState:state];
        }
    }

}


#pragma mark - cancel

- (void)CMNetwork_cancelImageRequestForState:(UIControlState)state {
    [[self CMNetwork_buttonImageTaskForState:state] cancel];
    [self setCMNetwork_buttonImageTask:nil forState:state];
}

- (void)CMNetwork_cancelBackgroundImageRequestForState:(UIControlState)state {
    [[self CMNetwork_buttonBackgoundImageTaskForState:state] cancel];
    [self setCMNetwork_buttonBackgoundImageTask:nil forState:state];
}


@end
