//
//  VNSceneDelegate.m
//  Vance
//
//  Created by Egor Molchanov on 17.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNSceneDelegate.h"
#import "VNDumbLinkViewController.h"


@implementation VNSceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if (!scene) { return; }

    UIWindowScene * windowScene = (UIWindowScene *)scene;
    _window = [[UIWindow alloc] initWithWindowScene:windowScene];
    [self openDumbLinkViewControllerWithWindowScene:windowScene];
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
    if (UIPasteboard.generalPasteboard.hasURLs) {
        [NSNotificationCenter.defaultCenter postNotificationName:VNURLIsAvailableFromPasteboard object:nil];
    }
}


- (void)openDumbLinkViewControllerWithWindowScene:(UIWindowScene *)windowScene {
    VNDumbLinkViewController * viewController = [[VNDumbLinkViewController alloc] init];
    _window.rootViewController = viewController;
    [_window makeKeyAndVisible];
    _window.windowScene = windowScene;
}


@end
