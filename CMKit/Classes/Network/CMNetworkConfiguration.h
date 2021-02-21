//
//  CMNetworkConfiguration.h
//  Pods
//
//  描述：网络配置
//
//  Created by chenjm on 2016/12/8.
//
//

#import <Foundation/Foundation.h>

@interface CMNetworkConfiguration : NSObject
@property (nonatomic, assign) NSTimeInterval timeoutInterval; // 超时，默认20s
@property (nonatomic, assign) BOOL isShowNetworkActivity; // 是否显示网络状态
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy; // 缓存策略，默认为NSURLRequestUseProtocolCachePolicy
@end
