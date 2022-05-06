//
//  VNVideoLinkExtractoeForAdaptiveFormats.m
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNVideoLinkExtractor.h"
#import "VNVideoLinkExtractorForAdaptiveFormats.h"


@implementation VNVideoLinkExtractorForAdaptiveFormats


+ (NSDictionary<NSString *, NSURL *> *)extractVideoLinksFromJSONObject:(NSDictionary<NSString *, id> *)JSONObject {
    NSMutableDictionary<NSString *, NSURL *> * videoLinks = [[NSMutableDictionary alloc] init];

    NSArray<NSDictionary<NSString *, id> *> * adaptiveFormats = (NSArray<NSDictionary<NSString *, id> *> *)JSONObject[@"streamingData"][@"adaptiveFormats"];
    if (adaptiveFormats) {
        for (NSDictionary<NSString *, id> * format in adaptiveFormats) {
            if (![format[@"mimeType"] hasPrefix:@"video/mp4"]) { continue; }
            NSString * key = [NSString stringWithFormat:@"adaptiveFormat_%@", (NSString *)format[@"qualityLabel"]];
            NSURL * object = [NSURL URLWithString:format[@"url"]];
            if (key && object) {
                videoLinks[key] = object;
            }
        }
    }

    return [videoLinks copy];
}


@end
