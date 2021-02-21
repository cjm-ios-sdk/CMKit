//
//  CMRouterRequest.m
//  CMRouter
//
//  Created by chenjm on 2020/4/10.
//  Copyright © 2020年 chenjm. All rights reserved.
//

#import "CMRouterRequest.h"
#import "NSString+CMRouter.h"

@implementation CMRouterRequest

- (instancetype)initWithUrlString:(NSString *)urlString paramters:(NSDictionary *)paramters {
    self = [super init];
    if (self) {
        self.urlString = urlString;
        self.paramters = paramters;
    }
    return self;
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = [urlString copy];
    [self parserWithUrlString:urlString];
    [self mergeUrlParamters:_urlParamters paramters:_paramters];
}

- (void)setParamters:(NSDictionary *)paramters {
    _paramters = [paramters copy];
    [self mergeUrlParamters:_urlParamters paramters:_paramters];
}

- (void)mergeUrlParamters:(NSDictionary *)urlParamters paramters:(NSDictionary *)paramters {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:urlParamters.count + paramters.count];
    if (urlParamters) {
        [dict addEntriesFromDictionary:urlParamters];
    }
    
    if (paramters) {
        [dict addEntriesFromDictionary:paramters];
    }
    _allParamters = dict;
}

- (void)parserWithUrlString:(NSString *)urlString {
    if (!urlString) {
        return;
    }
    
    _isHttp = [urlString cm_isHttpURLString];
    _urlScheme = [urlString cm_scheme];
    _urlPath = [urlString cm_path];
    _urlParamters = [urlString cm_paramters];
}


@end
