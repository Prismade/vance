//
//  main.m
//  Vance
//
//  Created by Egor Molchanov on 17.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VNAppDelegate.h"


int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        appDelegateClassName = NSStringFromClass([VNAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
