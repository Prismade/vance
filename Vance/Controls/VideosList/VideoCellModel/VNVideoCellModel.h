//
//  VNVideoCellModel.h
//  Vance
//
//  Created by Egor Molchanov on 20.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface VNVideoCellModel : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * info;
@property (nonatomic, nullable) UIImage *thumbnail;
@property (nonatomic, nullable) UIImage * avatar;

- (instancetype)initWithTitle:(NSString *)title info:(NSString *)info thumbnail:(nullable UIImage *)thumbnail avatar:(nullable UIImage *)avatar;

@end

NS_ASSUME_NONNULL_END
