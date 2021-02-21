//
//  CMNetworkDataRequest.h
//  Pods
//
//  描述：对于data的请求
//
//  Created by chenjm on 2016/11/29.
//
//

#import <Foundation/Foundation.h>
#import "CMNetworkHeader.h"

/**
 * data请求
 * 格式：例如：@"data:image/jpg;base64,iVBORw0KGgoAAAANSUhEUgAAAKAAAAAwCAMAAAChd4FcAAAAA3NCSVQICAjb4U/gAAACRlBMVEUAAADi6OSMjIxSUlIrXja5trg8rFEDRhErokJ8w4pJrVxmZmYERRIinTn++P07nk/X0Naww7Stra0pdTj37/dlunUXWiS53L+ZmZmOy5pahGJKdVIQEBAsXzdni24VmC7MzMw1kEYzMzPZ4Nul1K6Wr5tWs2jp8eseaC0ufz5mZmaEoorI1cszpUkXTSJErFix2bi1tbVKSkp7e3skWC9wvn5zlHq6yL3S3dSXzqJBcEspKSnY6dxCQkLI486mvKulpaVAbUkTSx8ICAgjcDIhISHh7eM6Ojonnz1QsGP///。。。
 *
 */

@interface CMNetworkDataRequest : NSObject

/**
 * @brief 返回全局的对象
 */
+ (CMNetworkDataRequest *)standardRequest;

/**
 * @brief 创建一个对象
 */
+ (CMNetworkDataRequest *)createObject;

/**
 * @brief 全部无效
 */
- (void)invalidate;

/**
 * @brief 能否请求
 */
- (BOOL)canHandleRequest:(NSURLRequest *)request;

/**
 * @brief 请求
 */
- (NSOperation *)fecthWithRequest:(NSURLRequest *)request
                       completion:(CMNetworkCompletionBlock)completion;

/**
 * @brief 取消请求
 */
- (void)cancelRequest:(NSOperation *)op;

@end
