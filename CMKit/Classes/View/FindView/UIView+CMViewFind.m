//
//  UIView+CMViewFind.m
//  CMViewCategory
//
//  Created by chenjm on 2020/4/25.
//

#import "UIView+CMViewFind.h"

@implementation UIView (CMViewFind)

- (UITableView *)findTableView {
    return (UITableView *)[self tryToFindSuperviewWithClass:[UITableView class]];
}

- (UITableViewCell *)findTableViewCellFromSubview:(UIView *)subview {
    return (UITableViewCell *)[self tryToFindSuperviewWithClass:[UITableViewCell class]];
}

- (UICollectionView *)findCollectionViewFromSubview:(UIView *)subview {
    return (UICollectionView *)[self tryToFindSuperviewWithClass:[UICollectionView class]];
}

- (UICollectionViewCell *)findCollectionViewCellFromSubview:(UIView *)subview {
    return (UICollectionViewCell *)[self tryToFindSuperviewWithClass:[UICollectionViewCell class]];
}

- (UIView *)tryToFindSuperviewWithClass:(Class)aClass {
    UIView *view = self.superview;
    if (!view) {
        return nil;
    }
    
    if ([view isKindOfClass:aClass]) {
        return view;
    }
    
    return [self tryToFindSuperviewWithClass:aClass];
}

@end
