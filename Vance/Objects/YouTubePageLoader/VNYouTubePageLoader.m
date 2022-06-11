//
//  VNYouTubePageLoader.m
//  Vance
//
//  Created by Egor Molchanov on 24.04.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNYouTubePageLoader.h"
#import "VNErrorFactory.h"


@implementation VNYouTubePageLoader


+ (void)loadFromURL:(NSURL *)URL completionHandler:(VNHTMLPageCompletionHandler)completionHandler {
    VNDataTaskCompletionHandler handler = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil, error);
        } else if (data) {
            NSString * HTML = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            completionHandler(HTML, nil);
        } else {
            NSError * error = [VNErrorFactory emptyResponse];
            completionHandler(nil, error);
        }
    };

    NSURLSessionDataTask * task = [NSURLSession.sharedSession dataTaskWithURL:URL completionHandler:handler];
    [task resume];
}


@end
