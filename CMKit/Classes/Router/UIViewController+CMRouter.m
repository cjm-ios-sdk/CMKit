//
//  UIViewController+CMRouter.m
//  CMRouter
//
//  Created by chenjm on 2020/4/9.
//  Copyright © 2020年 chenjm. All rights reserved.
//

#import "UIViewController+CMRouter.h"
#import <objc/runtime.h>

@implementation UIViewController (CMRouter)

- (NSDictionary *)cm_paramters {
    return (NSDictionary *)objc_getAssociatedObject(self, @selector(cm_paramters));
}

- (void)setCm_paramters:(NSDictionary *)cm_paramters {
    objc_setAssociatedObject(self, @selector(cm_paramters), cm_paramters, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
