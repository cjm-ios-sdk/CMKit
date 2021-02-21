//
//  CMViewpager.h
//
//  Created by jiemin on 19/12/23.
//  Copyright © 2019年 jiemin. All rights reserved.
//

#import "CMViewpager.h"
#import "CMViewpagerImageCollectionViewCell.h"
#import "CMViewpagerVideoCollectionViewCell.h"
#import <CMKit/CMNetwork.h>

#define SLVP_VIEW_W(view)        CGRectGetWidth(view.frame)

@implementation CMViewpager {
	NSInteger _cellIndex;
	
	UICollectionView *_collectionView;
	
	NSTimer *_timer;
}


#pragma mark - 重写父类方法

- (void)removeFromSuperview {
	[super removeFromSuperview];
	
	[self stopTimer];
}

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	
	[self startTimerWithImmediate:NO];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
    _tableView.frame = self.bounds;
    
    [_tableView reloadData];
    _cellIndex = 1;
    _tableView.contentOffset = CGPointMake(0, SLVP_VIEW_W(self));
    [self startTimerWithImmediate:NO];
}


#pragma mark - 初始化方法

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initial];
	}
	
	return self;
}

- (instancetype)initWithSources:(NSArray *)sources {
	self = [super init];
	if (self) {
		_sources = sources;
		[self initial];
	}
	
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame sources:(NSArray *)sources {
	self = [super initWithFrame:frame];
	if (self) {
		_sources = sources;
		[self initial];
	}
	
	return self;
}

- (void)initial {
	_cellIndex = 1;
	_imageContentMode = UIViewContentModeScaleAspectFill;
	_tableViewBackgroundColor = [UIColor whiteColor];
	_imageBackgroundColor = [UIColor whiteColor];
	_isAutoRun = YES;
    _showNetworkImageAnimtedDuration = 0.5;
    
	self.clipsToBounds = YES;
	self.backgroundColor = [UIColor whiteColor];

	
	_collectionView = ({
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.itemSize = self.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        
		UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
		[self addSubview:collectionView];
        
        [collectionView registerClass:[CMViewpagerImageCollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
        [collectionView registerClass:[CMViewpagerVideoCollectionViewCell class] forCellWithReuseIdentifier:@"videoCell"];
		collectionView.delegate = self;
		collectionView.dataSource = self;
		collectionView.transform = CGAffineTransformMakeRotation(-M_PI_2);
		collectionView.pagingEnabled = YES;
		collectionView.contentOffset = CGPointMake(0, SLVP_VIEW_W(self));
		collectionView.showsVerticalScrollIndicator = NO;
		collectionView.showsHorizontalScrollIndicator = NO;
		collectionView.scrollsToTop = NO;
		collectionView;
	});
	
	// 只有一页时不滚动
	if (_sources.count <= 1) {
		_tableView.scrollEnabled = NO;
	}
	
	[self startTimerWithImmediate:NO];
}


#pragma mark - 移除定时器

- (void)stopTimer {
	if (!_timer) {
		return;
	}
	
	[_timer invalidate];
	_timer = nil;
}


#pragma mark - 开启定时器

- (void)startTimerWithImmediate:(BOOL)immediate {
	
	[self stopTimer];
	
	if (immediate) {
		[self turnWithTimer];
	}
	
	_timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(turnWithTimer) userInfo:nil repeats:YES];
}


#pragma mark - index 转化

- (NSInteger)imgIndexWithCellIndex:(NSInteger)cellIndex {
	NSAssert(cellIndex >= 0 && cellIndex < _sources.count + 2, @"cellIndex error!");
	NSInteger imgIndex = 0;
	
	if (cellIndex == 0) {
		imgIndex = _sources.count - 1;
	} else if (cellIndex == _sources.count + 1) {
		imgIndex = 0;
	} else {
		imgIndex = (cellIndex - 1) % _sources.count;
	}
	
	return imgIndex;
}


#pragma mark - 定时器调用方法

- (void)turnWithTimer {
	if (!_isAutoRun || _sources.count <= 1) {
		[self stopTimer];
		
		return;
	}
	
	int offsetW = _tableView.contentOffset.y / SLVP_VIEW_W(self);
	
	CGPoint newOffset = CGPointMake(0,  (offsetW + 1) * SLVP_VIEW_W(self));
	
	[_tableView setContentOffset:newOffset animated:YES];
}


#pragma mark - 跳转到指定页

- (void)turnToIndex:(NSInteger)index {
    CGPoint point = self.tableView.contentOffset;
    point.y = self.bounds.size.width * (index+1);
    self.tableView.contentOffset = point;
}


#pragma mark - setTableView Offset

- (void)setTableViewOffset {
	if((_tableView.contentSize.height - _tableView.contentOffset.y) < SLVP_VIEW_W(self) + 0.1){
		_tableView.contentOffset = CGPointMake(0, SLVP_VIEW_W(self));
	} else if (_tableView.contentOffset.y < 0.1){
		_tableView.contentOffset = CGPointMake(0, SLVP_VIEW_W(self) * _sources.count);
	} else {
		
	}
}


#pragma mark - setter 方法

- (void)setIsAutoRun:(BOOL)isAutoRun {
	_isAutoRun = isAutoRun;
	if (_isAutoRun) {
		[self startTimerWithImmediate:NO];
	} else {
		[self stopTimer];
	}
}

-(void)settableViewBackgroundColor:(UIColor *)tableViewBackgroundColor {
	_tableViewBackgroundColor = tableViewBackgroundColor;
	_tableView.backgroundColor = _tableViewBackgroundColor;
}

- (void)setImageBackgroundColor:(UIColor *)imageBackgroundColor {
	_imageBackgroundColor = imageBackgroundColor;
	[_tableView reloadData];
}

- (void)setImageContentMode:(UIViewContentMode)imageContentMode {
	_imageContentMode = imageContentMode;
	[_tableView reloadData];
}

- (void)setSources:(NSArray *)sources {
	_sources = sources;
	
	if (_sources.count <= 1) {
		_tableView.scrollEnabled = NO;
	} else {
		_tableView.scrollEnabled = YES;
	}
	
	[_tableView reloadData];
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(viewpager:didSelectPageAtIndex:)]) {
        [_delegate viewpager:self didSelectPageAtIndex:[self imgIndexWithCellIndex:indexPath.row]];
    }
}


#pragma mark - UITableViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *path = self.sources[indexPath.row];
    NSString *lowercasePath = [path lowercaseString];
    if ([lowercasePath hasSuffix:@"mp4"]
        || [lowercasePath hasSuffix:@"3gp"]
        || [lowercasePath hasSuffix:@"flv"]
        || [lowercasePath hasSuffix:@"rm"]
        || [lowercasePath hasSuffix:@"rmvb"]
        || [lowercasePath hasSuffix:@"mov"]
        || [lowercasePath hasSuffix:@"avi"]) {
        CMViewpagerImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
        cell.clipsToBounds = YES;
        //TODO:
        return cell;
    } else {
        CMViewpagerImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        cell.clipsToBounds = YES;
        cell.imgView.contentMode = self.imageContentMode;
        cell.imgView.backgroundColor = self.imageBackgroundColor;
        
        if (0 != _sources.count) {
            NSInteger imgIndex = [self imgIndexWithCellIndex:indexPath.row];
            
            imgIndex = imgIndex % self.sources.count;
            
            NSString *imgStr = self.sources[imgIndex];
            
            if (imgStr && [imgStr hasPrefix:@"http"]) {
                [cell.imgView setCMNetwork_ImageWithURLString:imgStr animatedDuration:_showNetworkImageAnimtedDuration];
            } else if ([imgStr containsString:@"/"]) {
                [cell.imgView setImage:[UIImage imageWithContentsOfFile:imgStr]];
            } else {
                [cell.imgView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgStr ofType:nil]]];
            }
        }
        
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _sources.count + 2;
}


#pragma mark - scrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self stopTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self setTableViewOffset];
	
	
	if (_delegate && [_delegate respondsToSelector:@selector(viewpager:atIndex:)]) {
		NSInteger index = scrollView.contentOffset.y / SLVP_VIEW_W(self);
		[_delegate viewpager:self atIndex:[self imgIndexWithCellIndex:index]];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self setTableViewOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[self startTimerWithImmediate:NO];
}


@end
