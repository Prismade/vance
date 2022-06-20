//
//  VNSceneDelegate.m
//  Vance
//
//  Created by Egor Molchanov on 21.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNSceneDelegate.h"
#import "NSNotification+Name.h"
#import "VNDumbLinkViewController.h"

#import "VNSubscriptionsFeedViewController.h"


@implementation VNSceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene * windowScene = (UIWindowScene *)scene;
    _window = [[UIWindow alloc] initWithWindowScene:windowScene];
    
    [self setupAudioSession];
    [self openDumbLinkViewControllerWithWindowScene:windowScene];
    [self checkPasteboardForURLAndPostNotification];
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
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


- (void)openDumbLinkViewControllerWithWindowScene:(UIWindowScene *)windowScene {
    VNDumbLinkViewController * viewController = [[VNDumbLinkViewController alloc] init];
    _window.rootViewController = viewController;
    [_window makeKeyAndVisible];
    _window.windowScene = windowScene;
}


@end
