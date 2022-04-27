//
//  VNSceneDelegate.m
//  Vance
//
//  Created by Egor Molchanov on 17.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNSceneDelegate.h"
#import "VNDumbLinkViewController.h"
#import "VNLinkValidator.h"
#import "VNVideoPageLoader.h"


@interface VNSceneDelegate ()

@property (nonatomic) VNLinkValidator * linkValidator;

@end


@implementation VNSceneDelegate


- (instancetype)init {
    self = [super init];
    if (self) {
        _linkValidator = [[VNLinkValidator alloc] init];
    }
    return self;
}


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if (!scene) { return; }

    UIWindowScene * windowScene = (UIWindowScene *)scene;
    _window = [[UIWindow alloc] initWithWindowScene:windowScene];
    [self openDumbLinkViewControllerWithWindowScene:windowScene];
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
    if (UIPasteboard.generalPasteboard.hasURLs) {
        [NSNotificationCenter.defaultCenter postNotificationName:VNURLIsAvailableFromPasteboard object:self];
    } else {
        [NSNotificationCenter.defaultCenter postNotificationName:VNURLIsUnavailableFromPasteboard object:self];
    }
}


- (void)openDumbLinkViewControllerWithWindowScene:(UIWindowScene *)windowScene {
    VNDumbLinkViewController * viewController = [[VNDumbLinkViewController alloc] init];

    viewController.pageLoader = [[VNVideoPageLoader alloc] initWithLinkValidator:_linkValidator];
    _window.rootViewController = viewController;
    [_window makeKeyAndVisible];
    _window.windowScene = windowScene;
}


@end
