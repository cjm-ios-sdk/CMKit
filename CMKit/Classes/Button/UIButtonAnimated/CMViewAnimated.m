//
//  CMViewAnimated.m
//  CMViewCategory
//
//  Created by chenjm on 2019/7/23.
//

#import "CMViewAnimated.h"

@implementation CMViewAnimated

- (instancetype)init {
    self = [super init];
    if (self) {
        _animatedAlpha = 0.4;
        _animatedTransform = CGAffineTransformMakeScale(0.9, 0.9);
        _animatedBeginDuration = 0.15;
        _animatedEndDuration = 0.25;
        _originTransform = CGAffineTransformIdentity;
        _originAlpha = 1.0;        
    }
    return self;
}

/**
 * @brief 初始化
 * @param animatedAlpha 动画结束时的透明度
 * @param animatedTransform 动画结束时的形变值
 */
- (instancetype)initWithAnimatedAlpha:(CGFloat)animatedAlpha
                    animatedTransform:(CGAffineTransform)animatedTransform {
    self = [self init];
    if (self) {
        _animatedAlpha = animatedAlpha;
        _animatedTransform = animatedTransform;
    }
    return self;
}

/**
 * @brief 初始化
 * @param animatedAlpha 动画结束时的透明度
 * @param animatedScale 动画结束时的缩放值
 */
- (instancetype)initWithAnimatedAlpha:(CGFloat)animatedAlpha
                        animatedScale:(CGFloat)animatedScale {
    self = [self init];
    if (self) {
        _animatedAlpha = animatedAlpha;
        _animatedTransform = CGAffineTransformMakeScale(animatedScale, animatedScale);
    }
    return self;
}


@end
