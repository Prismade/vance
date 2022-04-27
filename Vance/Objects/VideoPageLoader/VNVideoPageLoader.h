//
//  VNVideoPageLoader.h
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import Foundation;

@class VNLinkValidator;

typedef void(^VNVideoWebPageCompletionHandler)(NSDictionary * _Nullable JSONObject, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface VNVideoPageLoader : NSObject

@property (nonatomic, nullable) VNLinkValidator * validator;

- (instancetype)initWithLinkValidator:(VNLinkValidator *)validator;
- (void)loadWebPageWithVideoFromURLString:(NSString *)URLString completion:(VNVideoWebPageCompletionHandler)completionHandler;
- (void)loadWebPageWithVideoFromURL:(NSURL *)URL completion:(VNVideoWebPageCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
