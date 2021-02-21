//
//  CMNetworkFileRequest.m
//  Pods
//
//  Created by chenjm on 2016/11/29.
//
//

#import "CMNetworkFileRequest.h"
#import <MobileCoreServices/MobileCoreServices.h>

NSString *__nullable  SLBundlePathForURL(NSURL *__nullable URL)
{
    if (!URL.fileURL) {
        // Not a file path
        return nil;
    }
    NSString *path = URL.path;
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    if (![path hasPrefix:bundlePath]) {
        // Not a bundle-relative file
        return nil;
    }
    path = [path substringFromIndex:bundlePath.length];
    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    return path;
}

BOOL SLIsXCAssetURL(NSURL *__nullable imageURL)
{
    NSString *name = SLBundlePathForURL(imageURL);
    if (name.pathComponents.count != 1) {
        // URL is invalid, or is a file path, not an XCAsset identifier
        return NO;
    }
    NSString *extension = [name pathExtension];
    if (extension.length && ![extension isEqualToString:@"png"]) {
        // Not a png
        return NO;
    }
    extension = extension.length ? nil : @"png";
    if ([[NSBundle mainBundle] pathForResource:name ofType:extension]) {
        // File actually exists in bundle, so is not an XCAsset
        return NO;
    }
    return YES;
}

@implementation CMNetworkFileRequest {
    NSOperationQueue *_fileQueue;
}



+ (CMNetworkFileRequest *)standardRequest {
    static CMNetworkFileRequest *fileRequest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       fileRequest = [[CMNetworkFileRequest alloc] init];
    });
    
    return fileRequest;
}

+ (CMNetworkFileRequest *)createObject {
    return [[CMNetworkFileRequest alloc] init];
}

- (void)invalidate {
    [_fileQueue cancelAllOperations];
    _fileQueue = nil;
}

- (BOOL)canHandleRequest:(NSURLRequest *)request {
    static NSSet<NSString *> *schemes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        schemes = [[NSSet alloc] initWithObjects:@"file", nil];
    });
    return [schemes containsObject:request.URL.scheme.lowercaseString];
}

- (NSOperation *)fecthWithRequest:(NSURLRequest *)request
                       completion:(CMNetworkCompletionBlock)completion {
    // Lazy setup
    if (!_fileQueue) {
        _fileQueue = [NSOperationQueue new];
        _fileQueue.maxConcurrentOperationCount = 4;
    }
    
    __weak __block NSBlockOperation *weakOp = nil;
    __block NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        
        // Get content length
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager new];
        NSDictionary<NSString *, id> *fileAttributes = [fileManager attributesOfItemAtPath:request.URL.path error:&error];
        if (error) {
            if (completion) {
                completion(nil, nil, error);
            }
            
            return;
        }
        
        // Get mime type
        NSString *fileExtension = [request.URL pathExtension];
        NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(
                                                                                            kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtension, NULL);
        NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(
                                                                                              (__bridge CFStringRef)UTI, kUTTagClassMIMEType);
        
        // Send response
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:request.URL
                                                            MIMEType:contentType
                                               expectedContentLength:[fileAttributes[NSFileSize] ?: @-1 integerValue]
                                                    textEncodingName:nil];
        
        // Load data
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
    [_fileQueue addOperation:op];
    return op;
}

- (void)cancelRequest:(NSOperation *)op {
    [op cancel];
}


@end
