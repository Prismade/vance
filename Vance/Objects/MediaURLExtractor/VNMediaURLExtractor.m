//
//  VNMediaURLExtractor.m
//  Vance
//
//  Created by Egor Molchanov on 09.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNMediaURLExtractor.h"
#import "VNErrorFactory.h"


@implementation VNMediaURLExtractor


+ (nullable NSDictionary<NSString *, NSURL *> *)extractMediaURLsFromHTML:(NSString *)HTML {
    NSDictionary<NSString *, id> * JSONObject = [self extractJSONWithMediaURLsFromHTML:HTML];
    NSDictionary<NSString *, NSURL *> * formatsURLs = [self extractMediaURLsFromFormatsJSONObject:JSONObject];
    NSDictionary<NSString *, NSURL *> * adaptiveFormatURLs = [self extractMediaURLsFromAdaptiveFormatsJSONObject:JSONObject];
    NSMutableDictionary<NSString *, NSURL *> * URLs = [NSMutableDictionary dictionaryWithDictionary:formatsURLs];
    [URLs addEntriesFromDictionary:adaptiveFormatURLs];
    return [URLs copy];
}


+ (nullable NSDictionary<NSString *, id> *)extractJSONWithMediaURLsFromHTML:(NSString *)HTML {
    NSRange startRange = [HTML rangeOfString:@"var ytInitialPlayerResponse = {\""];
    if (startRange.location == NSNotFound) {
        return nil;
    }
    NSUInteger JSONStartIndex = startRange.location + 30;

    NSString * almostJSONSubstring = [HTML substringFromIndex:JSONStartIndex];

    NSRange endRange = [almostJSONSubstring rangeOfString:@";</script>"];
    NSUInteger JSONEndIndex = endRange.location;

    NSString * JSONString = [almostJSONSubstring substringWithRange:NSMakeRange(0, JSONEndIndex)];
    NSData * JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * serializingError;
    NSDictionary<NSString *, id> * JSONObject = (NSDictionary<NSString *, id> *)[NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&serializingError];
    if (serializingError) {
        NSLog(@"%@", serializingError.localizedDescription);
    }
    return JSONObject;
}


+ (nullable NSDictionary<NSString *, NSURL *> *)extractMediaURLsFromFormatsJSONObject:(NSDictionary<NSString *, id> *)JSONObject {
    NSMutableDictionary<NSString *, NSURL *> * mediaURLs = [[NSMutableDictionary alloc] init];

    NSArray<NSDictionary<NSString *, id> *> * formats = (NSArray<NSDictionary<NSString *, id> *> *)JSONObject[@"streamingData"][@"formats"];
    if (formats) {
        for (NSDictionary<NSString *, id> * format in formats) {
            if (![format[@"mimeType"] hasPrefix:@"video/mp4"]) { continue; }
            NSString * key = [NSString stringWithFormat:@"format_%@", (NSString *)format[@"quality"]];
            NSURL * object = [NSURL URLWithString:format[@"url"]];
            if (key && object) {
                mediaURLs[key] = object;
            }
        }
    }

    return [mediaURLs copy];
}


+ (nullable NSDictionary<NSString *, NSURL *> *)extractMediaURLsFromAdaptiveFormatsJSONObject:(NSDictionary<NSString *,id> *)JSONObject {
    NSMutableDictionary<NSString *, NSURL *> * mediaURLs = [[NSMutableDictionary alloc] init];

    NSArray<NSDictionary<NSString *, id> *> * adaptiveFormats = (NSArray<NSDictionary<NSString *, id> *> *)JSONObject[@"streamingData"][@"adaptiveFormats"];
    if (adaptiveFormats) {
        for (NSDictionary<NSString *, id> * format in adaptiveFormats) {
            if (![format[@"mimeType"] hasPrefix:@"video/mp4"]) { continue; }
            NSString * key = [NSString stringWithFormat:@"adaptiveFormat_%@", (NSString *)format[@"qualityLabel"]];
            NSURL * object = [NSURL URLWithString:format[@"url"]];
            if (key && object) {
                mediaURLs[key] = object;
            }
        }
    }

    return [mediaURLs copy];
}


+ (nullable NSURL *)extractM3U8MediaPlaylistURLFromHTML:(NSString *)HTML {
    NSRange startRange = [HTML rangeOfString:@"\"hlsManifestUrl\":\""];
    if (startRange.location == NSNotFound) {
        return nil;
    }
    NSUInteger URLStringStartIndex = startRange.location + 18;

    NSString * almostURLSubstring = [HTML substringFromIndex:URLStringStartIndex];

    NSRange endRange = [almostURLSubstring rangeOfString:@"\""];
    NSUInteger URLStringEndIndex = endRange.location;

    NSString * URLString = [almostURLSubstring substringWithRange:NSMakeRange(0, URLStringEndIndex)];
    NSURL * URL = [NSURL URLWithString:URLString];
    return URL;
}


@end
