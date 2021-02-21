//
//  UIView+CMViewRoundCorner.m
//  CMViewCategory
//
//  Created by chenjm on 2020/4/24.
//

#import "UIView+CMViewRoundCorner.h"
#import <objc/runtime.h>

@implementation UIView (CMViewRoundCorner)
@dynamic cm_corner;


#pragma mark - 交换函数

+ (void)load {
    if (@available(iOS 11.0, *)) {
        return;
    }
    
    NSArray *methods = @[@"layoutSubviews"];
    for (NSString *method in methods) {
        SEL originSel = NSSelectorFromString(method);
        Method originMethod = class_getInstanceMethod([self class], originSel);
        
        SEL switchSel = NSSelectorFromString([NSString stringWithFormat:@"cm_%@", method]);
        Method switchMethod = class_getInstanceMethod([self class], switchSel);
        
        if (class_addMethod([self class], originSel, method_getImplementation(switchMethod), method_getTypeEncoding(switchMethod))) {
            class_replaceMethod([self class], switchSel, method_getImplementation(originMethod), method_getTypeEncoding(switchMethod));
        } else {
            method_exchangeImplementations(originMethod, switchMethod);
        }
    }
}

- (void)cm_layoutSubviews {
    [self cm_layoutSubviews];
    
    if (self.cm_corner) {
        CAShapeLayer *maskShapeLayer = [self cm_maskShapeLayer];
        maskShapeLayer.path = [self cm_bezierPath].CGPath;
        maskShapeLayer.frame = self.bounds;
        
        CAShapeLayer *shadowShapeLayer = [self cm_shadowShapeLayer];
        shadowShapeLayer.path = [self cm_bezierPath].CGPath;
        shadowShapeLayer.frame = self.bounds;
    }
}


#pragma mark - cm_shadowShapeLayer

- (CAShapeLayer *)cm_shadowShapeLayer {
    return objc_getAssociatedObject(self, @selector(cm_shadowShapeLayer));
}

- (void)setCm_shadowShapeLayer:(CAShapeLayer *)cm_shadowShapeLayer {
    objc_setAssociatedObject(self, @selector(cm_shadowShapeLayer), cm_shadowShapeLayer, OBJC_ASSOCIATION_RETAIN);
}


#pragma mark - cm_maskShapeLayer

- (CAShapeLayer *)cm_maskShapeLayer {
    return objc_getAssociatedObject(self, @selector(cm_maskShapeLayer));
}

- (void)setCm_maskShapeLayer:(CAShapeLayer *)cm_maskShapeLayer {
    objc_setAssociatedObject(self, @selector(cm_maskShapeLayer), cm_maskShapeLayer, OBJC_ASSOCIATION_RETAIN);
}


#pragma mark - cm_corner

- (CMViewRoundCorner *)cm_corner {
    return objc_getAssociatedObject(self, @selector(cm_corner));
}

- (void)setCm_corner:(CMViewRoundCorner *)cm_corner {
    objc_setAssociatedObject(self, @selector(cm_corner), cm_corner, OBJC_ASSOCIATION_RETAIN);
    
    if (@available(iOS 11, *)) {
        self.layer.shadowRadius = cm_corner.shadowRadius;
        self.layer.shadowOffset = cm_corner.shadowOffset;
        self.layer.shadowOpacity = cm_corner.shadowOpacity;
        self.layer.shadowColor = cm_corner.shadowColor.CGColor;
        self.layer.maskedCorners = (CACornerMask)cm_corner.maskedCorners;
        self.layer.borderWidth = cm_corner.borderWidth;
        self.layer.borderColor = cm_corner.borderColor.CGColor;
        self.layer.cornerRadius = cm_corner.radius;
        
        return;
    }

    if (cm_corner) {
        /* 圆角 */
        CAShapeLayer *maskShapLayer = [self cm_maskShapeLayer];
        if (!maskShapLayer) {
            maskShapLayer = [CAShapeLayer layer];
            [self setCm_maskShapeLayer:maskShapLayer];
        }

        maskShapLayer.path = [self cm_bezierPath].CGPath;
        maskShapLayer.fillColor = cm_corner.maskedColor.CGColor;
        maskShapLayer.frame = self.bounds;
        
        if (cm_corner.maskedType == CMViewMaskedTypeSetMask) {
            self.layer.mask = maskShapLayer;
        } else {
            [self.layer addSublayer:maskShapLayer];
            
            self.layer.backgroundColor = [UIColor clearColor].CGColor;

            
            /* 阴影 */
            CAShapeLayer *shadowShapLayer = [self cm_shadowShapeLayer];
            if (!shadowShapLayer) {
                shadowShapLayer = [CAShapeLayer layer];
                [self setCm_shadowShapeLayer:shadowShapLayer];
            }
            
            if (!shadowShapLayer.superlayer) {
                [self.layer addSublayer:shadowShapLayer];
            }
            
            shadowShapLayer.path = [self cm_bezierPath].CGPath;
            shadowShapLayer.frame = self.bounds;
            shadowShapLayer.fillColor = cm_corner.maskedColor.CGColor;
            shadowShapLayer.strokeColor = cm_corner.borderColor.CGColor;
            shadowShapLayer.lineWidth = cm_corner.borderWidth;
            
            shadowShapLayer.shadowRadius = cm_corner.shadowRadius;
            shadowShapLayer.shadowColor = cm_corner.shadowColor.CGColor;
            shadowShapLayer.shadowOffset = cm_corner.shadowOffset;
            shadowShapLayer.shadowOpacity = cm_corner.shadowOpacity;
        }
    } else {
        if ([self cm_maskShapeLayer] && [self cm_maskShapeLayer].superlayer) {
            [[self cm_maskShapeLayer] removeFromSuperlayer];
            [self setCm_maskShapeLayer:nil];
        }
        
        if ([self cm_shadowShapeLayer] && [self cm_shadowShapeLayer].superlayer) {
            [[self cm_shadowShapeLayer] removeFromSuperlayer];
            [self setCm_shadowShapeLayer:nil];
        }
    }
}

- (UIBezierPath *)cm_bezierPath {
    return [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                 byRoundingCorners:(UIRectCorner)self.cm_corner.maskedCorners
                                       cornerRadii:CGSizeMake(self.cm_corner.radius, self.cm_corner.radius)];;
}



@end
