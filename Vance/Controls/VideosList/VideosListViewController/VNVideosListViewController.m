//
//  VNVideosListViewController.m
//  Vance
//
//  Created by Egor Molchanov on 20.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNVideosListViewController.h"
#import "VNVideosListDataSource.h"
#import "VNVideosListDelegate.h"
#import "VNVideosListTableViewCell.h"
#import "VNVideoCellModel.h"


NSString * const VNVideoListCellReuseIdentifier = @"VNVideoListCell";


@interface VNVideosListViewController ()

@property (nonatomic) UILongPressGestureRecognizer * longPressRecognizer;

@end


@implementation VNVideosListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[VNVideosListTableViewCell class] forCellReuseIdentifier:VNVideoListCellReuseIdentifier];
    
    _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTapFromSender:)];
    [self.tableView addGestureRecognizer:_longPressRecognizer];
}


- (void)handleLongTapFromSender:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:[sender locationInView:self.tableView]];
        [_delegate videoList:self.tableView didLongTapOnVideoAtIndex:indexPath.row];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource numberOfVideos] ?: 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VNVideosListTableViewCell * cell = (VNVideosListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:VNVideoListCellReuseIdentifier forIndexPath:indexPath];
    VNVideoCellModel * model = [_dataSource videoList:tableView modelForIndex:indexPath.row];
    if (model) {
        [cell configureWithCellModel:model];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate videoList:tableView didSelectVideoAtIndex:indexPath.row];
}


@end
