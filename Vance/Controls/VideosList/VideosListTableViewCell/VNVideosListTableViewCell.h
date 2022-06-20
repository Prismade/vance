//
//  VNVideosListTableViewCell.h
//  Vance
//
//  Created by Egor Molchanov on 20.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import UIKit;

@class VNVideoCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface VNVideosListTableViewCell : UITableViewCell

@property (nonatomic) UIImageView * thumbnailView;
@property (nonatomic) UIImageView * avatarView;
@property (nonatomic) UILabel * titleLabel;
@property (nonatomic) UILabel * infoLabel;

- (void)configureWithCellModel:(VNVideoCellModel *)model;

@end

NS_ASSUME_NONNULL_END
