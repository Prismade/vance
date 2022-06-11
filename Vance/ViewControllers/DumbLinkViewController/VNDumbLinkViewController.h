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

@interface VNDumbLinkViewController : UIViewController

@property (nonatomic, nullable) AVPlayerViewController * playerViewController;
@property (nonatomic) UIView * videoContainer;
@property (nonatomic) UILabel * hintLabel;
@property (nonatomic) UITextField * linkTextField;
@property (nonatomic) UIButton * pasteButton;
@property (nonatomic) UIButton * pasteStreamLinkButton;
@property (nonatomic) UIButton * openButton;
@property (nonatomic) UIButton * openStreamButton;

@end

NS_ASSUME_NONNULL_END
