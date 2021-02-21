//
//  CMRouterTable.h
//  CMRouter
//
//  Created by chenjm on 2020/4/8.
//  Copyright © 2020年 chenjm. All rights reserved.
//

#import "CMRouterTable.h"

@interface CMRouterTable ()
@end

@implementation CMRouterTable


#pragma mark - 初始化

- (instancetype)initWithPageIdList:(NSDictionary *)pageIdList {
    self = [super init];
    if (self) {
        _pageIdList = [pageIdList copy];
        
        NSMutableDictionary *mutableList = [[NSMutableDictionary alloc] initWithCapacity:_pageIdList.count];
        for (NSString *key in _pageIdList.allKeys) {
            NSMutableDictionary *mutableInfo = [_pageIdList[key] mutableCopy];
            mutableInfo[CMRouterPageId] = key;
            [mutableInfo removeObjectForKey:CMRouterPageClass];
            [mutableList setValue:mutableInfo forKey:CMRouterPageClass];
        }
        _pageClassNameList = mutableList;
    }
    return self;
}

- (instancetype)initWithPageClassNameList:(NSDictionary *)pageClassNameList {
    self = [super init];
    if (self) {
        _pageClassNameList = [pageClassNameList copy];
        
        NSMutableDictionary *mutableList = [[NSMutableDictionary alloc] initWithCapacity:_pageClassNameList.count];
        for (NSString *key in _pageClassNameList.allKeys) {
            NSMutableDictionary *mutableInfo = [_pageClassNameList[key] mutableCopy];
            mutableInfo[CMRouterPageClass] = key;
            [mutableInfo removeObjectForKey:CMRouterPageId];
            [mutableList setValue:mutableInfo forKey:CMRouterPageId];
        }
        _pageClassNameList = mutableList;
    }
    return self;
}


#pragma mark - 获取pageId

- (NSString *)pageIdByPageClassName:(NSString *)pageClassName {
    if (!pageClassName) {
        return nil;
    }
    return _pageClassNameList[pageClassName][CMRouterPageId];
}


#pragma mark - 获取pageClassName

- (NSString *)pageClassNameByPageId:(NSString *)pageId {
    if (!pageId) {
        return nil;
    }
    return _pageIdList[pageId][CMRouterPageClass];
}

#pragma mark - 获取pageName

- (NSString *)pageNameByPageId:(NSString *)pageId {
    if (!pageId) {
        return nil;
    }
    return _pageIdList[pageId][CMRouterPageName];
}

- (NSString *)pageNameByPageClassName:(NSString *)pageClassName {
    if (!pageClassName) {
        return nil;
    }
    return _pageClassNameList[pageClassName][CMRouterPageName];
}


#pragma mark - 获取ViewController

- (UIViewController *)viewControllerByPageId:(NSString *)pageId {
    NSString *pageClassName = [self pageClassNameByPageId:pageId];
    Class aClass = NSClassFromString(pageClassName);
    return [[aClass alloc] init];
}

- (UIViewController *)viewControllerByPageClassName:(NSString *)pageClassName {
    Class aClass = NSClassFromString(pageClassName);
    return [[aClass alloc] init];
}


@end
