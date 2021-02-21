//
//  CMNetworkUtil.m
//  Pods
//
//  Created by chenjm on 2016/11/30.
//
//

#import "CMNetworkUtil.h"
#import <zlib.h>
#import <dlfcn.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <tgmath.h>

BOOL SLIsGzippedData(NSData *__nullable); // exposed for unit testing purposes
BOOL SLIsGzippedData(NSData *__nullable data) {
    UInt8 *bytes = (UInt8 *)data.bytes;
    return (data.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b);
}

//NSData *__nullable SLGzipData(NSData *__nullable input, float level) {
//    if (input.length == 0 || SLIsGzippedData(input)) {
//        return input;
//    }
//    
//    void *libz = dlopen("/usr/lib/libz.dylib", RTLD_LAZY);
//    int (*deflateInit2_)(z_streamp, int, int, int, int, int, const char *, int) = dlsym(libz, "deflateInit2_");
//    int (*deflate)(z_streamp, int) = dlsym(libz, "deflate");
//    int (*deflateEnd)(z_streamp) = dlsym(libz, "deflateEnd");
//    
//    z_stream stream;
//    stream.zalloc = Z_NULL;
//    stream.zfree = Z_NULL;
//    stream.opaque = Z_NULL;
//    stream.avail_in = (uint)input.length;
//    stream.next_in = (Bytef *)input.bytes;
//    stream.total_out = 0;
//    stream.avail_out = 0;
//    
//    static const NSUInteger CMNetworkGZipChunkSize = 16384;
//    
//    NSMutableData *output = nil;
//    int compression = (level < 0.0f)? Z_DEFAULT_COMPRESSION: (int)(roundf(level * 9));
//    if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK) {
//        output = [NSMutableData dataWithLength:CMNetworkGZipChunkSize];
//        while (stream.avail_out == 0) {
//            if (stream.total_out >= output.length) {
//                output.length += CMNetworkGZipChunkSize;
//            }
//            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
//            stream.avail_out = (uInt)(output.length - stream.total_out);
//            deflate(&stream, Z_FINISH);
//        }
//        deflateEnd(&stream);
//        output.length = stream.total_out;
//    }
//    
//    dlclose(libz);
//    
//    return output;
//}

CGFloat CMNetworkScreenScale()
{
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([NSThread isMainThread]) {
            scale = [UIScreen mainScreen].scale;
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                scale = [UIScreen mainScreen].scale;
            });
        }
    });
    
    return scale;
}

static CGFloat CMNetworkCeilValue(CGFloat value, CGFloat scale)
{
    return ceil(value * scale) / scale;
}

static CGSize CMNetworkCeilSize(CGSize size, CGFloat scale)
{
    return (CGSize){
        CMNetworkCeilValue(size.width, scale),
        CMNetworkCeilValue(size.height, scale)
    };
}

static CGFloat CMNetworkFloorValue(CGFloat value, CGFloat scale)
{
    return floor(value * scale) / scale;
}

CGRect CMNetworkTargetRect(CGSize sourceSize, CGSize destSize,
                     CGFloat destScale, UIViewContentMode resizeMode)
{
    if (CGSizeEqualToSize(destSize, CGSizeZero)) {
        // Assume we require the largest size available
        return (CGRect){CGPointZero, sourceSize};
    }
    
    CGFloat aspect = sourceSize.width / sourceSize.height;
    // If only one dimension in destSize is non-zero (for example, an Image
    // with `flex: 1` whose height is indeterminate), calculate the unknown
    // dimension based on the aspect ratio of sourceSize
    if (destSize.width == 0) {
        destSize.width = destSize.height * aspect;
    }
    if (destSize.height == 0) {
        destSize.height = destSize.width / aspect;
    }
    
    // Calculate target aspect ratio if needed (don't bother if resizeMode == stretch)
    CGFloat targetAspect = 0.0;
    if (resizeMode != UIViewContentModeScaleToFill) {
        targetAspect = destSize.width / destSize.height;
        if (aspect == targetAspect) {
            resizeMode = UIViewContentModeScaleToFill;
        }
    }
    
    switch (resizeMode) {
        case UIViewContentModeScaleToFill:
            
            return (CGRect){CGPointZero, CMNetworkCeilSize(destSize, destScale)};
            
        case UIViewContentModeScaleAspectFit:
            
            if (targetAspect <= aspect) { // target is taller than content
                
                sourceSize.width = destSize.width = destSize.width;
                sourceSize.height = sourceSize.width / aspect;
                
            } else { // target is wider than content
                
                sourceSize.height = destSize.height = destSize.height;
                sourceSize.width = sourceSize.height * aspect;
            }
            return (CGRect){
                {
                    CMNetworkFloorValue((destSize.width - sourceSize.width) / 2, destScale),
                    CMNetworkFloorValue((destSize.height - sourceSize.height) / 2, destScale),
                },
                CMNetworkCeilSize(sourceSize, destScale)
            };
            
        case UIViewContentModeScaleAspectFill:
            
            if (targetAspect <= aspect) { // target is taller than content
                
                sourceSize.height = destSize.height = destSize.height;
                sourceSize.width = sourceSize.height * aspect;
                destSize.width = destSize.height * targetAspect;
                return (CGRect){
                    {CMNetworkFloorValue((destSize.width - sourceSize.width) / 2, destScale), 0},
                    CMNetworkCeilSize(sourceSize, destScale)
                };
                
            } else { // target is wider than content
                
                sourceSize.width = destSize.width = destSize.width;
                sourceSize.height = sourceSize.width / aspect;
                destSize.height = destSize.width / targetAspect;
                return (CGRect){
                    {0, CMNetworkFloorValue((destSize.height - sourceSize.height) / 2, destScale)},
                    CMNetworkCeilSize(sourceSize, destScale)
                };
            }
    }
    return CGRectZero;
}

CGSize CMNetworkTargetSize(CGSize sourceSize, CGFloat sourceScale,
                     CGSize destSize, CGFloat destScale,
                     UIViewContentMode resizeMode,
                     BOOL allowUpscaling)
{
    switch (resizeMode) {
        case UIViewContentModeScaleToFill:
            
            if (!allowUpscaling) {
                CGFloat scale = sourceScale / destScale;
                destSize.width = MIN(sourceSize.width * scale, destSize.width);
                destSize.height = MIN(sourceSize.height * scale, destSize.height);
            }
            return CMNetworkCeilSize(destSize, destScale);
            
        default: {
            
            // Get target size
            CGSize size = CMNetworkTargetRect(sourceSize, destSize, destScale, resizeMode).size;
            if (!allowUpscaling) {
                // return sourceSize if target size is larger
                if (sourceSize.width * sourceScale < size.width * destScale) {
                    return sourceSize;
                }
            }
            return size;
        }
    }
    
    return CGSizeZero;
}

CGSize CMNetworkSizeInPixels(CGSize pointSize, CGFloat scale)
{
    return (CGSize){
        ceil(pointSize.width * scale),
        ceil(pointSize.height * scale),
    };
}

UIImage *__nullable CMNetworkDecodeImageWithData(NSData *data,
                                           CGSize destSize,
                                           CGFloat destScale,
                                           UIViewContentMode resizeMode)
{
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (!sourceRef) {
        return nil;
    }
    
    // Get original image size
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(sourceRef, 0, NULL);
    if (!imageProperties) {
        CFRelease(sourceRef);
        return nil;
    }
    NSNumber *width = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
    NSNumber *height = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
    CGSize sourceSize = {width.doubleValue, height.doubleValue};
    CFRelease(imageProperties);
    
    if (CGSizeEqualToSize(destSize, CGSizeZero)) {
        destSize = sourceSize;
        if (!destScale) {
            destScale = 1;
        }
    } else if (!destScale) {
        destScale = CMNetworkScreenScale();
    }
    
    if (resizeMode == UIViewContentModeScaleToFill) {
        // Decoder cannot change aspect ratio, so CMNetworkResizeModeStretch is equivalent
        // to CMNetworkResizeModeCover for our purposes
        resizeMode = UIViewContentModeScaleAspectFill;
    }
    
    // Calculate target size
    CGSize targetSize = CMNetworkTargetSize(sourceSize, 1, destSize, destScale, resizeMode, NO);
    CGSize targetPixelSize = CMNetworkSizeInPixels(targetSize, destScale);
    CGFloat maxPixelSize = fmax(fmin(sourceSize.width, targetPixelSize.width),
                                fmin(sourceSize.height, targetPixelSize.height));
    
    NSDictionary<NSString *, NSNumber *> *options = @{
                                                      (id)kCGImageSourceShouldAllowFloat: @YES,
                                                      (id)kCGImageSourceCreateThumbnailWithTransform: @YES,
                                                      (id)kCGImageSourceCreateThumbnailFromImageAlways: @YES,
                                                      (id)kCGImageSourceThumbnailMaxPixelSize: @(maxPixelSize),
                                                      };
    
    // Get thumbnail
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(sourceRef, 0, (__bridge CFDictionaryRef)options);
    CFRelease(sourceRef);
    if (!imageRef) {
        return nil;
    }
    
    // Return image
    UIImage *image = [UIImage imageWithCGImage:imageRef
                                         scale:destScale
                                   orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return image;
}



@implementation CMNetworkUtil
@end
