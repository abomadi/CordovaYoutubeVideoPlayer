//
//  YoutubeVideoPlayer.m
//
//  Fixed and Edited by Abdallah Madi on 13-October-2019.
//
//

#import "YoutubeVideoPlayer.h"
#import "XCDYouTubeKit.h"
#import "AVFoundation/AVFoundation.h"
#import <AVKit/AVKit.h>

@implementation YoutubeVideoPlayer

- (void)openVideo:(CDVInvokedUrlCommand*)command
{

    CDVPluginResult* pluginResult = nil;
    
    NSString* videoID = [command.arguments objectAtIndex:0];
    
    if (videoID != nil) {
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        [self.viewController presentViewController:playerViewController animated:YES completion:nil];

        __weak AVPlayerViewController *weakPlayerViewController = playerViewController;
        [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoID completionHandler:^(XCDYouTubeVideo *video, NSError *error){
            if(video)
            {
                NSDictionary *streamURLs = video.streamURLs;
                NSURL *streamURL = streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?: streamURLs[@(XCDYouTubeVideoQualityHD720)] ?: streamURLs[@(XCDYouTubeVideoQualityMedium360)] ?: streamURLs[@(XCDYouTubeVideoQualitySmall240)];
                weakPlayerViewController.player = [AVPlayer playerWithURL:streamURL];
                [weakPlayerViewController.player play];
            }
            else
            {
                
            }
        }];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        
    } else {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Missing videoID Argument"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }
    
    _eventsCallbackId = command.callbackId;
}


@end
