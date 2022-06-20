//
//  VNSubscriptionsFeedViewController.m
//  Vance
//
//  Created by Egor Molchanov on 20.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNSubscriptionsFeedViewController.h"
#import "VNSubscriptionsFeedViewController+VNVideosListDataSource.h"
#import "VNVideosListViewController.h"
#import "VNVideoCellModel.h"


@interface VNSubscriptionsFeedViewController ()

@end


@implementation VNSubscriptionsFeedViewController


- (void)loadView {
    self.view = [[UIView alloc] init];
    _videosList = [[VNVideosListViewController alloc] init];
    _videosList.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_videosList willMoveToParentViewController:self];
    
    [self.view addSubview:_videosList.view];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [_videosList didMoveToParentViewController:self];
    _videosList.dataSource = self;
    _sampleModels = @[
        [[VNVideoCellModel alloc] initWithTitle:@"Rick Astley - Never Gonna Give You Up (Official Music Video)" info:@"Rick Astley • 1.2B views • 12 years ago" thumbnail:nil avatar:nil],
        [[VNVideoCellModel alloc] initWithTitle:@"Rick Astley - Never Gonna Give You Up (Official Music Video)" info:@"Rick Astley • 1.2B views • 12 years ago" thumbnail:nil avatar:nil],
        [[VNVideoCellModel alloc] initWithTitle:@"Rick Astley - Never Gonna Give You Up (Official Music Video)" info:@"Rick Astley • 1.2B views • 12 years ago" thumbnail:nil avatar:nil],
        [[VNVideoCellModel alloc] initWithTitle:@"Rick Astley - Never Gonna Give You Up (Official Music Video)" info:@"Rick Astley • 1.2B views • 12 years ago" thumbnail:nil avatar:nil],
        [[VNVideoCellModel alloc] initWithTitle:@"Rick Astley - Never Gonna Give You Up (Official Music Video)" info:@"Rick Astley • 1.2B views • 12 years ago" thumbnail:nil avatar:nil],
        [[VNVideoCellModel alloc] initWithTitle:@"Rick Astley - Never Gonna Give You Up (Official Music Video)" info:@"Rick Astley • 1.2B views • 12 years ago" thumbnail:nil avatar:nil],
        [[VNVideoCellModel alloc] initWithTitle:@"Rick Astley - Never Gonna Give You Up (Official Music Video)" info:@"Rick Astley • 1.2B views • 12 years ago" thumbnail:nil avatar:nil],
        [[VNVideoCellModel alloc] initWithTitle:@"Rick Astley - Never Gonna Give You Up (Official Music Video)" info:@"Rick Astley • 1.2B views • 12 years ago" thumbnail:nil avatar:nil],
        [[VNVideoCellModel alloc] initWithTitle:@"Rick Astley - Never Gonna Give You Up (Official Music Video)" info:@"Rick Astley • 1.2B views • 12 years ago" thumbnail:nil avatar:nil],
        [[VNVideoCellModel alloc] initWithTitle:@"Rick Astley - Never Gonna Give You Up (Official Music Video)" info:@"Rick Astley • 1.2B views • 12 years ago" thumbnail:nil avatar:nil]
    ];
    CGFloat statusBar = ((UIWindowScene *)[UIApplication.sharedApplication.connectedScenes anyObject]).statusBarManager.statusBarFrame.size.height;
    CGFloat navBar = self.navigationController.navigationBar.frame.size.height;
    CGFloat inset = statusBar + navBar;
    UIEdgeInsets insets = UIEdgeInsetsMake(inset, 0.0, 0.0, 0.0);
    _videosList.tableView.contentInset = insets;
    _videosList.tableView.scrollIndicatorInsets = insets;
}


- (void)setLayoutConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.view.leadingAnchor constraintEqualToAnchor:_videosList.view.leadingAnchor],
        [self.view.topAnchor constraintEqualToAnchor:_videosList.view.topAnchor],
        [self.view.trailingAnchor constraintEqualToAnchor:_videosList.view.trailingAnchor],
        [self.view.bottomAnchor constraintEqualToAnchor:_videosList.view.bottomAnchor],
    ]];
}


@end
