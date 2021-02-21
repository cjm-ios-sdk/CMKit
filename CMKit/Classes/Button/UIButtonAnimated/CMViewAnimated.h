//
//  CMViewAnimated.h
//  CMViewCategory
//
//  Created by chenjm on 2019/7/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMViewAnimated : NSObject
@property(nonatomic, assign) CGFloat animatedAlpha;                 // 点击时的透明值 默认 0.4
@property(nonatomic, assign) CGAffineTransform animatedTransform;   // 点击时的缩放值 默认 0.9
@property(nonatomic, assign) NSTimeInterval animatedBeginDuration;  // 开始动画时长 默认 0.15
@property(nonatomic, assign) NSTimeInterval animatedEndDuration;    // 结束动画时长 默认 0.25
@property(nonatomic, assign) CGAffineTransform originTransform;     // default CGAffineTransformIdentity
@property(nonatomic, assign) CGFloat originAlpha;                   // default 1.0
@property(nonatomic, assign) NSTimeInterval animatedBeginTime;      // 开始时间 自动计算

/**
 * @brief 初始化
 * @param animatedAlpha 动画结束时的透明度
 * @param animatedTransform 动画结束时的形变值
 */
- (instancetype)initWithAnimatedAlpha:(CGFloat)animatedAlpha
                    animatedTransform:(CGAffineTransform)animatedTransform;

/**
 * @brief 初始化
 * @param animatedAlpha 动画结束时的透明度
 * @param animatedScale 动画结束时的缩放值
 */
- (instancetype)initWithAnimatedAlpha:(CGFloat)animatedAlpha
                        animatedScale:(CGFloat)animatedScale;

@end

NS_ASSUME_NONNULL_END
