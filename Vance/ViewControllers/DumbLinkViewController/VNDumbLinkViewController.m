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


NSString * const VNURLIsAvailableFromPasteboard = @"VNURLIsAvailableFromPasteboard";
NSString * const VNURLIsUnavailableFromPasteboard = @"VNURLIsUnavailableFromPasteboard";


@interface VNDumbLinkViewController ()

@property (nonatomic, nullable) AVQueuePlayer * player;
@property (nonatomic, nullable) AVPlayerViewController * playerViewController;
@property (nonatomic, nullable) NSDictionary * videos;
@property (nonatomic) VNVideoPageLoader * pageLoader;

@end


@implementation VNDumbLinkViewController


- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}


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
    _linkTextField.keyboardType = UIKeyboardTypeURL;
    [_linkTextField addTarget:self action:@selector(handleLinkTextFieldEditingChangedFromSender:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_linkTextField];

    _pasteButton = [[UIButton alloc] init];
    _pasteButton.translatesAutoresizingMaskIntoConstraints = NO;
    _pasteButton.enabled = NO;
    [self.view addSubview:_pasteButton];

    _openButton = [[UIButton alloc] init];
    _openButton.translatesAutoresizingMaskIntoConstraints = NO;
    _openButton.enabled = NO;
    [self.view addSubview:_openButton];

    UIButtonConfiguration * openButtonConfiguration = [UIButtonConfiguration filledButtonConfiguration];
    openButtonConfiguration.title = @"Open";
    _openButton.configuration = openButtonConfiguration;
    [_openButton addTarget:self action:@selector(handleOpenButtonTapFromSender:) forControlEvents:UIControlEventTouchUpInside];

    UIButtonConfiguration * pasteButtonConfiguration = [openButtonConfiguration copy];
    pasteButtonConfiguration.title = @"Use pasteboard";
    _pasteButton.configuration = pasteButtonConfiguration;
    [_pasteButton addTarget:self action:@selector(handlePasteButtonTapFromSender:) forControlEvents:UIControlEventTouchUpInside];

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
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleURLIsAvailableInPasteboardNotification:) name:VNURLIsAvailableFromPasteboard object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleURLIsUnavailableInPasteboardNotification:) name:VNURLIsUnavailableFromPasteboard object:nil];
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

        [_pasteButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16.0],
        [_pasteButton.topAnchor constraintEqualToAnchor:_linkTextField.bottomAnchor constant:16.0],
        [_pasteButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16.0],

        [_openButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16.0],
        [_openButton.topAnchor constraintEqualToAnchor:_pasteButton.bottomAnchor constant:16.0],
        [_openButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16.0],

        [_playerViewController.view.leadingAnchor constraintEqualToAnchor:_videoContainer.leadingAnchor],
        [_playerViewController.view.topAnchor constraintEqualToAnchor:_videoContainer.topAnchor],
        [_playerViewController.view.trailingAnchor constraintEqualToAnchor:_videoContainer.trailingAnchor],
        [_playerViewController.view.bottomAnchor constraintEqualToAnchor:_videoContainer.bottomAnchor]
    ]];
}


- (void)handleURLIsAvailableInPasteboardNotification:(NSNotification *)notification {
    _pasteButton.enabled = YES;
}


- (void)handleURLIsUnavailableInPasteboardNotification:(NSNotification *)notification {
    _pasteButton.enabled = NO;
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
    [self handleYouTubeURLString:URLString];
}


- (void)handlePasteButtonTapFromSender:(UIButton *)sender {
    NSURL * URLFromPasteboard = UIPasteboard.generalPasteboard.URL;
    if (URLFromPasteboard) {
        _linkTextField.text = URLFromPasteboard.absoluteString;
        _openButton.enabled = YES;
        [self handleYouTubeURL:URLFromPasteboard];
    }
}


- (void)handleYouTubeURLString:(NSString *)URLString {
    __weak VNDumbLinkViewController * weak_self = self;
    [_pageLoader loadWebPageWithVideoFromURLString:URLString completion:^(NSDictionary * _Nullable JSONObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weak_self handleWebPageResponseWithJSONObject:JSONObject error:error];
        });
    }];
}


- (void)handleYouTubeURL:(NSURL *)URL {
    __weak VNDumbLinkViewController * weak_self = self;
    [_pageLoader loadWebPageWithVideoFromURL:URL completion:^(NSDictionary * _Nullable JSONObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weak_self handleWebPageResponseWithJSONObject:JSONObject error:error];
        });
    }];
}


- (void)handleWebPageResponseWithJSONObject:(nullable NSDictionary *)JSONObject error:(nullable NSError *)error {
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Unable to load video" message:@"An error occurred" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
    } else if (JSONObject) {
        _videos = [VNVideoLinkExtractorForAllFormats extractVideoLinksFromJSONObject:JSONObject];
        NSURL * url = _videos[@"format_medium"] ?: _videos[@"adaptiveFormat_360p"];
        if (url) {
            [self playVideoFromURL:url];
        }
    } else {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Unable to load video" message:@"Can't find link for the video file on server" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
}


- (void)playVideoFromURL:(NSURL *)URL {
    AVAudioSession * session = AVAudioSession.sharedInstance;
    NSError * error;
    [session setActive:YES error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }

    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:URL];
    if ([_player canInsertItem:item afterItem:nil]) {
        [_player insertItem:item afterItem:nil];
    }

    NSLog(@"Playing: %@", URL.absoluteString);
    if (_player.items.count > 1) {
        [_player advanceToNextItem];
    }
    [_player play];
}


@end
