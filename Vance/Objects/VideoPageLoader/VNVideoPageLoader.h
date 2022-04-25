//
//  VNVideoPageLoader.h
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import Foundation;

typedef void(^VNVideoWebPageCompletionHandler)(NSDictionary * _Nullable JSONObject, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSArray<NSString *> * const VNYouTubeURLPrefixes;

@interface VNVideoPageLoader : NSObject

- (void)loadWebPageWithVideoFromURLString:(NSString *)URLString completion:(VNVideoWebPageCompletionHandler)completionHandler;
- (void)loadWebPageWithVideoFromURL:(NSURL *)URL completion:(VNVideoWebPageCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
