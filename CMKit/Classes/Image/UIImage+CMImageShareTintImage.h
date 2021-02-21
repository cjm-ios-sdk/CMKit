//
//  UIImage+CMImageShareTintImage.h
//  MRSocialContact
//
//  Created by chenjm on 2019/7/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CMImageShareTintImage)

/**
 * brief 清理缓存的图片
 */
+ (void)cjmi_clearAllShareImage;

/**
 * @brief 清理这个颜色值的图片缓存
 * @param color 颜色
 */
+ (void)cjmi_removeShareImageWithColor:(UIColor *_Nullable)color;

/**
 * @brief 分享这个颜色值的图片，如果没有会新建一个4*4的小图。
 * @param color 颜色
 */
+ (UIImage *_Nullable)cjmi_shareImageWithColor:(UIColor *_Nullable)color;

@end

NS_ASSUME_NONNULL_END
