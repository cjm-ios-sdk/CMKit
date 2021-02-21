////
////  CMTopbar.m
////  CMTopbar
////
////  Created by chenjm on 2021/1/2.
////
//
//#import "CMTopbar.h"
//
//@implementation CMTopbar
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        self.titleLabel = ({
//            UILabel *label = [[UILabel alloc] init];
//            [self addSubview:label];
//            label.font = [UIFont systemFontOfSize:20];
//            label.textColor = [UIColor blackColor];
//            label.translatesAutoresizingMaskIntoConstraints = NO;
//            label;
//        });
//        
//        UIView *lastLeftView = nil;
//        for (UIView *view in self.leftViews) {
//            [NSLayoutConstraint activateConstraints:@[
//                [view.topAnchor constraintEqualToAnchor:self.topAnchor],
//                [view.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
//                [view.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
//                [view.widthAnchor constraintEqualToConstant:44]
//            ]];
//        }
//        
//        [NSLayoutConstraint activateConstraints:@[
//            [_leftButton.topAnchor constraintEqualToAnchor:self.topAnchor],
//            [_leftButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
//            [_leftButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
//            [_leftButton.widthAnchor constraintEqualToConstant:44]
//        ]];
//        
//        [NSLayoutConstraint activateConstraints:@[
//            [_rightButton.topAnchor constraintEqualToAnchor:self.topAnchor],
//            [_rightButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
//            [_rightButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
//            [_rightButton.widthAnchor constraintEqualToConstant:44]
//        ]];
//        
//        [NSLayoutConstraint activateConstraints:@[
//            [_titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
//            [_titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
//            [_titleLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:_leftButton.trailingAnchor],
//            [_titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:_rightButton.leadingAnchor],
//        ]];
//    }
//    return self;
//}
//
//@end
