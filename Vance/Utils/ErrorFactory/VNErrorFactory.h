//
//  VNErrorFactory.h
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, VNErrorCode) {
    VNErrorCodeWrongURLString,
    VNErrorCodeEmptyResponse,
    VNErrorCodeYouTubeLinkFormatNotSupported,
    VNErrorCodeMediaNotFound
};

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const VNErrorDomain;

@interface VNErrorFactory : NSObject

+ (NSError *)wrongURLString;
+ (NSError *)emptyResponse;
+ (NSError *)wrongYouTubePageURLFormat;
+ (NSError *)mediaNotFound;

@end

NS_ASSUME_NONNULL_END
