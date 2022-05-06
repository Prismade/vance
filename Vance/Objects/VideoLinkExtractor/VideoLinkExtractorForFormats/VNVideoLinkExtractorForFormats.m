//
//  VNVideoLinkExtractorForFormats.m
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNVideoLinkExtractor.h"
#import "VNVideoLinkExtractorForFormats.h"


@implementation VNVideoLinkExtractorForFormats


+ (NSDictionary<NSString *, NSURL *> *)extractVideoLinksFromJSONObject:(NSDictionary<NSString *, id> *)JSONObject {
    NSMutableDictionary<NSString *, NSURL *> * videoLinks = [[NSMutableDictionary alloc] init];

    NSArray<NSDictionary<NSString *, id> *> * formats = (NSArray<NSDictionary<NSString *, id> *> *)JSONObject[@"streamingData"][@"formats"];
    if (formats) {
        for (NSDictionary<NSString *, id> * format in formats) {
            if (![format[@"mimeType"] hasPrefix:@"video/mp4"]) { continue; }
            NSString * key = [NSString stringWithFormat:@"format_%@", (NSString *)format[@"quality"]];
            NSURL * object = [NSURL URLWithString:format[@"url"]];
            if (key && object) {
                videoLinks[key] = object;
            }
        }
    }

    return [videoLinks copy];
}


@end
