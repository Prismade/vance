//
//  VNErrorFactory.m
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNErrorFactory.h"


NSString * const VNErrorDomain = @"net.prismade.Vance";
const NSInteger VNWrongURLStringErrorCode = 0;
const NSInteger VNEmptyResponseErrorCode = 1;
const NSInteger VNYouTubeLinkFormatNotSupported = 2;


@implementation VNErrorFactory


+ (NSError *)wrongURLString {
    return [NSError errorWithDomain:VNErrorDomain code:VNWrongURLStringErrorCode userInfo:@{NSLocalizedDescriptionKey : @"Unable to create URL from provided string"}];
}


+ (NSError *)emptyResponse {
    return [NSError errorWithDomain:VNErrorDomain code:VNEmptyResponseErrorCode userInfo:@{NSLocalizedDescriptionKey : @"Failed to create NSString from data because it was empty"}];
}


+ (NSError *)wrongYouTubeURLFormat {
    return [NSError errorWithDomain:VNErrorDomain code:VNYouTubeLinkFormatNotSupported userInfo:@{NSLocalizedDescriptionKey : @"The URL format is not one of supported YouTube fromats"}];
}


@end
