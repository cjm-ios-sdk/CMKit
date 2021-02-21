//
//  CMNetworkGIFImageDecoder.m
//  Pods
//
//  Created by chenjm on 2016/12/21.
//
//

#import "CMNetworkGIFImageDecoder.h"
#import "UIImage+CMNetwork.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>

@implementation CMNetworkGIFImageDecoder {
    NSLock *_imageLock;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageLock = [[NSLock alloc] init];
    }
    return self;
}

- (BOOL)canDecodeImageData:(NSData *)imageData {
    char header[7] = {};
    [imageData getBytes:header length:6];
    
    return !strcmp(header, "GIF87a") || !strcmp(header, "GIF89a");
}

- (CMNetworkImageLoaderCancellationBlock)asyncDecodeImageData:(NSData *)imageData
                                                    size:(CGSize)size
                                                   scale:(CGFloat)scale
                                              resizeMode:(UIViewContentMode)resizeMode
                                       completionHandler:(CMNetworkImageLoaderCompletionBlock)completionHandler {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *decodeImage = [self decodeImageData:imageData size:size scale:scale resizeMode:resizeMode];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil, decodeImage);
        });
    });
    return ^{};
}

- (CMNetworkImageLoaderCancellationBlock)decodeImageData:(NSData *)imageData
                                                    size:(CGSize)size
                                                   scale:(CGFloat)scale
                                              resizeMode:(UIViewContentMode)resizeMode
                                       completionHandler:(CMNetworkImageLoaderCompletionBlock)completionHandler {
    
    UIImage *decodeImage = [self decodeImageData:imageData size:size scale:scale resizeMode:resizeMode];
    completionHandler(nil, decodeImage);
    return ^{};
}

- (UIImage *)decodeImageData:(NSData *)imageData
                        size:(CGSize)size
                       scale:(CGFloat)scale
                  resizeMode:(UIViewContentMode)resizeMode{
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
    NSDictionary<NSString *, id> *properties = (__bridge_transfer NSDictionary *)CGImageSourceCopyProperties(imageSource, NULL);
    NSUInteger loopCount = [properties[(id)kCGImagePropertyGIFDictionary][(id)kCGImagePropertyGIFLoopCount] unsignedIntegerValue];
    
    UIImage *image = nil;
    size_t imageCount = CGImageSourceGetCount(imageSource);
    if (imageCount > 1) {
        
        NSTimeInterval duration = 0;
        NSMutableArray<NSNumber *> *delays = [NSMutableArray arrayWithCapacity:imageCount];
        NSMutableArray<id /* CGIMageRef */> *images = [NSMutableArray arrayWithCapacity:imageCount];
        for (size_t i = 0; i < imageCount; i++) {
            
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
            if (!image) {
                image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
            }
            
            NSDictionary<NSString *, id> *frameProperties = (__bridge_transfer NSDictionary *)CGImageSourceCopyPropertiesAtIndex(imageSource, i, NULL);
            NSDictionary<NSString *, id> *frameGIFProperties = frameProperties[(id)kCGImagePropertyGIFDictionary];
            
            const NSTimeInterval kDelayTimeIntervalDefault = 0.1;
            NSNumber *delayTime = frameGIFProperties[(id)kCGImagePropertyGIFUnclampedDelayTime] ?: frameGIFProperties[(id)kCGImagePropertyGIFDelayTime];
            if (delayTime == nil) {
                if (i == 0) {
                    delayTime = @(kDelayTimeIntervalDefault);
                } else {
                    delayTime = delays[i - 1];
                }
            }
            
            const NSTimeInterval kDelayTimeIntervalMinimum = 0.02;
            if (delayTime.floatValue < (float)kDelayTimeIntervalMinimum - FLT_EPSILON) {
                delayTime = @(kDelayTimeIntervalDefault);
            }
            
            duration += delayTime.doubleValue;
            delays[i] = delayTime;
            images[i] = (__bridge_transfer id)imageRef;
        }
        CFRelease(imageSource);
        
        NSMutableArray<NSNumber *> *keyTimes = [NSMutableArray arrayWithCapacity:delays.count];
        NSTimeInterval runningDuration = 0;
        for (NSNumber *delayNumber in delays) {
            [keyTimes addObject:@(runningDuration / duration)];
            runningDuration += delayNumber.doubleValue;
        }
        
        [keyTimes addObject:@1.0];
        
        // Create animation
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        animation.calculationMode = kCAAnimationDiscrete;
        animation.fillMode = kCAFillModeForwards;//当动画结束后,layer会一直保持着动画最后的状态
        animation.removedOnCompletion = NO;//图层保持显示动画执行后的状态
        animation.repeatCount = loopCount == 0 ? HUGE_VALF : loopCount;
        animation.keyTimes = keyTimes;
        animation.values = images;
        animation.duration = duration;
        image.CMNetworkKeyframeAnimation = animation;
        image.CMNetworkImageData = imageData;
        
    } else {
        [_imageLock lock];
        UIImage *tmpImage = [UIImage imageWithData:imageData];
        [_imageLock unlock];
        
        image = [UIImage imageWithCGImage:tmpImage.CGImage scale:scale orientation:tmpImage.imageOrientation];
    }
    return image;
}


@end
