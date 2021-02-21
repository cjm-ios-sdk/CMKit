//
//  SLConvert.m
//  Pods
//
//  Created by chenjm on 2016/11/30.
//
//

#import "CMConvert.h"

@implementation SLConvert

+ (NSURL *)NSURL:(NSString *)json {

    if (json && [json isKindOfClass:[NSString class]]) {
        NSString *path = json;
        if (!path) {
            return nil;
        }
        
        @try { // NSURL has a history of crashing with bad input, so let's be safe
            
            NSURL *URL = [NSURL URLWithString:path];
            if (URL.scheme) { // Was a well-formed absolute URL
                return URL;
            }
            
            // Check if it has a scheme
            if ([path rangeOfString:@":"].location != NSNotFound) {
                path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                URL = [NSURL URLWithString:path];
                if (URL) {
                    return URL;
                }
            }
            
            // Assume that it's a local path
            path = path.stringByRemovingPercentEncoding;
            if ([path hasPrefix:@"~"]) {
                // Path is inside user directory
                path = path.stringByExpandingTildeInPath;
            } else if (!path.absolutePath) {
                // Assume it's a resource path
                path = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:path];
            }
            if (!(URL = [NSURL fileURLWithPath:path])) {
                NSLog(json, @"a valid URL");
            }
            return URL;
        } @catch (__unused NSException *e) {
            NSLog(json, @"a valid URL");
            return nil;
        }
    }
}

+ (NSURLRequest *)NSURLRequest:(NSString *)json {
    if ([json isKindOfClass:[NSString class]]) {
        NSURL *URL = [self NSURL:json];
        return URL ? [NSURLRequest requestWithURL:URL] : nil;
    }

    return nil;
}




@end
