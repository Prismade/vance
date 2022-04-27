//
//  VNLinkValidator.m
//  Vance
//
//  Created by Egor Molchanov on 27.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNLinkValidator.h"


NSArray<NSString *> * const VNYouTubeURLPrefixes = @[@"https://youtu.be/", @"https://youtube.com/watch"];


@implementation VNLinkValidator


- (BOOL)validateVideoURLString:(NSString *)URLString {
    BOOL hasPrefix = NO;
    for (NSString * prefix in VNYouTubeURLPrefixes) {
        hasPrefix |= [URLString hasPrefix:prefix];
    }
    return hasPrefix;
}


- (BOOL)validateVideoURL:(NSURL *)URL {
    return [self validateVideoURLString:URL.absoluteString];
}


@end
