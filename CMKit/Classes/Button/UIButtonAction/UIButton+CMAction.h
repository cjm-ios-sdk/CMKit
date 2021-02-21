//
//  UIButton+CMAction.h
//  CMViewCategory
//
//  Created by chenjm on 2021/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CMAction)

- (void)cm_addActionHandler:(void (^)(void))actionHandler forControlEvents:(UIControlEvents)controlEvents;

@end

NS_ASSUME_NONNULL_END
