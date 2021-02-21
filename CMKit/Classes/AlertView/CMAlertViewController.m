//
//  CMAlertViewController.m
//  CMAlertViewController
//
//  Created by chenjm on 2020/4/14.
//

#import "CMAlertViewController.h"

@interface CMAlertAction ()
@property (nonatomic, copy) void (^ __nullable handler)(CMAlertAction *action);
@property (nonatomic, copy) void (^ __nullable enableHandler)(BOOL enable);
@property (nonatomic, copy) void (^ __nullable titleColorHandler)(UIColor *titleColor);
@property (nonatomic, copy) void (^ __nullable titleFontHandler)(UIFont *titleFont);
@end

@implementation CMAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler {
    return [[CMAlertAction alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler {
    self = [super init];
    if (self) {
        _title = title;
        _style = style;
        _handler = [handler copy];
        _titleColor = [UIColor colorWithRed:31/255.0 green:69/255.0 blue:1.0 alpha:1];
        _disableTitleColor = [UIColor grayColor];
        _titleFont = [UIFont boldSystemFontOfSize:18];
        _enabled = YES;
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    if (_enableHandler) {
        _enableHandler(enabled);
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    if (!titleColor) {
        return;
    }
    _titleColor = titleColor;
    if (_titleColorHandler) {
        _titleColorHandler(titleColor);
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    if (!titleFont) {
        return;
    }
    _titleFont = titleFont;
    if (_titleFontHandler) {
        _titleFontHandler(titleFont);
    }
}

@end



@interface CMAlertViewController ()
@property (nonatomic, strong) NSMutableArray <CMAlertAction *>*actions;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIView *hLineView;
@property (nonatomic, strong) NSMutableArray *outsizeAddSubviews; //
@end

@implementation CMAlertViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        _alertViewHeight = 150;
        _actions = [[NSMutableArray alloc] initWithCapacity:2];
        _buttons = [[NSMutableArray alloc] initWithCapacity:2];
        _outsizeAddSubviews = [[NSMutableArray alloc] initWithCapacity:4];
        
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        [self addAlertViewIfNotExist];
        [self addTitleLabelIfNotExist];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Accessor

- (void)setAlertTitle:(NSString *)alertTitle {
    _alertTitle = [alertTitle copy];
    _titleLabel.text = _alertTitle;
}

- (void)setAlertViewHeight:(CGFloat)alertViewHeight {
    _alertViewHeight = alertViewHeight;
    
    NSArray *constrains = self.view.constraints;
    for (NSLayoutConstraint *constraint in constrains) {
        if (constraint.firstItem == _alertView && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = _alertViewHeight;
        }
    }
    
    [_alertView updateConstraints];
}


#pragma mark - AlertView

- (void)addAlertViewIfNotExist {
    if (_alertView) {
        return;
    }
    
    _alertView = [[UIView alloc] init];
    _alertView.backgroundColor = [UIColor whiteColor];
    _alertView.layer.cornerRadius = 12;
    _alertView.layer.masksToBounds = YES;
    _alertView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_alertView];

    NSMutableArray *constraints = [[NSMutableArray alloc] initWithCapacity:4];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_alertView(>=%f)]-(<=0)-[superview]", _alertViewHeight]
                                                                             options:NSLayoutFormatAlignAllCenterX
                                                                             metrics:nil
                                                                               views:@{@"_alertView":_alertView, @"superview": self.view}]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_alertView(300)]-(<=0)-[superview]"
                                                                             options:NSLayoutFormatAlignAllCenterY
                                                                             metrics:nil
                                                                               views:@{@"_alertView":_alertView, @"superview": self.view}]];
    [self.view addConstraints:constraints];
    [NSLayoutConstraint activateConstraints:constraints];
}


#pragma mark - Add outsize views

- (void)addTitleLabelIfNotExist {
    if (_titleLabel) {
        return;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.numberOfLines = 0;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_alertView addSubview:_titleLabel];

    NSMutableArray *constraints = [[NSMutableArray alloc] initWithCapacity:4];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_titleLabel]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_titleLabel)]];

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_titleLabel]-20-|"
                                                                             options:NSLayoutFormatAlignAllCenterY
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [_alertView addConstraints:constraints];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)addLabelWithConfigurationHandler:(void (^)(UILabel *))configurationHandler {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [_alertView addSubview:label];
    [_outsizeAddSubviews addObject:label];
    
    [self addConstrantsWithOutsideView:label viewHeight:@">=0"];
    
    if (configurationHandler) {
        configurationHandler(label);
    }
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler {
    UITextField *textField = [[UITextField alloc] init];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.font = [UIFont systemFontOfSize:16];
    textField.borderStyle = UITextBorderStyleLine;
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [_alertView addSubview:textField];
    [_outsizeAddSubviews addObject:textField];
    
    [self addConstrantsWithOutsideView:textField viewHeight:@">=0"];
    
    if (configurationHandler) {
        configurationHandler(textField);
    }
}

- (void)addScrollViewWithHeight:(CGFloat)height configurationHandler:(void (^)(UIScrollView *view))configurationHandler {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [_alertView addSubview:scrollView];
    [_outsizeAddSubviews addObject:scrollView];
        
    [self addConstrantsWithOutsideView:scrollView viewHeight:[NSString stringWithFormat:@"%f", height]];
    
    if (configurationHandler) {
        configurationHandler(scrollView);
    }
}

- (void)addViewWithHeight:(CGFloat)height configurationHandler:(void (^)(UIView *view))configurationHandler {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [_alertView addSubview:view];
    [_outsizeAddSubviews addObject:view];
        
    [self addConstrantsWithOutsideView:view viewHeight:[NSString stringWithFormat:@"%f", height]];
    
    if (configurationHandler) {
        configurationHandler(view);
    }
}

- (void)addConstrantsWithOutsideView:(UIView *)view viewHeight:(NSString *)viewHeight {
    NSMutableArray *constraints = [[NSMutableArray alloc] initWithCapacity:4];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[view]-20-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(view)]];
    
    if (_outsizeAddSubviews.count == 1) {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_titleLabel]-[view(%@)]-(>=56)-|", viewHeight]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_titleLabel, view)]];
    } else {
        UIView *upView = [_outsizeAddSubviews objectAtIndex:_outsizeAddSubviews.count - 2];
    
        for (NSLayoutConstraint *constraint in _alertView.constraints) {
            if (constraint.secondItem == upView && constraint.secondAttribute == NSLayoutAttributeBottom) {
                [NSLayoutConstraint deactivateConstraints:@[constraint]];
                [_alertView removeConstraint:constraint];
                break;
            }
        }
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[upView]-[view(%@)]-(>=56)-|", viewHeight]
                                                               options:0
                                                               metrics:nil
                                                                 views:NSDictionaryOfVariableBindings(upView, view)]];
    }

    [_alertView addConstraints:constraints];
    [NSLayoutConstraint activateConstraints:constraints];
}


#pragma mark - Action

- (void)addAction:(CMAlertAction *)action {
    [_actions addObject:action];
    
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = action.titleFont;
    button.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    button.translatesAutoresizingMaskIntoConstraints = NO;

    [button setTitle:action.title forState:UIControlStateNormal];
    UIColor *titleColor = action.enabled ? action.titleColor : action.disableTitleColor;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(touchDownButton:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(touchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(touchCancelButton:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragOutside];
    
    [_alertView addSubview:button];
    [_buttons addObject:button];
    
    __weak typeof(button) weakButton = button;
    [action setTitleColorHandler:^(UIColor *titleColor) {
        [weakButton setTitleColor:titleColor forState:UIControlStateNormal];
    }];
    
    [action setTitleFontHandler:^(UIFont *titleFont) {
        weakButton.titleLabel.font = titleFont;
    }];
    
    __weak typeof(action) weakAction = action;
    [action setEnableHandler:^(BOOL enable) {
        weakButton.enabled = enable;
        UIColor *titleColor = enable ? weakAction.titleColor : weakAction.disableTitleColor;
        [weakButton setTitleColor:titleColor forState:UIControlStateNormal];
    }];
    
    if (!_hLineView) {
        _hLineView = [[UIView alloc] init];
        [_alertView addSubview:_hLineView];
        _hLineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        _hLineView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray *vcs = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_hLineView(==0.5)]-44.5-|"
                                                               options:0
                                                               metrics:nil
                                                                 views:NSDictionaryOfVariableBindings(_hLineView)];
        
        NSArray *hcs = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_hLineView]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:NSDictionaryOfVariableBindings(_hLineView)];
        
        [_alertView addConstraints:vcs];
        [_alertView addConstraints:hcs];
        
        [NSLayoutConstraint activateConstraints:vcs];
        [NSLayoutConstraint activateConstraints:hcs];
    }
    
    NSArray *vcs = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==44)]|"
                                                           options:0
                                                           metrics:nil
                                                             views:NSDictionaryOfVariableBindings(button)];
    [_alertView addConstraints:vcs];
    [NSLayoutConstraint activateConstraints:vcs];
    
    
    if (_buttons.count == 1) {
        NSArray *hcs = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:NSDictionaryOfVariableBindings(button)];
        [_alertView addConstraints:hcs];
        [NSLayoutConstraint activateConstraints:hcs];
    } else {
        UIView *vLineView = [[UIView alloc] init];
        [_alertView addSubview:vLineView];
        vLineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        vLineView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray *linevcs = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[vLineView(==44)]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:NSDictionaryOfVariableBindings(vLineView)];
        [_alertView addConstraints:linevcs];
        [NSLayoutConstraint activateConstraints:linevcs];

        
        UIButton *oldLastButton = [_buttons objectAtIndex:_buttons.count -2];
        for (NSLayoutConstraint *constraint in _alertView.constraints) {
            if (constraint.secondItem == oldLastButton && constraint.secondAttribute == NSLayoutAttributeTrailing) {
                
                [NSLayoutConstraint deactivateConstraints:@[constraint]];
                [_alertView removeConstraint:constraint];
                break;
            }
        }
        
        NSArray *hcs = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[oldLastButton][vLineView(==0.5)][button(oldLastButton)]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:NSDictionaryOfVariableBindings(oldLastButton, vLineView, button)];
        
        [_alertView addConstraints:hcs];
        [NSLayoutConstraint activateConstraints:hcs];
    }
}


#pragma mark - 触发事件

- (void)touchDownButton:(UIButton *)button {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        button.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchCancelButton:(UIButton *)button {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        button.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchUpInsideButton:(UIButton *)button {
    NSInteger index = [_buttons indexOfObject:button];
    CMAlertAction *action = [_actions objectAtIndex:index];
    if (action.handler) {
        action.handler(action);
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        button.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

@end




