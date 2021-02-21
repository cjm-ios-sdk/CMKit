//
//  UIPinchGestureRecognizer+CMGesture.m
//  CMGestureRecognizer
//
//  Created by chenjm on 2020/4/21.
//

#import "UIPinchGestureRecognizer+CMGesture.h"

@implementation UIPinchGestureRecognizer (CMGesture)

- (void)cjmg_pinchView:(UIView *_Nonnull)view {
    float scale = [self scale];
    view.transform = CGAffineTransformScale(view.transform, scale, scale);
    [self setScale:1];
}

@end
