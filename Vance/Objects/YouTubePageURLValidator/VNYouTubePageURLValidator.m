//
//  VNYouTubePageURLValidator.m
//  Vance
//
//  Created by Egor Molchanov on 27.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNYouTubePageURLValidator.h"


NSArray<NSString *> * const VNYouTubePageURLPrefixes = @[@"https://youtu.be/", @"https://youtube.com/watch"];


@implementation VNYouTubePageURLValidator


+ (BOOL)validateURL:(NSURL *)URL {
    return [self validateURLString:URL.absoluteString];
}


+ (BOOL)validateURLString:(NSString *)URLString {
    BOOL hasPrefix = NO;
    for (NSString * prefix in VNYouTubePageURLPrefixes) {
        hasPrefix |= [URLString hasPrefix:prefix];
    }
    return hasPrefix;
}


@end
