//
//  VNLinkValidator.h
//  Vance
//
//  Created by Egor Molchanov on 27.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSArray<NSString *> * const VNYouTubeURLPrefixes;

@interface VNLinkValidator : NSObject

- (BOOL)validateVideoURL:(NSURL *)URL;
- (BOOL)validateVideoURLString:(NSString *)URLString;

@end

NS_ASSUME_NONNULL_END
