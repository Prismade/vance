//
//  VNVideoLinkExtractorForAllFormats.m
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNVideoLinkExtractorForAllFormats.h"
#import "VNVideoLinkExtractorForFormats.h"
#import "VNVideoLinkExtractorForAdaptiveFormats.h"


@implementation VNVideoLinkExtractorForAllFormats


+ (NSDictionary<NSString *, NSURL *> *)extractVideoLinksFromJSONObject:(NSDictionary<NSString *, id> *)JSONObject {
    NSDictionary<NSString *, NSURL *> * formatsLinks = [VNVideoLinkExtractorForFormats extractVideoLinksFromJSONObject:JSONObject];
    NSDictionary<NSString *, NSURL *> * adaptiveFormatLinks = [VNVideoLinkExtractorForAdaptiveFormats extractVideoLinksFromJSONObject:JSONObject];
    NSMutableDictionary<NSString *, NSURL *> * links = [NSMutableDictionary dictionaryWithDictionary:formatsLinks];
    [links addEntriesFromDictionary:adaptiveFormatLinks];
    return [links copy];
}


@end
