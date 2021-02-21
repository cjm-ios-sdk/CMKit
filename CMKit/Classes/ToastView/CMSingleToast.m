//
//  CMSingleToast.m
//  CMKit
//
//  Created by chenjm on 2021/2/20.
//

#import "CMSingleToast.h"
#import <CMKit/NSTimer+CMTimer.h>

static NSTimer *sTipTimer = nil;
static UIView *sToastView = nil;

@implementation CMSingleToastConfig


@end


@implementation CMSingleToast

+ (void)showWithConfig:(CMSingleToastConfig *)config {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (!sToastView) {
        sToastView = ({
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:config.title
                                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
            CGRect rect = [string boundingRectWithSize:CGSizeMake(280, 200)
                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               context:nil];
            
            UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect) + 40, CGRectGetHeight(rect) + 30)];
            tipView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            tipView.center = window.center;
            tipView.layer.cornerRadius = 3;
            tipView.clipsToBounds = YES;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
            label.attributedText = string;
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [tipView addSubview:label];
            label.center = CGPointMake(tipView.bounds.size.width/2, tipView.bounds.size.height/2);
            tipView;
        });
    }
    
    if (!sToastView.superview) {
        [window addSubview:sToastView];
    }
    
    if (sTipTimer) {
        [sTipTimer invalidate];
        sTipTimer = nil;
    }
    
    sTipTimer = [NSTimer cm_scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [UIView animateWithDuration:0.2 animations:^{
            sToastView.alpha = 0;
        } completion:^(BOOL finished) {
            if (sToastView.superview) {
                [sToastView removeFromSuperview];
            }
            sToastView = nil;
        }];
    }];
}


@end
