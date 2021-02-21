//
//  CMViewpagerVideoCollectionViewCell.h
//  CMViewPager
//
//  Created by chenjm on 2019/12/23.
//  Copyright © 2019 chenjm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMViewpagerVideoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, copy) NSString *coverImageURLString; // 封面url
@property (nonatomic, copy) NSString *videoURLString; // 视频url
@end

NS_ASSUME_NONNULL_END
