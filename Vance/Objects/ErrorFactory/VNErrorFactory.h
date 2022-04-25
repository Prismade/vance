//
//  VNErrorFactory.h
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const VNErrorDomain;
FOUNDATION_EXPORT const NSInteger VNWrongURLStringErrorCode;
FOUNDATION_EXPORT const NSInteger VNEmptyResponseErrorCode;
FOUNDATION_EXPORT const NSInteger VNYouTubeLinkFormatNotSupported;

@interface VNErrorFactory : NSObject

+ (NSError *)wrongURLString;
+ (NSError *)emptyResponse;
+ (NSError *)wrongYouTubeURLFormat;

@end

NS_ASSUME_NONNULL_END
