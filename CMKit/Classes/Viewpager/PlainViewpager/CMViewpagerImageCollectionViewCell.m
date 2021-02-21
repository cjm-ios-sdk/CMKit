//
//  CMViewpagerImageCollectionViewCell.m
//
//  Created by chenjm on 19/12/23.
//  Copyright © 2019年 chenjm. All rights reserved.
//

#import "CMViewpagerImageCollectionViewCell.h"

@implementation CMViewpagerImageCollectionViewCell

- (instancetype)init {
	self = [super init];
	if (self) {
		[self initial];
	}
	
	return self;
}

- (void)initial {
	_imgView = ({
		UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:imgView];
		imgView.contentMode = UIViewContentModeScaleAspectFill;
		imgView;
	});
}

- (void)layoutSubviews {
	[super layoutSubviews];
	_imgView.frame = self.bounds;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _imgView.image = nil;
}

@end
