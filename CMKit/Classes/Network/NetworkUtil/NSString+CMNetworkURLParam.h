//
//  NSString+CMNetworkingURLParam.h
//  Pods
//
//  Created by chenjm on 2016/12/8.
//
//

#import <Foundation/Foundation.h>

@interface NSString (CMNetworkURLParam)

/**
 * @brief 将url和参数转为完整url
 * @param param url参数
 */
- (NSString *)CMNetwork_urlParam:(NSDictionary *)param;

/**
 * @brief 将参数转化为key=[value urlEncode]的形式
 * @param param
 */
+ (NSString *)CMNetworking_queryStringFromParam:(NSDictionary *)param;

- (NSString *)CMNetwork_urlEncode;

@end
