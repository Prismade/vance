//
//  VNVideosListViewController.h
//  Vance
//
//  Created by Egor Molchanov on 20.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import UIKit;

@class VNVideoCellModel;
@protocol VNVideosListDataSource, VNVideosListDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface VNVideosListViewController : UITableViewController

@property (nonatomic, weak) id<VNVideosListDataSource> dataSource;
@property (nonatomic, weak) id<VNVideosListDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
