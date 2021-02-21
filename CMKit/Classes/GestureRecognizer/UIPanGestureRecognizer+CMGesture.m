//
//  UIPanGestureRecognizer+CMGesture.m
//  CMGestureRecognizer
//
//  Created by chenjm on 2020/4/21.
//

#import "UIPanGestureRecognizer+CMGesture.h"

@implementation UIPanGestureRecognizer (CMGesture)

- (void)cjmg_pandView:(UIView *)view {
    CGPoint translation = [self translationInView:view.superview];
    view.transform = CGAffineTransformTranslate(view.transform, translation.x, translation.y);
    [self setTranslation:CGPointZero inView:view.superview];
}

@end
