//
//  VNMediaURLExtractor.h
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface VNMediaURLExtractor : NSObject

+ (nullable NSDictionary<NSString *, NSURL *> *)extractMediaURLsFromHTML:(NSString *)HTML;
+ (nullable NSURL *)extractM3U8MediaPlaylistURLFromHTML:(NSString *)HTML;

@end

NS_ASSUME_NONNULL_END
