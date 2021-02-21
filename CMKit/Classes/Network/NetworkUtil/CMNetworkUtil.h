//
//  CMNetworkUtil.h
//  Pods
//
//  Created by chenjm on 2016/11/30.
//
//

#import <Foundation/Foundation.h>

@interface CMNetworkUtil : NSObject

@end


NSData *__nullable CMNetworkGzipData(NSData *__nullable input, float level);
UIImage *__nullable CMNetworkDecodeImageWithData(NSData * _Nullable data,
                                           CGSize destSize,
                                           CGFloat destScale,
                                           UIViewContentMode resizeMode);
