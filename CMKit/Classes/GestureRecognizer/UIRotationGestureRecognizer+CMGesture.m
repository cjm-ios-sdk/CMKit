//
//  UIRotationGestureRecognizer+CMGesture.m
//  CMGestureRecognizer
//
//  Created by chenjm on 2020/4/21.
//

#import "UIRotationGestureRecognizer+CMGesture.h"

@implementation UIRotationGestureRecognizer (CMGesture)

- (void)cjmg_rotateView:(UIView *)view {
    float radian = [self rotation];
    view.transform = CGAffineTransformRotate(view.transform, radian);
    [self setRotation:0];
}

@end
