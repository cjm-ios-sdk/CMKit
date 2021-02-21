//
//  CMNetworkHTTPParam.h
//  Pods
//
//  http请求参数
//
//  Created by chenjm on 2016/12/8.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CMNetworkHTTPContentType) {
    CMNetworkHTTPContentTypeURLEncode = 0,
    CMNetworkHTTPContentTypeJSON
};

typedef NSString * CMNetworkMethod;

extern const CMNetworkMethod CMNetworkPOST;
extern const CMNetworkMethod CMNetworkGET;
extern const CMNetworkMethod CMNetworkPUT;
extern const CMNetworkMethod CMNetworkDELETE;

@interface CMNetworkHTTPParam : NSObject
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) CMNetworkMethod httpMethod;
@property (nonatomic, strong)  id allParam;
//@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, strong, readonly) NSMutableURLRequest *mutableRequest;
@property (nonatomic, strong) NSURLRequest *request;
@property (atomic, strong) NSMutableDictionary *mutableHTTPRequestHeaders;
@property (nonatomic, assign) CMNetworkHTTPContentType contentType;

- (NSMutableURLRequest *)mutableRequestWithContentType:(CMNetworkHTTPContentType)contentType;

@end
