//
//  UIImage+CMImageResize.m
//  CMImageCategory
//
//  Created by chenjm on 2020/4/29.
//

#import "UIImage+CMImageResize.h"

@implementation UIImage (CMImageResize)

/**
 * @brief 调整图片
 * @param scale 缩放比例
 * @return 返回 image，image.scale = 1, image.imageOrientation = UIImageOrientationUp
 */
- (UIImage *)cjmi_resizeImageWithScale:(CGFloat)scale {
    NSUInteger fixelWidth = (NSUInteger)self.size.width * self.scale * scale;
    NSUInteger fixelHeight = (NSUInteger)self.size.height * self.scale * scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(fixelWidth, fixelHeight), NO, 1);
    [self drawInRect:CGRectMake(0, 0, fixelWidth, fixelHeight)];
    UIImage *retImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImg;
}

/**
 * @brief 调整图片大小，如果图片像素的宽大于maxSize.width或者高大于maxSize.height。
 * @param maxSize 图片的像素的最大值
 * @return 返回 image，image.scale = 1, image.imageOrientation = UIImageOrientationUp
 */
- (UIImage *)cjmi_resizeImageIfPixelSizeGreaterThan:(CGSize)maxSize {
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGFloat scale = self.scale;
    
    // 如果maxSize 的宽或高为0，则返回nil
    if (maxSize.width < CGFLOAT_MIN || maxSize.height < CGFLOAT_MIN) {
        return nil;
    }
    
    // 如果原图的size都小于或等于maxSize，则直接返回self
    if (width * scale < maxSize.width + CGFLOAT_MIN && height * scale < maxSize.height + CGFLOAT_MIN) {
        return self;
    }
    
    CGFloat widthScale = maxSize.width / width * scale;
    CGFloat heightScale = maxSize.height / height * scale;
    CGFloat resultScale = MIN(widthScale, heightScale);
    
    NSUInteger fixelWidth = (NSUInteger)width * scale * resultScale;
    NSUInteger fixelHeight = (NSUInteger)height * scale * resultScale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(fixelWidth, fixelHeight), NO, 1);
    [self drawInRect:CGRectMake(0, 0, fixelWidth, fixelHeight)];
    UIImage *retImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImg;
}

@end
