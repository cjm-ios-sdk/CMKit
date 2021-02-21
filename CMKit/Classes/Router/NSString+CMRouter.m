//
//  NSString+CMRouter.m
//  CMRouter
//
//  Created by chenjm on 2020/4/10.
//  Copyright © 2020年 chenjm. All rights reserved.
//

#import "NSString+CMRouter.h"

@implementation NSString (CMRouter)

/**
 * @brief 是否是http或者https
 */
- (BOOL)cm_isHttpURLString {
    return [self hasPrefix:@"http://"] || [self hasPrefix:@"https://"];
}

/**
 * @brief 获取url中的scheme
 */
- (NSString *)cm_scheme {
    NSArray *strs = [self componentsSeparatedByString:@"://"];
    return strs.firstObject;
}

/**
 * @brief 获取url中的path
 */
- (NSString *)cm_path {
    NSArray *strs = [self componentsSeparatedByString:@"?"];
    NSString *firstStr = strs.firstObject;
    NSArray *components = [firstStr componentsSeparatedByString:@"://"];
    return components.lastObject;
}

/**
 * @brief 获取url中的参数
 */
- (NSDictionary *)cm_paramters {
    NSArray *strs = [self componentsSeparatedByString:@"?"];
    if (strs.count != 2) {
        return nil;
    }
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    NSString *paramterStr = [strs lastObject];
    for (NSString *paramStr in [paramterStr componentsSeparatedByString:@"&"]) {
        NSArray *elts = [paramStr componentsSeparatedByString:@"="];
        if([elts count] != 2) {
            continue;
        }
        
        NSString *valueStr = [elts lastObject];
        valueStr = [valueStr cm_urlDecode];
        
        NSString *keyStr = [elts firstObject];
        keyStr = [keyStr cm_urlDecode];
        
        [mParams setObject:valueStr forKey:keyStr];
    }
    return mParams;
}


#pragma mark - 转码，转化参数

- (NSString *)cm_urlEncode {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                 (CFStringRef)self,
                                                                                 nil,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}

- (NSString *)cm_urlDecode {
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (CFStringRef)self,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8);
    result = [result stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return result;
}


@end
