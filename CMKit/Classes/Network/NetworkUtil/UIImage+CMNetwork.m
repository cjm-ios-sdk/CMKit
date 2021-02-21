//
//  UIImage+CMNetwork.m
//  Pods
//
//  Created by chenjm on 2016/12/21.
//
//

#import "UIImage+CMNetwork.h"
#import <objc/runtime.h>

@implementation UIImage (CMNetwork)

- (CAKeyframeAnimation *)CMNetworkKeyframeAnimation {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCMNetworkKeyframeAnimation:(CAKeyframeAnimation *)CMNetworkKeyframeAnimation {
    objc_setAssociatedObject(self, @selector(CMNetworkKeyframeAnimation), CMNetworkKeyframeAnimation, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSData *)CMNetworkImageData {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCMNetworkImageData:(NSData *)CMNetworkImageData {
    objc_setAssociatedObject(self, @selector(CMNetworkImageData), CMNetworkImageData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
