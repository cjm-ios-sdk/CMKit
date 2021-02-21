//
//  CMViewpagerVideoCollectionViewCell.m
//  CMViewPager
//
//  Created by chenjm on 2019/12/23.
//  Copyright © 2019 chenjm. All rights reserved.
//

#import "CMViewpagerVideoCollectionViewCell.h"

@implementation CMViewpagerVideoCollectionViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initial];
    }
    
    return self;
}

- (void)initial {
    _playerLayer = ({
        AVPlayerLayer *playerLayer = [[AVPlayerLayer alloc] init];
        [self.contentView.layer addSublayer:playerLayer];
        playerLayer.frame = self.bounds;
        playerLayer;
    });
    
    _coverImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView;
    });
    
    _playButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self.contentView addSubview:button];
        button;
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _playerLayer.frame = self.bounds;
    _coverImageView.frame = self.bounds;
    _playButton.center = self.center;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _coverImageView.image = nil;
}



@end
