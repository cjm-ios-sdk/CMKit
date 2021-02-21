//
//  CMViewpager.h
//
//  版本：1.0.0 （build 1.0.0.0）
//
//  Created by jiemin on 19/12/23.
//  Copyright © 2019年 jiemin. All rights reserved.
//

#import <UIKit/UIKit.h>



/**  使用demo
 NSArray *sources = @[@"page1.jpg",
 @"page2.jpg",
 @"page3.jpg",
 @"page4.jpg",
 @"page5.jpg"];
 
 CMViewpager *viewPager = [[CMViewpager alloc] initWithFrame:CGRectMake(0, 0, 350, 600) sources:sources];
 [self.view addSubview:viewPager];
 viewPager.center = self.view.center;
 
 */



@class CMViewpager;

@protocol CMViewpagerDelegate <NSObject>

- (void)viewpager:(CMViewpager *)viewpager atIndex:(NSInteger)index;
- (void)viewpager:(CMViewpager *)viewpager didSelectPageAtIndex:(NSInteger)index;

@end



@interface CMViewpager : UIView<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIColor *tableViewBackgroundColor;
@property (nonatomic, strong) UIColor *imageBackgroundColor;
@property (nonatomic, assign) UIViewContentMode imageContentMode;
@property (nonatomic, strong) NSArray *sources;	                        // 图片/视频的路径
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id <CMViewpagerDelegate> delegate;
@property (nonatomic, assign) BOOL isAutoRun;		                    // default YES，若NO，不自动轮播， 若YES自动轮播。
@property (nonatomic, assign) CGFloat showNetworkImageAnimtedDuration;  // 显示网络图片的动画时长，默认0.5 单位：s

- (instancetype)initWithFrame:(CGRect)frame sources:(NSArray *)sources;
- (instancetype)initWithSources:(NSArray *)sources;

- (void)initial;

- (NSInteger)imgIndexWithCellIndex:(NSInteger)cellIndex;

- (UICollectionViewCell *)cellForPageAtIndex:(NSInteger)index;

/**
 * @brief 跳转到指定页面
 */
- (void)turnToIndex:(NSInteger)index;

@end



