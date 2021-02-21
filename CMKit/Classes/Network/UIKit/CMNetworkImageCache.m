//
//  CMNetworkImageCache.m
//  Pods
//
//  Created by chenjm on 2016/12/13.
//
//

#import "CMNetworkImageCache.h"
#import <objc/runtime.h>


static inline NSString * CMNetworkImageCacheKeyFromURLRequest(NSURLRequest *request, BOOL ignoreURLParameter ) {
    NSString *urlStr = request.URL.absoluteString;
    
    
    if (ignoreURLParameter && urlStr && [urlStr isKindOfClass:[NSString class]]) {
        NSRange range = [urlStr rangeOfString:@"?"];
        if (range.length > 0) {
            urlStr = [urlStr substringToIndex:range.location];
        }
    }
    
    return urlStr;
}

@implementation CMNetworkImageCache

+ (CMNetworkImageCache *)sharedInstance {
    static CMNetworkImageCache *sl_imageCache = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sl_imageCache = [[CMNetworkImageCache alloc] init];

        NSOperationQueue *queue = [NSOperationQueue new];
        [queue setMaxConcurrentOperationCount:1];
        
        // 内存警告时清除内存缓存
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:queue usingBlock:^(NSNotification * __unused notification) {
            [sl_imageCache removeAllObjects];
        }];
        
        // 退到后台时清除内存缓存
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:queue usingBlock:^(NSNotification * __unused notification) {
            [sl_imageCache removeAllObjects];
        }];
    });
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    return objc_getAssociatedObject(self, @selector(sharedInstance)) ?: sl_imageCache;
#pragma clang diagnostic pop
}

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request {
    return [self cachedImageForRequest:request ignoreURLParameter:YES];
}

- (void)setCacheImage:(UIImage *)image forRequest:(NSURLRequest *)request {
    [self setCacheImage:image forRequest:request ignoreURLParameter:YES];
}

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request ignoreURLParameter:(BOOL)ignoreURLParameter {
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        default:
            break;
    }
    
    return [self objectForKey:CMNetworkImageCacheKeyFromURLRequest(request, ignoreURLParameter)];
}

- (void)setCacheImage:(UIImage *)image forRequest:(NSURLRequest *)request ignoreURLParameter:(BOOL)ignoreParameter {
    if (image && request) {
        [self setObject:image forKey:CMNetworkImageCacheKeyFromURLRequest(request, ignoreParameter)];
    }
}


@end
