//
//  CMNetworkHTTPParam.m
//  Pods
//
//  Created by chenjm on 2016/12/8.
//
//

#import "CMNetworkHTTPParam.h"
#import "NSString+CMNetworkURLParam.h"

const CMNetworkMethod CMNetworkPOST = @"POST";
const CMNetworkMethod CMNetworkGET = @"GET";
const CMNetworkMethod CMNetworkPUT = @"PUT";
const CMNetworkMethod CMNetworkDELETE = @"DELETE";

@implementation CMNetworkHTTPParam
@synthesize mutableRequest = _mutableRequest;

- (instancetype)init {
    self = [super init];
    if (self) {
        _mutableHTTPRequestHeaders = [NSMutableDictionary dictionary];
        _mutableRequest = [NSMutableURLRequest new];
        _httpMethod = CMNetworkGET;
        _contentType = CMNetworkHTTPContentTypeURLEncode;
//        _timeoutInterval = 60;
    }
    
    return self;
}

- (CMNetworkMethod)httpMethod {
    if (!_httpMethod || ![_httpMethod isKindOfClass:[NSString class]]) {
        _httpMethod = CMNetworkGET;
    }
    
    return _httpMethod;
}

- (NSMutableURLRequest *)mutableRequest {
    return [self mutableRequestWithContentType:_contentType];
}

- (NSMutableURLRequest *)mutableRequestWithContentType:(CMNetworkHTTPContentType)contentType {
    @synchronized (self) {
        if (_request) {
            return [_request mutableCopy];
        }
        
        _mutableRequest.HTTPMethod = self.httpMethod;
        // _mutableRequest.timeoutInterval = self.timeoutInterval;
        
        
        // 如果httpMethod值有问题，都用get方法
        if ([self.httpMethod isEqualToString:CMNetworkGET]) {
            NSString *urlStr = self.urlString;
            if (_allParam && ([_allParam isKindOfClass:[NSDictionary class]] || [_allParam isKindOfClass:[NSArray class]])) {
                urlStr = [urlStr CMNetwork_urlParam:_allParam];
            }
            
            _mutableRequest.URL = [NSURL URLWithString:urlStr];
            
            return _mutableRequest;
            
        } else {
            
            if (self.urlString && [self.urlString isKindOfClass:[NSString class]]) {
                _mutableRequest.URL = [NSURL URLWithString:self.urlString];
            }
            
            __weak typeof(self) weakSelf = self;
            [self.mutableHTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (![strongSelf.mutableRequest valueForHTTPHeaderField:field]) {
                    [strongSelf.mutableRequest setValue:value forHTTPHeaderField:field];
                }
            }];
            
            if (contentType == CMNetworkHTTPContentTypeURLEncode) {
                
                if (![_mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
                    [_mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                }
                
                if (_allParam && ([_allParam isKindOfClass:[NSDictionary class]] || [_allParam isKindOfClass:[NSArray class]])) {
                    NSString *query = [NSString CMNetworking_queryStringFromParam:_allParam];
                    [_mutableRequest setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
                }
                
                return _mutableRequest;
            } else if (contentType == CMNetworkHTTPContentTypeJSON) {
                
                if (![_mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
                    [_mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                }
                
                if (_allParam && ([_allParam isKindOfClass:[NSDictionary class]] || [_allParam isKindOfClass:[NSArray class]])) {
                    NSError *error = nil;
                    [_mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:_allParam options:0 error:&error]];
                    if (error) {
                        NSLog(@"error=%@", error.description);
                    }
                }
            }
            
            return _mutableRequest;
        }
        
        return _mutableRequest;   
    }
}

@end
