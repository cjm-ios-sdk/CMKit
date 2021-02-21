//
//  NSString+CMNetworkingURLParam.m
//  Pods
//
//  Created by chenjm on 2016/12/8.
//
//

#import "NSString+CMNetworkURLParam.h"

@implementation NSString (CMNetworkURLParam)

- (NSString *)CMNetwork_urlParam:(NSDictionary *)param {
    if (!param) {
        return self;
    }
    
    NSParameterAssert([param isKindOfClass:[NSDictionary class]]);
    
    if (![param isKindOfClass:[NSDictionary class]]) {
        return self;
    }
    
    NSString *string = [self copy];
    
    @try {
        NSArray *keys = param.allKeys;
        if (keys.count > 0) {
            // 若没有?，则加?
            if (![string containsString:@"?"]) {
                string = [string stringByAppendingString:@"?"];
            } else {
                // 若?和&都不是在最后面，则需要加&
                if (![string hasSuffix:@"?"] && ![string hasSuffix:@"&"]){
                    string = [string stringByAppendingString:@"&"];
                }
            }
        }
        
        for (NSInteger i = 0; i < keys.count; i++) {
            NSString *key = keys[i];
            NSString *value = param[key];
            if ([value isKindOfClass:[NSString class]]) {
                string = [NSString stringWithFormat:@"%@%@=%@&", string, key, [value CMNetwork_urlEncode]];
            } else {
                string = [NSString stringWithFormat:@"%@%@=%@&", string, key, value];
            }
        }
        
        if ([string hasSuffix:@"&"]) {
            string = [string substringToIndex:string.length - 1];
        }
    } @catch (NSException *exception) {
        return self;
    }
    
    return string;
}

+ (NSString *)CMNetworking_queryStringFromParam:(NSDictionary *)param {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    NSArray *allKeys = param.allKeys;
    for (NSString *key in allKeys) {
        NSString *value = param[key];
        if ([value isKindOfClass:[NSString class]]) {
            [mutablePairs addObject:[NSString stringWithFormat:@"%@=%@", key, [value CMNetwork_urlEncode]]];
        } else {
            [mutablePairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
    }
    
    return [mutablePairs componentsJoinedByString:@"&"];
}


- (NSString *)CMNetwork_urlEncode {
    NSString *urlEncode = @"";
    urlEncode = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)self, nil, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return urlEncode;
}



@end
