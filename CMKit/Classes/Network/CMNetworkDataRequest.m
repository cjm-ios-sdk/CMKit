//
//  CMNetworkDataRequest.m
//  Pods
//
//  Created by chenjm on 2016/11/29.
//
//

#import "CMNetworkDataRequest.h"

@implementation CMNetworkDataRequest {
    NSOperationQueue *_queue;
}


+ (CMNetworkDataRequest *)standardRequest {
    static CMNetworkDataRequest *dataRequest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataRequest = [[CMNetworkDataRequest alloc] init];
    });
    
    return dataRequest;
}

+ (CMNetworkDataRequest *)createObject {
    return [[CMNetworkDataRequest alloc] init];
}

- (void)invalidate {
    [_queue cancelAllOperations];
    _queue = nil;
}

- (BOOL)canHandleRequest:(NSURLRequest *)request {
    static NSSet<NSString *> *schemes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        schemes = [[NSSet alloc] initWithObjects:@"data", nil];
    });
    return [schemes containsObject:request.URL.scheme.lowercaseString];
}

- (NSOperation *)fecthWithRequest:(NSURLRequest *)request
                     completion:(CMNetworkCompletionBlock)completion {
    // Lazy setup
    if (!_queue) {
        _queue = [NSOperationQueue new];
        _queue.maxConcurrentOperationCount = 2;
    }
    
    __weak __block NSBlockOperation *weakOp;
    __block NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        
        // Get mime type
        NSRange firstSemicolon = [request.URL.resourceSpecifier rangeOfString:@";"];
        NSString *mimeType = firstSemicolon.length ? [request.URL.resourceSpecifier substringToIndex:firstSemicolon.location] : nil;
        
        // Send response
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:request.URL
                                                            MIMEType:mimeType
                                               expectedContentLength:-1
                                                    textEncodingName:nil];
        
        // Load data
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:request.URL
                                             options:NSDataReadingMappedIfSafe
                                               error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(response, data, error);
            }
        });
    }];
    
    weakOp = op;
    [_queue addOperation:op];
    return op;
}

- (void)cancelRequest:(NSOperation *)op {
    [op cancel];
}

@end
