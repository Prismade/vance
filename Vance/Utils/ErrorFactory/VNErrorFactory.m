//
//  VNErrorFactory.m
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNErrorFactory.h"


NSString * const VNErrorDomain = @"net.prismade.Vance";


@implementation VNErrorFactory


+ (NSError *)wrongURLString {
    return [NSError errorWithDomain:VNErrorDomain code:VNErrorCodeWrongURLString userInfo:@{NSLocalizedDescriptionKey : @"Unable to create URL from provided string"}];
}


+ (NSError *)emptyResponse {
    return [NSError errorWithDomain:VNErrorDomain code:VNErrorCodeEmptyResponse userInfo:@{NSLocalizedDescriptionKey : @"Failed to create NSString from data because it was empty"}];
}


+ (NSError *)wrongYouTubePageURLFormat {
    return [NSError errorWithDomain:VNErrorDomain code:VNErrorCodeYouTubeLinkFormatNotSupported userInfo:@{NSLocalizedDescriptionKey : @"The YouTube Page URL format is not one of supported formats"}];
}


+ (NSError *)mediaNotFound {
    return [NSError errorWithDomain:VNErrorDomain code:VNErrorCodeMediaNotFound userInfo:@{NSLocalizedDescriptionKey : @"Media URLs not found in YouTube page source"}];
}


@end
