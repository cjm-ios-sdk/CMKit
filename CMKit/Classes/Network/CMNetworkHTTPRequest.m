//
//  CMNetworkHTTPRequest.m
//  Pods
//
//  Created by chenjm on 2016/12/6.
//
//

#import "CMNetworkHTTPRequest.h"
#import "NSString+CMNetworkURLParam.h"
#import "NSURLSessionTask+CMNetworkConfiguration.h"
#import "NSURLSessionTask+CMNetworkData.h"
#import "CMNetworkConfiguration.h"
#import <pthread.h>

@interface CMNetworkHTTPRequest ()<NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, assign) pthread_mutex_t dataLock;

@end


@implementation CMNetworkHTTPRequest

+ (CMNetworkHTTPRequest *)standardRequest {
    static CMNetworkHTTPRequest *request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[CMNetworkHTTPRequest alloc] init];
    });
    
    return request;
}

+ (CMNetworkHTTPRequest *)createObject {
    return [[CMNetworkHTTPRequest alloc] init];
}

+ (void)load {
    [[NSURLCache sharedURLCache] setDiskCapacity:1024 * 1024 * 500]; // 100M
    [[NSURLCache sharedURLCache] setMemoryCapacity:1024 * 1024 * 10]; // 10M
}

- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_dataLock, NULL);
        
        NSOperationQueue *callbackQueue = [NSOperationQueue new];
        callbackQueue.maxConcurrentOperationCount = 1;
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:callbackQueue];
    }
    
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_dataLock);
}

#pragma mark - 外部接口

- (void)invalidate {
    [_session invalidateAndCancel];
    _session = nil;
}

- (BOOL)canHandleRequest:(NSURLRequest *)request {
    static NSSet<NSString *> *schemes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        schemes = [[NSSet alloc] initWithObjects:@"http", @"https", nil];
    });
    return [schemes containsObject:request.URL.scheme.lowercaseString];
}

- (NSURLSessionTask *)getWithURLString:(NSString *)urlString
                                 param:(NSDictionary *)param
                            completion:(CMNetworkCompletionBlock)completion {
    
    CMNetworkHTTPParam *httpParam = [[CMNetworkHTTPParam alloc] init];
    httpParam.urlString = urlString;
    httpParam.httpMethod = CMNetworkGET;
    
    CMNetworkConfiguration *configuration = [[CMNetworkConfiguration alloc] init];
    
    return [self fecthWithParam:httpParam
                  configuration:configuration
                       response:nil
                       progress:nil
                     completion:completion];
}

- (NSURLSessionTask *)getWithRequest:(NSURLRequest *)request
                            response:(CMNetworkResponseBlock)response
                            progress:(CMNetworkProgressBlock)progress
                          completion:(CMNetworkCompletionBlock)completion {
    CMNetworkHTTPParam *httpParam = [[CMNetworkHTTPParam alloc] init];
    httpParam.request = request;
    httpParam.httpMethod = CMNetworkGET;
    
    CMNetworkConfiguration *configuration = [[CMNetworkConfiguration alloc] init];
    
    return [self fecthWithParam:httpParam
                  configuration:configuration
                       response:response
                       progress:progress
                     completion:completion];
}

- (NSURLSessionTask *)getWithRequest:(NSURLRequest *)request
                            response:(CMNetworkResponseBlock)response
                            responseProgress:(CMNetworkResponseProgressBlock)responseProgress
                          completion:(CMNetworkCompletionBlock)completion {
    CMNetworkHTTPParam *httpParam = [[CMNetworkHTTPParam alloc] init];
    httpParam.request = request;
    httpParam.httpMethod = CMNetworkGET;
    
    CMNetworkConfiguration *configuration = [[CMNetworkConfiguration alloc] init];
    
    return [self fecthWithParam:httpParam
                  configuration:configuration
                       response:response
                       progress:nil
                       responseProgress:responseProgress
                     completion:completion];
}

- (NSURLSessionTask *)postWithURLString:(NSString *)urlString
                                  param:(NSDictionary *)param
                             completion:(CMNetworkCompletionBlock)completion {
    
    CMNetworkHTTPParam *httpParam = [[CMNetworkHTTPParam alloc] init];
    httpParam.urlString = urlString;
    httpParam.httpMethod = CMNetworkPOST;
    
    CMNetworkConfiguration *configuration = [[CMNetworkConfiguration alloc] init];
    
    return [self fecthWithParam:httpParam
                  configuration:configuration
                       response:nil
                       progress:nil
                     completion:completion];
}

- (NSURLSessionTask *)postWithRequest:(NSURLRequest *)request
                             response:(CMNetworkResponseBlock)response
                             progress:(CMNetworkProgressBlock)progress
                           completion:(CMNetworkCompletionBlock)completion {
    CMNetworkHTTPParam *httpParam = [[CMNetworkHTTPParam alloc] init];
    httpParam.request = request;
    httpParam.httpMethod = CMNetworkPOST;
    
    CMNetworkConfiguration *configuration = [[CMNetworkConfiguration alloc] init];
    
    return [self fecthWithParam:httpParam
                  configuration:configuration
                       response:response
                       progress:progress
                     completion:completion];
}

- (NSURLSessionTask *)fecthWithParam:(CMNetworkHTTPParam *)param
                       configuration:(CMNetworkConfiguration *)configuration
                          completion:(CMNetworkCompletionBlock)completion {
    
    return [self fecthWithParam:param
                  configuration:configuration
                       response:nil
                       progress:nil
                     completion:completion];
}

- (NSURLSessionTask *)fecthWithParam:(CMNetworkHTTPParam *)param
                       configuration:(CMNetworkConfiguration *)configuration
                            response:(CMNetworkResponseBlock)response
                            progress:(CMNetworkProgressBlock)progress
                          completion:(CMNetworkCompletionBlock)completion {
    
    return [self fecthWithParam:param
                  configuration:configuration
                       response:response
                       progress:progress
                       responseProgress:nil
                     completion:completion];
}

- (NSURLSessionTask *)fecthWithParam:(CMNetworkHTTPParam *)param
                       configuration:(CMNetworkConfiguration *)configuration
                            response:(CMNetworkResponseBlock)response
                            progress:(CMNetworkProgressBlock)progress
                            responseProgress:(CMNetworkResponseProgressBlock)responseProgress
                          completion:(CMNetworkCompletionBlock)completion {

    CMNetworkConfiguration *networkConfiguration = configuration;
    
    if (!networkConfiguration) {
        networkConfiguration = [[CMNetworkConfiguration alloc] init];
    }

    __block NSURLSessionDataTask *dataTask = nil;
    
    // 同步操作数据
    NSMutableURLRequest *mutableRequest = param.mutableRequest;;
    mutableRequest.timeoutInterval = networkConfiguration.timeoutInterval;
    mutableRequest.cachePolicy = networkConfiguration.cachePolicy;

    BOOL isShowNetworkActivity = networkConfiguration.isShowNetworkActivity;
    if (isShowNetworkActivity) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:isShowNetworkActivity];
        });
    }
    
    pthread_mutex_lock(&_dataLock);
    dataTask = [_session dataTaskWithRequest:mutableRequest];
    pthread_mutex_unlock(&_dataLock);
    
    if (dataTask) {
        dataTask.CMNetwork_configuration = networkConfiguration;
        dataTask.CMNetwork_completionBlock = completion;
        dataTask.CMNetwork_responseBlock = response;
        dataTask.CMNetwork_progressBlock = progress;
        dataTask.CMNetwork_responseProgressBlock = responseProgress;
        [dataTask resume];
    }
    
    return dataTask;
}


#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)task
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    long long contentLength = MAX(response.expectedContentLength, 0);
    
    pthread_mutex_lock(&_dataLock);
    task.CMNetwork_data = [[NSMutableData alloc] initWithCapacity:contentLength];
    pthread_mutex_unlock(&_dataLock);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (task.CMNetwork_responseBlock) {
            task.CMNetwork_responseBlock(response);
        }
    });

    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)task
    didReceiveData:(NSData *)data {
	
    pthread_mutex_lock(&_dataLock);
    
    if (!task.CMNetwork_data) {
        task.CMNetwork_data = [[NSMutableData alloc] init];
    }
    if (data) {
        [task.CMNetwork_data appendData:data];
    }
    
    long long currentLength = task.CMNetwork_data.length;
    long long contentLength = MAX(currentLength, MAX(task.response.expectedContentLength, 0));
    
    pthread_mutex_unlock(&_dataLock);
    
    if (task.CMNetwork_progressBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            task.CMNetwork_progressBlock(currentLength, contentLength);
        });
    }
    
    if (task.CMNetwork_responseProgressBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            task.CMNetwork_responseProgressBlock(task.response, currentLength, contentLength);
        });
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    [_session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {

        NSMutableArray *allTasks = [NSMutableArray array];
        if (dataTasks && dataTasks.count > 0) {
            [allTasks addObjectsFromArray:dataTasks];
        }
        
        if (uploadTasks && uploadTasks.count > 0) {
            [allTasks addObjectsFromArray:uploadTasks];
        }
        
        if (downloadTasks && downloadTasks.count > 0) {
            [allTasks addObjectsFromArray:downloadTasks];
        }
        
        if (allTasks && allTasks.count > 0) {
            for (NSURLSessionTask *aTask in allTasks) {
                if (aTask.CMNetwork_configuration.isShowNetworkActivity) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                    });
                    
                    break;
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
        }
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (task.CMNetwork_completionBlock) {
            task.CMNetwork_completionBlock(task.response, task.CMNetwork_data, error);
        }
    });
}

@end
