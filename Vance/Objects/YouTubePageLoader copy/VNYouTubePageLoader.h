//
//  VNYouTubePageLoader.h
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import Foundation;

typedef void(^VNDataTaskCompletionHandler)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);
typedef void(^VNHTMLPageCompletionHandler)(NSString * _Nullable, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface VNYouTubePageLoader : NSObject

+ (void)loadFromURL:(NSURL *)URL completionHandler:(VNHTMLPageCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
