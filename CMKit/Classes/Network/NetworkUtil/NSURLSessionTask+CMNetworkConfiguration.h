//
//  NSURLSessionTask+CMNetworkingConfiguration.h
//  Pods
//
//  Created by chenjm on 2016/12/8.
//
//

#import <Foundation/Foundation.h>
#import "CMNetworkConfiguration.h"

@interface NSURLSessionTask (CMNetworkConfiguration)
@property (nonatomic, strong) CMNetworkConfiguration *CMNetwork_configuration;
@end
