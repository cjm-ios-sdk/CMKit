//
//  UINavigationController+CMRouter.m
//  CMRouter
//
//  Created by chenjm on 2020/4/10.
//  Copyright © 2020年 chenjm. All rights reserved.
//

#import "UINavigationController+CMRouter.h"
#import <objc/runtime.h>
#import <StoreKit/StoreKit.h>

@implementation UINavigationController (CMRouter)

- (id)cm_routerDelegate {
    return objc_getAssociatedObject(self, @selector(cm_routerDelegate));
}

- (void)setCm_routerDelegate:(id)cm_routerDelegate {
    objc_setAssociatedObject(self, @selector(cm_routerDelegate), cm_routerDelegate, OBJC_ASSOCIATION_ASSIGN);
}

/**
 * @brief 推入视图控制器
 * @param urlString urlEncode的字符串，+号转为空格号。
 * @param paramters 如果是内部页面，可以传入viewController的参数
 * @param animated 动画
 */
- (void)cm_pushViewControllerWithUrlString:(NSString *)urlString
                                   paramters:(NSDictionary *)paramters
                                    animated:(BOOL)animated {
    CMRouterRequest *routerRequest = [[CMRouterRequest alloc] initWithUrlString:urlString paramters:paramters];
    if (self.cm_routerDelegate) {
        UIViewController *vc = [self.cm_routerDelegate navigationController:self routerRequest:routerRequest];
        if (vc) {
            [self pushViewController:vc animated:animated];
        }
    }
}

/**
 * @brief 展示视图控制器
 * @param completion 关闭完成
 */
- (void)cm_presentViewControllerWithUrlString:(NSString *)urlString
                                      paramters:(NSDictionary *)paramters
                                       animated:(BOOL)animated
                                     completion:(void (^)(void))completion {
    CMRouterRequest *routerRequest = [[CMRouterRequest alloc] initWithUrlString:urlString paramters:paramters];
    if (self.cm_routerDelegate) {
        UIViewController *vc = [self.cm_routerDelegate navigationController:self routerRequest:routerRequest];
        if (vc) {
            [self presentViewController:vc animated:animated completion:completion];
        }
    }
}

/**
 * @brief 返回视图控制器
 * @param urlString urlEncode的字符串，+号转为空格号。
 * @param paramters 如果是内部页面，可以传入viewController的参数
 */
- (UIViewController *)viewControllerWithUrlString:(NSString *)urlString
                                        paramters:(NSDictionary *)paramters {
    CMRouterRequest *routerRequest = [[CMRouterRequest alloc] initWithUrlString:urlString paramters:paramters];
    if (self.cm_routerDelegate) {
        return [self.cm_routerDelegate navigationController:self routerRequest:routerRequest];
    } else {
        return nil;
    }
}

/**
 * @brief 打开外部链接，如外部网页
 * @param urlString 链接
 * @param completion 完成回调
 */
- (void)cm_openUrlString:(NSString *)urlString
                completion:(void (^)(BOOL))completion {
    NSURL *url = [NSURL URLWithString:urlString];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [app openURL:url options:@{} completionHandler:completion];
        } else {
            BOOL flag = [app openURL:url];
            if (completion) {
                completion(flag);
            }
        }
    } else {
        if (completion) {
            completion(NO);
        }
    }
}

@end
