//
//  VNDumbLinkViewController.m
//  Vance
//
//  Created by Egor Molchanov on 23.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNDumbLinkViewController.h"
#import "VNDumbLinkViewController+Layout.h"
#import "VNDumbLinkViewController+UITextFieldDelegate.h"
#import "VNMediaSource.h"
#import "NSNotification+Name.h"


@interface VNDumbLinkViewController ()

@property (nonatomic, nullable) AVQueuePlayer * player;

@end


@implementation VNDumbLinkViewController


- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}


- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewTapWithRecognizer:)]];
    [self createViewsHierarchy];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLayoutConstraints];
    [self addObserversForNotifications];
    [self addTargetAndActionForControlsEvents];
    [self preparePlayer];
}


- (void)addObserversForNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleURLIsAvailableInPasteboardNotification:) name:VNURLIsAvailableFromPasteboard object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleURLIsUnavailableInPasteboardNotification:) name:VNURLIsUnavailableFromPasteboard object:nil];
}


- (void)addTargetAndActionForControlsEvents {
    [_linkTextField addTarget:self action:@selector(handleLinkTextFieldEditingChangedFromSender:) forControlEvents:UIControlEventEditingChanged];
    [_openButton addTarget:self action:@selector(handleOpenButtonTapFromSender:) forControlEvents:UIControlEventTouchUpInside];
    [_pasteButton addTarget:self action:@selector(handlePasteButtonTapFromSender:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)preparePlayer {
    _player = [AVQueuePlayer queuePlayerWithItems:@[]];
    _player.audiovisualBackgroundPlaybackPolicy = AVPlayerAudiovisualBackgroundPlaybackPolicyContinuesIfPossible;
    _playerViewController.player = _player;
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
    _openButton.enabled = sender.text && ![sender.text isEqualToString:@""];
}


- (void)handleOpenButtonTapFromSender:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString * URLString = _linkTextField.text;
    NSURL * URL = [NSURL URLWithString:URLString];
    if (URL) {
        [self handleYouTubeURL:URL];
    } else {
        [self presentAlertWithTitle:NSLocalizedString(@"Unable to load video", nil) message:NSLocalizedString(@"An error occurred", nil)];
    }
}


- (void)handlePasteButtonTapFromSender:(UIButton *)sender {
    NSURL * URLFromPasteboard = UIPasteboard.generalPasteboard.URL;
    if (URLFromPasteboard) {
        _linkTextField.text = URLFromPasteboard.absoluteString;
        _openButton.enabled = YES;
        [self handleYouTubeURL:URLFromPasteboard];
    }
}


- (void)handleYouTubeURL:(NSURL *)URL {
    __weak typeof(self) weak_self = self;
    [VNMediaSource mediaURLforYouTubePageURL:URL completionHandler:^(NSURL * _Nullable URL, NSError * _Nullable error) {
        __strong typeof(self) self = weak_self;
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            [self presentAlertWithTitle:NSLocalizedString(@"Unable to load video", nil) message:NSLocalizedString(@"An error occurred", nil)];
        } else {
            [self playVideoFromURL:URL];
        }
    }];
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


- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}


@end
