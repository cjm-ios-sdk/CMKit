//
//  UIImage+CMImageResize.h
//  CMImageCategory
//
//  Created by chenjm on 2020/4/29.
//

#import <UIKit/UIKit.h>

@interface UIImage (CMImageResize)

/**
 * @brief 调整图片
 * @param scale 缩放比例
 * @return 返回 image，image.scale = 1, image.imageOrientation = UIImageOrientationUp
 */
- (UIImage *_Nullable)cjmi_resizeImageWithScale:(CGFloat)scale;

/**
 * @brief 调整图片大小，如果图片像素的宽大于maxSize.width或者高大于maxSize.height。
 * @param maxSize 图片的像素的最大值
 * @return 返回 image，image.scale = 1, image.imageOrientation = UIImageOrientationUp
 */
- (UIImage *_Nullable)cjmi_resizeImageIfPixelSizeGreaterThan:(CGSize)maxSize;

@end
