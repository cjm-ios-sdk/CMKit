//
//  CMNetworkInfo.h
//  Pods
//
//  网络状态信息
//
//  Created by chenjm on 2016/11/29.
//
//

#import <Foundation/Foundation.h>

// 网络状态变化的通知
extern NSString *const CMNetworkStatusDidChangeNotification;


// 未知的网络状态
extern NSString *const CMNetworkStatusUnknown;

// 没有网络
extern NSString *const CMNetworkStatusNone;

// wifi
extern NSString *const CMNetworkStatusWifi;

// 蜂窝
extern NSString *const CMNetworkStatusCell;



@interface CMNetworkInfo : NSObject
@property (nonatomic, readonly) NSString *status;


+ (CMNetworkInfo *)shareInstance;

@end
