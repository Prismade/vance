//
//  VNDumbLinkViewController+Layout.m
//  Vance
//
//  Created by Egor Molchanov on 06.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNDumbLinkViewController+Layout.h"
#import "VNDumbLinkViewController+UITextFieldDelegate.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"


@implementation VNDumbLinkViewController (Layout)


- (void)createViewsHierarchy {
    self.videoContainer = [[UIView alloc] init];
    self.videoContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.videoContainer.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.videoContainer];

    self.hintLabel = [[UILabel alloc] init];
    self.hintLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.hintLabel.numberOfLines = 0;
    self.hintLabel.text = NSLocalizedString(@"Paste a link to a YouTube video here and hit the open button", nil);
    [self.view addSubview:self.hintLabel];

    self.linkTextField = [[UITextField alloc] init];
    self.linkTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.linkTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.linkTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.linkTextField.keyboardType = UIKeyboardTypeURL;
    self.linkTextField.delegate = self;
    [self.linkTextField addTarget:self action:@selector(handleLinkTextFieldEditingChangedFromSender:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.linkTextField];

    self.pasteButton = [[UIButton alloc] init];
    self.pasteButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.pasteButton.enabled = NO;
    [self.view addSubview:self.pasteButton];

    self.pasteStreamLinkButton = [[UIButton alloc] init];
    self.pasteStreamLinkButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.pasteStreamLinkButton.enabled = NO;
    [self.view addSubview:self.pasteStreamLinkButton];

    self.openButton = [[UIButton alloc] init];
    self.openButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.openButton.enabled = NO;
    [self.view addSubview:self.openButton];

    self.openStreamButton = [[UIButton alloc] init];
    self.openStreamButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.openStreamButton.enabled = NO;
    [self.view addSubview:self.openStreamButton];

    UIButtonConfiguration * openButtonConfiguration = [UIButtonConfiguration filledButtonConfiguration];
    openButtonConfiguration.title = NSLocalizedString(@"Open", nil);
    self.openButton.configuration = openButtonConfiguration;
    [self.openButton addTarget:self action:@selector(handleOpenButtonTapFromSender:) forControlEvents:UIControlEventTouchUpInside];

    UIButtonConfiguration * openStreamButtonConfiguration = [openButtonConfiguration copy];
    openStreamButtonConfiguration.title = NSLocalizedString(@"Open (Stream)", nil);
    self.openStreamButton.configuration = openStreamButtonConfiguration;
    [self.openStreamButton addTarget:self action:@selector(handleOpenStreamButtonTapFromSender:) forControlEvents:UIControlEventTouchUpInside];

    UIButtonConfiguration * pasteButtonConfiguration = [openButtonConfiguration copy];
    pasteButtonConfiguration.title = NSLocalizedString(@"Use pasteboard", nil);
    self.pasteButton.configuration = pasteButtonConfiguration;
    [self.pasteButton addTarget:self action:@selector(handlePasteButtonTapFromSender:) forControlEvents:UIControlEventTouchUpInside];

    UIButtonConfiguration * pasteStreamLinkButtonConfiguration = [openButtonConfiguration copy];
    pasteStreamLinkButtonConfiguration.title = NSLocalizedString(@"Use pasteboard (Stream)", nil);
    self.pasteStreamLinkButton.configuration = pasteStreamLinkButtonConfiguration;
    [self.pasteStreamLinkButton addTarget:self action:@selector(handlePasteStreamLinkButtonTapFromSender:) forControlEvents:UIControlEventTouchUpInside];

    self.playerViewController = [[AVPlayerViewController alloc] init];
    [self addChildViewController:self.playerViewController];
    self.playerViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoContainer addSubview:self.playerViewController.view];
    [self.playerViewController didMoveToParentViewController:self];
}


- (void)setLayoutConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.videoContainer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.videoContainer.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.videoContainer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.videoContainer.heightAnchor constraintEqualToAnchor:self.videoContainer.widthAnchor multiplier:9.0 / 16.0],

        [self.hintLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16.0],
        [self.hintLabel.topAnchor constraintEqualToAnchor:self.videoContainer.bottomAnchor constant:20.0],
        [self.hintLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16.0],

        [self.linkTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16.0],
        [self.linkTextField.topAnchor constraintEqualToAnchor:self.hintLabel.bottomAnchor constant:16.0],
        [self.linkTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16.0],

        [self.pasteButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16.0],
        [self.pasteButton.topAnchor constraintEqualToAnchor:self.linkTextField.bottomAnchor constant:16.0],
        [self.pasteButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16.0],

        [self.pasteStreamLinkButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16.0],
        [self.pasteStreamLinkButton.topAnchor constraintEqualToAnchor:self.pasteButton.bottomAnchor constant:16.0],
        [self.pasteStreamLinkButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16.0],

        [self.openButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16.0],
        [self.openButton.topAnchor constraintEqualToAnchor:self.pasteStreamLinkButton.bottomAnchor constant:16.0],
        [self.openButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16.0],

        [self.openStreamButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16.0],
        [self.openStreamButton.topAnchor constraintEqualToAnchor:self.openButton.bottomAnchor constant:16.0],
        [self.openStreamButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16.0],

        [self.playerViewController.view.leadingAnchor constraintEqualToAnchor:self.videoContainer.leadingAnchor],
        [self.playerViewController.view.topAnchor constraintEqualToAnchor:self.videoContainer.topAnchor],
        [self.playerViewController.view.trailingAnchor constraintEqualToAnchor:self.videoContainer.trailingAnchor],
        [self.playerViewController.view.bottomAnchor constraintEqualToAnchor:self.videoContainer.bottomAnchor]
    ]];
}


@end

#pragma clang diagnostic pop
