//
//  UIImage+CMImageTintColor.h
//  CMImageCategory
//
//  Created by chenjm on 2020/4/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CMImageTintColor)

/**
 * @brief 对原图片进行染色，有alpha通道
 * @param color 颜色
 * @return 返回一张染色的图片
 */
- (UIImage *_Nullable)cjmi_tintImageWithColor:(UIColor *_Nullable)color;

/**
 * @brief 生成一张纯色的图片，有alpha通道
 * @param color 颜色
 * @param size 图片的大小
 * @param scale 图片的缩放值
 * @return 返回一张纯色的图片，图片的实际大小：size * scale
 */
+ (UIImage *_Nullable)cjmi_tintImageWithColor:(UIColor *_Nullable)color
                                         size:(CGSize)size
                                        scale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
