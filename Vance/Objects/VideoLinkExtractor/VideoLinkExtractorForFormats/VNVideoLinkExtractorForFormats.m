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


+ (NSDictionary *)extractVideoLinksFromJSONObject:(NSDictionary *)JSONObject {
    NSMutableDictionary * videoLinks = [[NSMutableDictionary alloc] init];

    NSArray * formats = (NSArray *)JSONObject[@"streamingData"][@"formats"];
    if (formats) {
        for (NSDictionary * format in formats) {
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
