//
//  SLConvert.h
//  Pods
//
//  Created by chenjm on 2016/11/30.
//
//

#import <Foundation/Foundation.h>

@interface SLConvert : NSObject

+ (NSURL *)NSURL:(NSString *)json;

+ (NSURLRequest *)NSURLRequest:(NSString *)json;

@end
