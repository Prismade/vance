//
//  VNVideoPageLoader.m
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNVideoPageLoader.h"
#import "VNErrorFactory.h"
#import "VNLinkValidator.h"


@implementation VNVideoPageLoader


- (instancetype)initWithLinkValidator:(VNLinkValidator *)validator {
    self = [super init];
    if (self) {
        _validator = validator;
    }
    return self;
}


- (void)loadWebPageWithVideoFromURLString:(NSString *)URLString completion:(VNVideoWebPageCompletionHandler)completionHandler {
    NSURL * URL = [NSURL URLWithString:URLString];
    if (URL) {
        [self loadWebPageWithVideoFromURL:URL completion:completionHandler];
    } else {
        NSError * error = [VNErrorFactory wrongURLString];
        completionHandler(nil, error);
    }
}


- (void)loadWebPageWithVideoFromURL:(NSURL *)URL completion:(VNVideoWebPageCompletionHandler)completionHandler {
    if (_validator && ![_validator validateVideoURL:URL]) {
        NSError * error = [VNErrorFactory wrongYouTubeURLFormat];
        completionHandler(nil, error);
        return;
    }

    __weak typeof(self) weak_self = self;
    VNDataTaskCompletionHandler handler = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(self) self = weak_self;
        if (error) {
            completionHandler(nil, error);
        } else if (data) {
            NSDictionary<NSString *, id> * JSONObject = [self handleSuccessfullWebPageLoadWithData:data];
            completionHandler(JSONObject, nil);
        } else {
            NSError * error = [VNErrorFactory emptyResponse];
            completionHandler(nil, error);
        }
    };

    NSURLSessionDataTask * task = [NSURLSession.sharedSession dataTaskWithURL:URL completionHandler:handler];
    [task resume];
}


- (void)loadWebPageWithStreamFromURLString:(NSString *)URLString completion:(VNStreamWebPageCompletionHandler)completionHandler {
    NSURL * URL = [NSURL URLWithString:URLString];
    if (URL) {
        [self loadWebPageWithStreamFromURL:URL completion:completionHandler];
    } else {
        NSError * error = [VNErrorFactory wrongURLString];
        completionHandler(nil, error);
    }
}


- (void)loadWebPageWithStreamFromURL:(NSURL *)URL completion:(VNStreamWebPageCompletionHandler)completionHandler {
    if (_validator && ![_validator validateVideoURL:URL]) {
        NSError * error = [VNErrorFactory wrongYouTubeURLFormat];
        completionHandler(nil, error);
        return;
    }

    __weak typeof(self) weak_self = self;
    VNDataTaskCompletionHandler handler = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(self) self = weak_self;
        if (error) {
            completionHandler(nil, error);
        } else if (data) {
            NSString * M3U8PlaylistURLString = [self handleSuccessfullStreamWebPageLoadWithData:data];
            completionHandler(M3U8PlaylistURLString, nil);
        } else {
            NSError * error = [VNErrorFactory emptyResponse];
            completionHandler(nil, error);
        }
    };

    NSURLSessionDataTask * task = [NSURLSession.sharedSession dataTaskWithURL:URL completionHandler:handler];
    [task resume];
}


- (NSDictionary<NSString *, id> *)handleSuccessfullWebPageLoadWithData:(NSData *)data {
    NSString * HTML = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString * JSONString = [self extractJSONFromHTML:HTML];
    NSData * JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * serializingError;
    NSDictionary<NSString *, id> * JSONObject = (NSDictionary<NSString *, id> *)[NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&serializingError];
    if (serializingError) {
        NSLog(@"%@", serializingError.localizedDescription);
    }
    return JSONObject;
}


- (NSString *)handleSuccessfullStreamWebPageLoadWithData:(NSData *)data {
    NSString * HTML = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString * M3U8PlaylistURLString = [self extractM3U8PlaylistURLStringFromHTML:HTML];
    return M3U8PlaylistURLString;
}


- (NSString *)extractJSONFromHTML:(NSString *)HTML {
    NSRange startRange = [HTML rangeOfString:@"var ytInitialPlayerResponse = {\""];
    NSUInteger JSONStartIndex = startRange.location + 30;

    NSString * almostJSONSubstring = [HTML substringFromIndex:JSONStartIndex];

    NSRange endRange = [almostJSONSubstring rangeOfString:@";</script>"];
    NSUInteger JSONEndIndex = endRange.location;

    NSString * JSONString = [almostJSONSubstring substringWithRange:NSMakeRange(0, JSONEndIndex)];
    return JSONString;
}


- (NSString *)extractM3U8PlaylistURLStringFromHTML:(NSString *)HTML {
    NSRange startRange = [HTML rangeOfString:@"\"hlsManifestUrl\":\""];
    NSUInteger URLStringStartIndex = startRange.location + 18;

    NSString * almostURLSubstring = [HTML substringFromIndex:URLStringStartIndex];

    NSRange endRange = [almostURLSubstring rangeOfString:@"\""];
    NSUInteger URLStringEndIndex = endRange.location;

    NSString * URLString = [almostURLSubstring substringWithRange:NSMakeRange(0, URLStringEndIndex)];
    return URLString;
}


@end
