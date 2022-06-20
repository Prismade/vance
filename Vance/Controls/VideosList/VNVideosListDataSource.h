//
//  VNVideosListDataSource.h
//  Vance
//
//  Created by Egor Molchanov on 21.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol VNVideosListDataSource <NSObject>

- (NSInteger)numberOfVideos;
- (VNVideoCellModel *)videoList:(UITableView *)videoList modelForIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
