//
//  VNAppDelegate.m
//  Vance
//
//  Created by Egor Molchanov on 17.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNAppDelegate.h"
#import "VNLinkValidator.h"
#import "VNDumbLinkViewController.h"
#import "VNVideoPageLoader.h"


@interface VNAppDelegate ()

@property (nonatomic) VNLinkValidator * linkValidator;

@end


@implementation VNAppDelegate


- (instancetype)init {
    self = [super init];
    if (self) {
        _linkValidator = [[VNLinkValidator alloc] init];
    }
    return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self setupAudioSession];
    [self openDumbLinkViewController];
    [self checkPasteboardForURLAndPostNotification];
    return YES;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self checkPasteboardForURLAndPostNotification];
}


- (void)checkPasteboardForURLAndPostNotification {
    if (UIPasteboard.generalPasteboard.hasURLs) {
        [NSNotificationCenter.defaultCenter postNotificationName:VNURLIsAvailableFromPasteboard object:self];
    } else {
        [NSNotificationCenter.defaultCenter postNotificationName:VNURLIsUnavailableFromPasteboard object:self];
    }
}


- (void)setupAudioSession {
    AVAudioSession * session = AVAudioSession.sharedInstance;
    NSError * error;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
}


- (void)openDumbLinkViewController {
    VNDumbLinkViewController * viewController = [[VNDumbLinkViewController alloc] init];
    viewController.pageLoader = [[VNVideoPageLoader alloc] initWithLinkValidator:_linkValidator];
    _window.rootViewController = viewController;
    [_window makeKeyAndVisible];
}


@end
