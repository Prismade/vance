//
//  VNVideosListDelegate.h
//  Vance
//
//  Created by Egor Molchanov on 21.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol VNVideosListDelegate <NSObject>


- (void)videoList:(UITableView *)videoList didSelectVideoAtIndex:(NSInteger)index;
- (void)videoList:(UITableView *)videoList didLongTapOnVideoAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
