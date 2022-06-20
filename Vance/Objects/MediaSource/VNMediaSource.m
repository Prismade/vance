//
//  VNMediaSource.m
//  Vance
//
//  Created by Egor Molchanov on 08.06.2022.
//  Copyright © 2022 Egor and the fucked up. All rights reserved.
//

#import "VNMediaSource.h"
#import "VNErrorFactory.h"
#import "VNYouTubePageURLValidator.h"
#import "VNYouTubePageLoader.h"
#import "VNMediaURLExtractor.h"


@implementation VNMediaSource


+ (void)mediaURLforYouTubePageURL:(NSURL *)YouTubePageURL completionHandler:(VNMediaSourceResponse)completionHandler {
    if (![VNYouTubePageURLValidator validateURL:YouTubePageURL]) {
        completionHandler(nil, [VNErrorFactory wrongYouTubePageURLFormat]);
        return;
    }
    
    [VNYouTubePageLoader loadFromURL:YouTubePageURL completionHandler:^(NSString * _Nullable HTML, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil, error);
        } else {
            NSURL * mediaURL = [VNMediaURLExtractor extractM3U8MediaPlaylistURLFromHTML:HTML];
            if (mediaURL) {
                completionHandler(mediaURL, nil);
                return;
            }
            
            NSDictionary<NSString *, NSURL *> * URLs = [VNMediaURLExtractor extractMediaURLsFromHTML:HTML];
            mediaURL = URLs[@"format_medium"] ?: URLs[@"adaptiveFormat_360p"];
            if (mediaURL) {
                completionHandler(mediaURL, nil);
                return;
            }
            
            completionHandler(nil, [VNErrorFactory mediaNotFound]);
        }
    }];
}


@end
