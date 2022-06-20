//
//  VNSubscriptionsFeedViewController.h
//  Vance
//
//  Created by Egor Molchanov on 20.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import UIKit;

@class VNVideosListViewController, VNVideoCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface VNSubscriptionsFeedViewController : UIViewController

@property (nonatomic) VNVideosListViewController * videosList;
@property (nonatomic) NSArray<VNVideoCellModel *> * sampleModels;

@end

NS_ASSUME_NONNULL_END
