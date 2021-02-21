//
//  CMRouterErrorViewController.h
//  CMRouter
//
//  Created by chenjm on 2020/4/8.
//  Copyright © 2020年 chenjm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CMRouterErrorViewController : UIViewController
@property (nonatomic, copy) NSString *_Nullable errorMessage;
@property (nonatomic, strong) UITextView * _Nonnull textView;

@end
