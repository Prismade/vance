//
//  VNVideoCellModel.m
//  Vance
//
//  Created by Egor Molchanov on 20.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNVideoCellModel.h"


@implementation VNVideoCellModel


- (instancetype)initWithTitle:(NSString *)title info:(NSString *)info thumbnail:(UIImage *)thumbnail avatar:(UIImage *)avatar {
    if (self = [super init]) {
        _title = title;
        _info = info;
        _thumbnail = thumbnail;
        _avatar = avatar;
    }
    return self;
}


@end
