//
//  VNSubscriptionsFeedViewController+VNVideosListDataSource.m
//  Vance
//
//  Created by Egor Molchanov on 20.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNSubscriptionsFeedViewController+VNVideosListDataSource.h"
#import "VNVideosListDataSource.h"


@implementation VNSubscriptionsFeedViewController (VNVideosListDataSource)


- (NSInteger)numberOfVideos {
    return self.sampleModels.count;
}


- (VNVideoCellModel *)videoList:(UITableView *)videoList modelForIndex:(NSInteger)index {
    return self.sampleModels[index];
}


@end
