//
//  VNYouTubePageURLValidator.h
//  Vance
//
//  Created by Egor Molchanov on 27.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface VNYouTubePageURLValidator : NSObject

+ (BOOL)validateURL:(NSURL *)URL;
+ (BOOL)validateURLString:(NSString *)URLString;

@end

NS_ASSUME_NONNULL_END
