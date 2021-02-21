//
//  CMAlertViewController.h
//  CMAlertViewController
//
//  Created by chenjm on 2020/4/14.
//

#import <UIKit/UIKit.h>


@interface CMAlertAction : NSObject
@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) UIAlertActionStyle style;           // 暂时未实现
@property (nonatomic, getter=isEnabled) BOOL enabled;               // 是否可用，默认 YES
@property (nullable, nonatomic, strong) UIColor *titleColor;        // 标题颜色 blackColor
@property (nullable, nonatomic, strong) UIColor *disableTitleColor; // 默认 grayColor
@property (nullable, nonatomic, strong) UIFont *titleFont;          // 标题字体，默认 [UIFont boldSystemFontOfSize:18]

/**
 * @brief 生成和初始化一个action
 * @param title 标题
 * @param style 类型 暂时未实现
 * @param handler 回调函数
 */
+ (instancetype _Nonnull )actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction * _Nonnull action))handler;


@end


@interface CMAlertViewController : UIViewController
@property (nonnull, nonatomic, readonly) NSArray<CMAlertAction *> * actions;
@property (nullable, nonatomic, copy) NSString *alertTitle;     // 弹框标题
@property (nonatomic, assign) CGFloat alertViewHeight;          // 默认 200
@property (nonnull, nonatomic, strong, readonly) UIView *alertView;      // 弹框
@property (nonnull, nonatomic, strong, readonly) UILabel *titleLabel;    // 标题Label

/**
 * @brief 添加一个按钮和事件
 */
- (void)addAction:(CMAlertAction *_Nonnull)action;

/**
 * @brief 添加一个label
 */
- (void)addLabelWithConfigurationHandler:(void (^ __nullable)(UILabel *_Nonnull label))configurationHandler;

/**
 * @brief 添加一个label
 */
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField * _Nonnull textField))configurationHandler;

/**
 * @brief 添加一个view
 */
- (void)addViewWithHeight:(CGFloat)height configurationHandler:(void (^ __nullable)(UIView *_Nonnull view))configurationHandler;

/**
* @brief 添加一个scrollView
*/
- (void)addScrollViewWithHeight:(CGFloat)height configurationHandler:(void (^ __nullable)(UIScrollView * _Nonnull view))configurationHandler;



@end

