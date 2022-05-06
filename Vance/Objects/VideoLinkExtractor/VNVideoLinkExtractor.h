//
//  VNVideoLinkExtractor.h
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol VNVideoLinkExtractor <NSObject>

+ (NSDictionary<NSString *, NSURL *> *)extractVideoLinksFromJSONObject:(NSDictionary<NSString *, id> *)JSONObject;

@end

NS_ASSUME_NONNULL_END
