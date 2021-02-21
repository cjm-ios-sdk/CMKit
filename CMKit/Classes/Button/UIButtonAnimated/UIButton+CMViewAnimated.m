//
//  UIButton+CMViewAnimated.m
//  CMViewCategory
//
//  Created by chenjm on 2019/7/23.
//

#import "UIButton+CMViewAnimated.h"
#import <objc/runtime.h>

static const void *SLUIButtonAnimatedInfoKey = &SLUIButtonAnimatedInfoKey;

@implementation UIButton (SLUIButtonAnimated)

+ (void)load {
    NSArray *methods = @[@"touchesBegan:withEvent:", @"touchesEnded:withEvent:", @"touchesCancelled:withEvent:"];
    for (NSString *method in methods) {
        SEL originSel = NSSelectorFromString(method);
        Method originMethod = class_getInstanceMethod([self class], originSel);
        
        SEL switchSel = NSSelectorFromString([@"cm_" stringByAppendingString:method]);
        Method switchMethod = class_getInstanceMethod([self class], switchSel);
        
        if (class_addMethod([self class], originSel, method_getImplementation(switchMethod), method_getTypeEncoding(switchMethod))) {
            class_replaceMethod([self class], switchSel, method_getImplementation(originMethod), method_getTypeEncoding(switchMethod));
        }
        else {
            method_exchangeImplementations(originMethod, switchMethod);
        }
    }
}


#pragma mark - 添加成员变量

- (CMViewAnimated *)cm_animated {
    return objc_getAssociatedObject(self, SLUIButtonAnimatedInfoKey);
}

- (void)setCm_animated:(CAShapeLayer *)cm_animated {
    objc_setAssociatedObject(self, SLUIButtonAnimatedInfoKey, cm_animated, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - 动画函数

- (void)animatedBegan {    
    if (self.cm_animated) {
        self.cm_animated.animatedBeginTime = CFAbsoluteTimeGetCurrent();
        // 动画先快后慢
        [UIView animateWithDuration:self.cm_animated.animatedBeginDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = self.cm_animated.animatedAlpha;
            self.transform = self.cm_animated.animatedTransform;
        } completion:^(BOOL finished) {

        }];
    }
}

- (void)animatedEnd {
    if (self.cm_animated) {
        NSTimeInterval interval = CFAbsoluteTimeGetCurrent() - self.cm_animated.animatedBeginTime;
        NSTimeInterval delayTime = MAX(0, self.cm_animated.animatedBeginDuration - interval);
        
        // 动画开始和结尾慢，中间快
        [UIView animateWithDuration:self.cm_animated.animatedEndDuration delay:delayTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = self.cm_animated.originAlpha;
            self.transform = self.cm_animated.originTransform;
        } completion:^(BOOL finished) {
  
        }];
    }
}


#pragma mark - 交换函数

- (void)cm_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self animatedBegan];
    [self cm_touchesBegan:touches withEvent:event];
}

- (void)cm_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self animatedEnd];
    [self cm_touchesEnded:touches withEvent:event];
}

- (void)cm_touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self animatedEnd];
    [self cm_touchesCancelled:touches withEvent:event];
}

@end
