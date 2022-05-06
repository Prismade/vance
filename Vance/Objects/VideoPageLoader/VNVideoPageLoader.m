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

    __weak VNVideoPageLoader * weak_self = self;
    NSURLSessionDataTask * task = [NSURLSession.sharedSession dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil, error);
        } else if (data) {
            NSDictionary<NSString *, id> * JSONObject = [weak_self handleSuccessFullWebPageLoadWithData:data];
            completionHandler(JSONObject, nil);
        } else {
            NSError * error = [VNErrorFactory emptyResponse];
            completionHandler(nil, error);
        }
    }];
    [task resume];
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


- (NSDictionary<NSString *, id> *)handleSuccessFullWebPageLoadWithData:(NSData *)data {
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


@end
