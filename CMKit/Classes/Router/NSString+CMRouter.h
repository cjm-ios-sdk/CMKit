//
//  NSString+CMRouter.h
//  CMRouter
//
//  Created by chenjm on 2020/4/10.
//  Copyright © 2020年 chenjm. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (CMRouter)


/**
 * @brief 是否是http或者https
 */
- (BOOL)cm_isHttpURLString;

/**
 * @brief 获取url中的scheme
 */
- (NSString *_Nullable)cm_scheme;

/**
 * @brief 获取url中的path
 */
- (NSString *_Nullable)cm_path;

/**
 * @brief 获取url中的参数
 */
- (NSDictionary *_Nullable)cm_paramters;

@end

