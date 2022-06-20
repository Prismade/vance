//
//  VNVideoListTableViewCell.m
//  Vance
//
//  Created by Egor Molchanov on 20.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNVideosListTableViewCell.h"
#import "VNVideoCellModel.h"


const CGFloat VNChannelAvatarWidth = 50.0;


@implementation VNVideosListTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createViewsHierarchy];
        [self setLayoutConstraints];
    }
    return self;
}


- (void)createViewsHierarchy {
    _thumbnailView = [[UIImageView alloc] init];
    _thumbnailView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_thumbnailView];
    
    _avatarView = [[UIImageView alloc] init];
    _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    _avatarView.clipsToBounds = YES;
    _avatarView.layer.cornerRadius = VNChannelAvatarWidth / 2.0;
    [self.contentView addSubview:_avatarView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightBold];
    [self.contentView addSubview:_titleLabel];
    
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _infoLabel.numberOfLines = 1;
    _infoLabel.font = [UIFont systemFontOfSize:14.0];
    _infoLabel.textColor = UIColor.grayColor;
    [self.contentView addSubview:_infoLabel];
}


- (void)setLayoutConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [_thumbnailView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [_thumbnailView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [_thumbnailView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [_thumbnailView.heightAnchor constraintEqualToAnchor:_thumbnailView.widthAnchor multiplier:9.0 / 16.0],
        
        [_avatarView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8.0],
        [_avatarView.topAnchor constraintEqualToAnchor:_thumbnailView.bottomAnchor constant:8.0],
        [_avatarView.widthAnchor constraintEqualToConstant:VNChannelAvatarWidth],
        [_avatarView.widthAnchor constraintEqualToAnchor:_avatarView.heightAnchor],
        
        [_titleLabel.leadingAnchor constraintEqualToAnchor:_avatarView.trailingAnchor constant:8.0],
        [_titleLabel.topAnchor constraintEqualToAnchor:_thumbnailView.bottomAnchor constant:8.0],
        [_titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8.0],
        
        [_infoLabel.leadingAnchor constraintEqualToAnchor:_titleLabel.leadingAnchor],
        [_infoLabel.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:4.0],
        [_infoLabel.trailingAnchor constraintEqualToAnchor:_titleLabel.trailingAnchor],
        [_infoLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-24.0],
    ]];
}


- (void)configureWithCellModel:(VNVideoCellModel *)model {
    _thumbnailView.image = model.thumbnail ?: [UIImage imageNamed:@"SampleThumbnail"];
    _avatarView.image = model.avatar ?: [UIImage imageNamed:@"SampleAvatar"];
    _titleLabel.text = model.title;
    _infoLabel.text = model.info;
}


@end
