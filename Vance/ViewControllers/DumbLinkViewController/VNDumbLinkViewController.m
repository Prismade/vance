//
//  VNDumbLinkViewController.m
//  Vance
//
//  Created by Egor Molchanov on 23.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNDumbLinkViewController.h"
#import "VNVideoPageLoader.h"
#import "VNVideoLinkExtractorForAllFormats.h"


@interface VNDumbLinkViewController ()

@property (nonatomic, nullable) AVQueuePlayer * player;
@property (nonatomic, nullable) AVPlayerViewController * playerViewController;
@property (nonatomic, nullable) NSDictionary * videos;
@property (nonatomic) VNVideoPageLoader * pageLoader;

@end


@implementation VNDumbLinkViewController


- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewTapWithRecognizer:)]];

    _videoContainer = [[UIView alloc] init];
    _videoContainer.translatesAutoresizingMaskIntoConstraints = NO;
    _videoContainer.backgroundColor = UIColor.blackColor;
    [self.view addSubview:_videoContainer];

    _hintLabel = [[UILabel alloc] init];
    _hintLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _hintLabel.numberOfLines = 0;
    _hintLabel.text = @"Paste a link to a YouTube video here and hit the open button";
    [self.view addSubview:_hintLabel];

    _linkTextField = [[UITextField alloc] init];
    _linkTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _linkTextField.borderStyle = UITextBorderStyleRoundedRect;
    _linkTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_linkTextField addTarget:self action:@selector(handleLinkTextFieldEditingChangedFromSender:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_linkTextField];

    _openButton = [[UIButton alloc] init];
    _openButton.translatesAutoresizingMaskIntoConstraints = NO;
    _openButton.enabled = NO;
    [self.view addSubview:_openButton];

    UIButtonConfiguration * configuration = [UIButtonConfiguration filledButtonConfiguration];
    configuration.title = @"Open";
    _openButton.configuration = configuration;
    [_openButton addTarget:self action:@selector(handleOpenButtonTapFromSender:) forControlEvents:UIControlEventTouchUpInside];

    _playerViewController = [[AVPlayerViewController alloc] init];
    [self addChildViewController:_playerViewController];
    _playerViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_videoContainer addSubview:self.playerViewController.view];
    [self.playerViewController didMoveToParentViewController:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self instantiateConstraints];
    _player = [AVQueuePlayer queuePlayerWithItems:@[]];
    _playerViewController.player = _player;
    _videos = nil;
    _pageLoader = [[VNVideoPageLoader alloc] init];
}


- (void)instantiateConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [_videoContainer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_videoContainer.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [_videoContainer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [_videoContainer.heightAnchor constraintEqualToAnchor:_videoContainer.widthAnchor multiplier:9.0 / 16.0],

        [_hintLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16.0],
        [_hintLabel.topAnchor constraintEqualToAnchor:_videoContainer.bottomAnchor constant:20.0],
        [_hintLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16.0],

        [_linkTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16.0],
        [_linkTextField.topAnchor constraintEqualToAnchor:_hintLabel.bottomAnchor constant:16.0],
        [_linkTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16.0],

        [_openButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16.0],
        [_openButton.topAnchor constraintEqualToAnchor:_linkTextField.bottomAnchor constant:16.0],
        [_openButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16.0],

        [_playerViewController.view.leadingAnchor constraintEqualToAnchor:_videoContainer.leadingAnchor],
        [_playerViewController.view.topAnchor constraintEqualToAnchor:_videoContainer.topAnchor],
        [_playerViewController.view.trailingAnchor constraintEqualToAnchor:_videoContainer.trailingAnchor],
        [_playerViewController.view.bottomAnchor constraintEqualToAnchor:_videoContainer.bottomAnchor]
    ]];
}


- (void)handleViewTapWithRecognizer:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}


- (void)handleLinkTextFieldEditingChangedFromSender:(UITextField *)sender {
    if (sender.text && ![sender.text isEqualToString:@""]) {
        _openButton.enabled = YES;
    } else {
        _openButton.enabled = NO;
    }
}


- (void)handleOpenButtonTapFromSender:(UIButton *)sender {
    [self.view endEditing:YES];
    _videos = nil;

    NSString * URLString = _linkTextField.text;
    __weak VNDumbLinkViewController * weak_self = self;
    [_pageLoader loadWebPageWithVideoFromURLString:URLString completion:^(NSDictionary * _Nullable JSONObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Unable to load video" message:@"An error occurred" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
        } else if (JSONObject) {
            weak_self.videos = [VNVideoLinkExtractorForAllFormats extractVideoLinksFromJSONObject:JSONObject];
            NSURL * url = weak_self.videos[@"format_medium"] ?: weak_self.videos[@"adaptiveFormat_360p"];
            if (url) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weak_self playVideoFromURL:url];
                });
            }
        } else {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Unable to load video" message:@"Can't find link for the video file on server" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
    }];
}


- (void)playVideoFromURL:(NSURL *)url {
    AVAudioSession * session = AVAudioSession.sharedInstance;
    NSError * error;
    [session setActive:YES error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }

    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:url];
    if ([_player canInsertItem:item afterItem:nil]) {
        [_player insertItem:item afterItem:nil];
    }

    NSLog(@"Playing: %@", url.absoluteString);
    if (_player.items.count > 1) {
        [_player advanceToNextItem];
    }
    [_player play];
}


@end
