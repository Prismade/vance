//
//  VNAppDelegate.m
//  Vance
//
//  Created by Egor Molchanov on 17.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNAppDelegate.h"


@implementation VNAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    AVAudioSession * session = AVAudioSession.sharedInstance;
    NSError * error;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


@end
