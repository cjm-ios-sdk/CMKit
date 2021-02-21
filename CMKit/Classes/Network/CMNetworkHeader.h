//
//  CMNetwork.h
//  Pods
//
//  公用头文件
//
//  Created by chenjm on 2016/12/12.
//
//

#ifndef CMNetworkHeader_h
#define CMNetworkHeader_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^CMNetworkResponseBlock)(NSURLResponse * _Nullable response);
typedef void (^CMNetworkProgressBlock)(int64_t progress, int64_t total);
typedef void (^CMNetworkResponseProgressBlock)(NSURLResponse * _Nullable response,int64_t progress, int64_t total);
typedef void (^CMNetworkCompletionBlock)(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable error);

typedef void (^CMNetworkImageSuccessBlock)(NSURLRequest * __nullable request, NSURLResponse * __nullable response, UIImage * __nullable image);
typedef void (^CMNetworkImageFailureBlock)(NSURLRequest * __nullable request, NSURLResponse * __nullable response, NSError * __nullable error);

#endif /* CMNetwork_h */
