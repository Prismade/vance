//
//  VNMediaSource.h
//  Vance
//
//  Created by Egor Molchanov on 08.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import Foundation;

typedef void(^VNMediaSourceResponse)(NSURL * _Nullable, NSError * _Nullable);

NS_ASSUME_NONNULL_BEGIN

@interface VNMediaSource : NSObject

+ (void)mediaURLforYouTubePageURL:(NSURL *)YouTubePageURL completionHandler:(VNMediaSourceResponse)completionHandler;

@end

NS_ASSUME_NONNULL_END
