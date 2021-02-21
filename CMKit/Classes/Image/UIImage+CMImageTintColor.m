//
//  UIImage+CMImageTintColor.m
//  CMImageCategory
//
//  Created by chenjm on 2020/4/29.
//

#import "UIImage+CMImageTintColor.h"

@implementation UIImage (CMImageTintColor)

- (UIImage *)cjmi_tintImageWithColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [self scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0 , -1.0);
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextDrawImage(context, rect, self.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [color setFill];
    CGContextFillRect(context, rect);
    
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImage;
}

+ (UIImage *)cjmi_tintImageWithColor:(UIColor *)color size:(CGSize)size scale:(CGFloat)scale {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef bmContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(bmContext, [color CGColor]);
    CGContextFillRect(bmContext, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
