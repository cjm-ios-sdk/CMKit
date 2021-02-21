//
//  UIImage+CMImageShareTintImage.m
//  MRSocialContact
//
//  Created by chenjm on 2019/7/17.
//

#import "UIImage+CMImageShareTintImage.h"

@implementation UIImage (CMImageShareTintImage)

static UIImage *createImage(UIColor *color) {
    CGRect rect = CGRectMake(0.0f, 0.0f, 4.0f, 4.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSMapTable *)mrs_shareImageMapTable {
    static NSMapTable *mapTable = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapTable = [[NSMapTable alloc] init];
    });
    return mapTable;
}

+ (void)cjmi_clearAllShareImage {
    [[self mrs_shareImageMapTable] removeAllObjects];
}

+ (void)cjmi_removeShareImageWithColor:(UIColor *)color {
    if (!color) {
        return;
    }
    
    NSString *key = [self cjmi_shareKeyWithColor:color];
    [[self mrs_shareImageMapTable] removeObjectForKey:key];
}

+ (UIImage *)cjmi_shareImageWithColor:(UIColor *)color {
    if (!color) {
        return nil;
    }
    
    NSString *key = [self cjmi_shareKeyWithColor:color];
    UIImage *cacheImage = [[self mrs_shareImageMapTable] objectForKey:key];
    if (!cacheImage) {
        cacheImage = createImage(color);
        [[self mrs_shareImageMapTable] setObject:cacheImage forKey:key];
    }
    
    return cacheImage;
}

+ (NSString *)cjmi_shareKeyWithColor:(UIColor *)color {
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    int r = red * 255;
    int g = green * 255;
    int b = blue * 255;
    int a =  alpha * 255;
    
    NSString *key = [NSString stringWithFormat:@"%d_%d_%d_%d", r, g, b, a];
    return key;
}

@end
