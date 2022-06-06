//
//  VNVideoPageLoader.h
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import Foundation;

@class VNLinkValidator;

typedef void(^VNDataTaskCompletionHandler)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);
typedef void(^VNVideoWebPageCompletionHandler)(NSDictionary<NSString *, id> * _Nullable JSONObject, NSError * _Nullable error);
typedef void(^VNStreamWebPageCompletionHandler)(NSString * _Nullable, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface VNVideoPageLoader : NSObject

@property (nonatomic, nullable) VNLinkValidator * validator;

- (instancetype)initWithLinkValidator:(VNLinkValidator *)validator;
- (void)loadWebPageWithVideoFromURLString:(NSString *)URLString completion:(VNVideoWebPageCompletionHandler)completionHandler;
- (void)loadWebPageWithVideoFromURL:(NSURL *)URL completion:(VNVideoWebPageCompletionHandler)completionHandler;
- (void)loadWebPageWithStreamFromURLString:(NSString *)URLstring completion:(VNStreamWebPageCompletionHandler)completionHandler;
- (void)loadWebPageWithStreamFromURL:(NSURL *)URL completion:(VNStreamWebPageCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
