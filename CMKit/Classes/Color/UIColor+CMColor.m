//
//  UIColor+CMColor.m
//  CMColor
//
//  Created by chenjm on 2020/4/13.
//

#import "UIColor+CMColor.h"

@implementation UIColor (CMColor)

/// 将16进制 rgb 颜色值转换为UIColor
+ (UIColor *)cjmc_colorWithRGBHex:(NSInteger)RGBHex alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((RGBHex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((RGBHex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(RGBHex & 0xFF)) / 255.0 alpha:alpha];
}

/// 将16进制 rgb 颜色值字符串转换为UIColor
+ (UIColor *)cjmc_colorWithRGBHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat red = 0;
    CGFloat blue = 0;
    CGFloat green = 0;
        
    switch ([colorString length]) {
        case 3: //#RGB
            //alpha = 1.0f;
            red = [self cjmc_colorComponentFrom:colorString start:0 length:1];
            green = [self cjmc_colorComponentFrom:colorString start:1 length:1];
            blue = [self cjmc_colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: //#ARGB
            alpha = [self cjmc_colorComponentFrom:colorString start:0 length:1];
            red = [self cjmc_colorComponentFrom:colorString start:1 length:1];
            green = [self cjmc_colorComponentFrom:colorString start:2 length:1];
            blue = [self cjmc_colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: //#RRGGBB
            //alpha = 1.0f;
            red = [self cjmc_colorComponentFrom:colorString start:0 length:2];
            green = [self cjmc_colorComponentFrom:colorString start:2 length:2];
            blue = [self cjmc_colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // AARRGGBB
            alpha = [self cjmc_colorComponentFrom:colorString start:0 length:2];
            red = [self cjmc_colorComponentFrom:colorString start:2 length:2];
            green = [self cjmc_colorComponentFrom:colorString start:4 length:2];
            blue = [self cjmc_colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            NSLog(@"error! cjmc_colorWithRGBHexString:alpha:");
            return nil;
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/// 将UIColor 转化为16进制颜色值字符串。
+ (NSString *)cjmc_rgbHexStringFromUIColor:(UIColor *)color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color  = [UIColor colorWithRed:components[0] green:components[0] blue:components[0] alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    CGFloat r = (CGColorGetComponents(color.CGColor))[0];
    CGFloat g = (CGColorGetComponents(color.CGColor))[1];
    CGFloat b = (CGColorGetComponents(color.CGColor))[2];
    
    return [NSString stringWithFormat:@"#%02x%02x%02x", (int)(r  * 255.0), (int)(g  * 255.0), (int)(b * 255.0)];
}

+ (CGFloat)cjmc_colorComponentFrom:(NSString *)string start:(NSInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@",substring,substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}


@end
