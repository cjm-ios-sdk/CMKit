//
//  CMViewRoundCorner.m
//  CMViewCategory
//
//  Created by chenjm on 2020/4/24.
//

#import "CMViewRoundCorner.h"

@implementation CMViewRoundCorner

- (instancetype)init {
    self = [super init];
    if (self) {
        _maskedColor = [UIColor whiteColor];
        _maskedCorners = CMViewMaskedCornersAll;
        _maskedType = CMViewMaskedTypeSetMask;
        _radius = 0;
        _borderWidth = 0;
        _borderColor = [UIColor whiteColor];
        _shadowRadius = 0;
        _shadowColor = [UIColor whiteColor];
        _shadowOffset = CGSizeZero;
        _shadowOpacity = 0;
    }
    return self;
}

@end
