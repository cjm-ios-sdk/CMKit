//
//  CMNetworkGIFImageDecoder.h
//  Pods
//
//  描述：gif解码
//
//  Created by chenjm on 2016/12/21.
//
//

#import <Foundation/Foundation.h>

typedef void (^CMNetworkImageLoaderCancellationBlock)(void);
typedef void (^CMNetworkImageLoaderCompletionBlock)(NSError *error, UIImage *image);


@interface CMNetworkGIFImageDecoder : NSObject


- (BOOL)canDecodeImageData:(NSData *)imageData;

- (CMNetworkImageLoaderCancellationBlock)decodeImageData:(NSData *)imageData
                                                    size:(CGSize)size
                                                   scale:(CGFloat)scale
                                              resizeMode:(UIViewContentMode)resizeMode
                                       completionHandler:(CMNetworkImageLoaderCompletionBlock)completionHandler;

- (CMNetworkImageLoaderCancellationBlock)asyncDecodeImageData:(NSData *)imageData
                                                    size:(CGSize)size
                                                   scale:(CGFloat)scale
                                              resizeMode:(UIViewContentMode)resizeMode
                                       completionHandler:(CMNetworkImageLoaderCompletionBlock)completionHandler;

@end
