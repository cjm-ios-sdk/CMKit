//
//  UIButton+CMAction.m
//  CMViewCategory
//
//  Created by chenjm on 2021/1/12.
//

#import "UIButton+CMAction.h"
#import <objc/runtime.h>

@implementation UIButton (CMAction)

- (NSMutableArray *)cm_actions {
    NSMutableArray *actions = objc_getAssociatedObject(self, @selector(cm_actions));
    if (!actions) {
        actions = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, @selector(cm_actions), actions, OBJC_ASSOCIATION_RETAIN);
    }
    return actions;
}

- (void)cm_addActionHandler:(void (^)(void))actionHandler forControlEvents:(UIControlEvents)controlEvents {
//    NSMutableDictionary *events = [[NSMutableDictionary alloc] init];
//    [events setValue:actionHandler forKey:[NSString stringWithFormat:@"%ud", controlEvents]];

    [[self cm_actions] addObject:actionHandler];
    [self addTarget:self action:@selector(cm_startAction:event:) forControlEvents:controlEvents];  /** 添加一个事件 */
}

- (void)cm_startAction:(UIButton *)sender event:(UIEvent *)event {
    NSLog(@"touch me");
    NSMutableArray *array = [self cm_actions];
    for (int i = 0; i < array.count; i++) {
        void (^block)(void) = array[i];
        block();
    }
}


@end
