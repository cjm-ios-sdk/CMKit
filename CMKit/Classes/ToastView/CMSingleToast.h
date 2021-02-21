//
//  CMSingleToast.h
//  CMKit
//
//  Created by chenjm on 2021/2/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMSingleToastConfig : NSObject
@property (nonatomic, copy) NSString *title;
@end

@interface CMSingleToast : NSObject

+ (void)showWithConfig:(CMSingleToastConfig *)config;

@end

NS_ASSUME_NONNULL_END
