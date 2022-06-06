//
//  VNDumbLinkViewController.m
//  Vance
//
//  Created by Egor Molchanov on 23.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNDumbLinkViewController.h"
#import "VNDumbLinkViewController+Layout.h"
#import "VNVideoPageLoader.h"
#import "VNVideoLinkExtractorForAllFormats.h"


NSString * const VNURLIsAvailableFromPasteboard = @"VNURLIsAvailableFromPasteboard";
NSString * const VNURLIsUnavailableFromPasteboard = @"VNURLIsUnavailableFromPasteboard";


@interface VNDumbLinkViewController ()

@property (nonatomic, nullable) AVQueuePlayer * player;
@property (nonatomic, nullable) NSDictionary<NSString *, NSURL *> * videos;

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
    _player = [AVQueuePlayer queuePlayerWithItems:@[]];
    _player.audiovisualBackgroundPlaybackPolicy = AVPlayerAudiovisualBackgroundPlaybackPolicyContinuesIfPossible;
    _playerViewController.player = _player;
    _videos = nil;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleURLIsAvailableInPasteboardNotification:) name:VNURLIsAvailableFromPasteboard object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleURLIsUnavailableInPasteboardNotification:) name:VNURLIsUnavailableFromPasteboard object:nil];
}


- (void)handleURLIsAvailableInPasteboardNotification:(NSNotification *)notification {
    _pasteButton.enabled = YES;
    _pasteStreamLinkButton.enabled = YES;
}


- (void)handleURLIsUnavailableInPasteboardNotification:(NSNotification *)notification {
    _pasteButton.enabled = NO;
    _pasteStreamLinkButton.enabled = NO;
}


- (void)handleViewTapWithRecognizer:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}


- (void)handleLinkTextFieldEditingChangedFromSender:(UITextField *)sender {
    BOOL shouldEnable = sender.text && ![sender.text isEqualToString:@""];
    _openButton.enabled = shouldEnable;
    _openStreamButton.enabled = shouldEnable;
}


- (void)handleOpenButtonTapFromSender:(UIButton *)sender {
    [self.view endEditing:YES];
    _videos = nil;

    NSString * URLString = _linkTextField.text;
    [self handleYouTubeURLString:URLString];
}


- (void)handleOpenStreamButtonTapFromSender:(UIButton *)sender {
    [self.view endEditing:YES];
    _videos = nil;

    NSString * URLString = _linkTextField.text;
    [self handleYouTubeStreamURLString:URLString];
}


- (void)handlePasteButtonTapFromSender:(UIButton *)sender {
    NSURL * URLFromPasteboard = UIPasteboard.generalPasteboard.URL;
    if (URLFromPasteboard) {
        _linkTextField.text = URLFromPasteboard.absoluteString;
        _openButton.enabled = YES;
        [self handleYouTubeURL:URLFromPasteboard];
    }
}


- (void)handlePasteStreamLinkButtonTapFromSender:(UIButton *)sender {
    NSURL * URLFromPasteboard = UIPasteboard.generalPasteboard.URL;
    if (URLFromPasteboard) {
        _linkTextField.text = URLFromPasteboard.absoluteString;
        _openButton.enabled = NO;
        [self handleYouTubeStreamURL:URLFromPasteboard];
    }
}


- (void)handleYouTubeURLString:(NSString *)URLString {
    __weak typeof(self) weak_self = self;
    VNVideoWebPageCompletionHandler handler = ^(NSDictionary<NSString *, id> * _Nullable JSONObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) self = weak_self;
            [self handleWebPageResponseWithJSONObject:JSONObject error:error];
        });
    };

    [_pageLoader loadWebPageWithVideoFromURLString:URLString completion:handler];
}


- (void)handleYouTubeStreamURLString:(NSString *)URLString {
    __weak typeof(self) weak_self = self;
    VNStreamWebPageCompletionHandler handler = ^(NSString * _Nullable playlistURL, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) self = weak_self;
            [self handleStreamWebPageResponseWithPlaylistURLString:playlistURL error:error];
        });
    };

    [_pageLoader loadWebPageWithStreamFromURLString:URLString completion:handler];
}


- (void)handleYouTubeURL:(NSURL *)URL {
    __weak typeof(self) weak_self = self;
    VNVideoWebPageCompletionHandler handler = ^(NSDictionary<NSString *, id> * _Nullable JSONObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) self = weak_self;
            [self handleWebPageResponseWithJSONObject:JSONObject error:error];
        });
    };
    [_pageLoader loadWebPageWithVideoFromURL:URL completion:handler];
}


- (void)handleYouTubeStreamURL:(NSURL *)URL {
    __weak typeof(self) weak_self = self;
    VNStreamWebPageCompletionHandler handler = ^(NSString * _Nullable playlistURL, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) self = weak_self;
            [self handleStreamWebPageResponseWithPlaylistURLString:playlistURL error:error];
        });
    };
    [_pageLoader loadWebPageWithStreamFromURL:URL completion:handler];
}


- (void)handleWebPageResponseWithJSONObject:(nullable NSDictionary<NSString *, id> *)JSONObject error:(nullable NSError *)error {
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        [self presentAlertWithTitle:@"Unable to load video" message:@"An error occurred"];
    } else if (JSONObject) {
        _videos = [VNVideoLinkExtractorForAllFormats extractVideoLinksFromJSONObject:JSONObject];
        NSURL * URL = _videos[@"format_medium"] ?: _videos[@"adaptiveFormat_360p"];
        if (URL) {
            [self playVideoFromURL:URL];
        }
    } else {
        [self presentAlertWithTitle:@"Unable to load video" message:@"Can't find link for the video file on server"];
    }
}


- (void)handleStreamWebPageResponseWithPlaylistURLString:(nullable NSString *)playlistURLString error:(nullable NSError *)error {
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        [self presentAlertWithTitle:@"Unable to load stream" message:@"An error occured"];
    } else if (playlistURLString) {
        _videos = @{};
        NSURL * URL = [NSURL URLWithString:playlistURLString];
        if (URL) {
            [self playVideoFromURL:URL];
        }
    } else {
        [self presentAlertWithTitle:@"Unable to load stream" message:@"Can't find link for the stream playlist on server"];
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


- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}


@end
