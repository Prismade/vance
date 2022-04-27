//
//  VNDumbLinkViewController.h
//  Vance
//
//  Created by Egor Molchanov on 23.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import UIKit;
@import AVKit;
@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const VNURLIsAvailableFromPasteboard;
FOUNDATION_EXPORT NSString * const VNURLIsUnavailableFromPasteboard;

@interface VNDumbLinkViewController : UIViewController

@property (nonatomic) UIView * videoContainer;
@property (nonatomic) UILabel * hintLabel;
@property (nonatomic) UITextField * linkTextField;
@property (nonatomic) UIButton * pasteButton;
@property (nonatomic) UIButton * openButton;

@end

NS_ASSUME_NONNULL_END
