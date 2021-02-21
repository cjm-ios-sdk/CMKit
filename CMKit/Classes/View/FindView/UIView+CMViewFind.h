//
//  UIView+CMViewFind.h
//  CMViewCategory
//
//  Created by chenjm on 2020/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CMViewFind)

- (UITableView *)findTableView;

- (UITableViewCell *)findTableViewCellFromSubview:(UIView *)subview;

- (UICollectionView *)findCollectionViewFromSubview:(UIView *)subview;

- (UICollectionViewCell *)findCollectionViewCellFromSubview:(UIView *)subview;

- (UIView *)tryToFindSuperviewWithClass:(Class)aClass;

@end

NS_ASSUME_NONNULL_END
