//
//  SRVideoPlayer.h
//  SRVideoPlayerDemo
//
//  Created by 郭伟林 on 17/1/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SRVideoPlayerState) {
    SRVedioPlayerStateFailed,
    SRVideoPlayerStateBuffering,
    SRVideoPlayerStatePlaying,
    SRVideoPlayerStatePaused,
    SRVideoPlayerStateFinished,
    SRVideoPlayerStateStopped
};

typedef NS_ENUM(NSInteger, SRVideoPlayerEndAction) {
    SRVideoPlayerEndActionStop,
    SRVideoPlayerEndActionLoop,
    SRVideoPlayerEndActionDestroy
};

@interface SRVideoPlayer : NSObject

@property (nonatomic, assign, readonly) SRVideoPlayerState playerState;

/**
 Action when video play to end, default is SRVideoPlayerEndActionStop.
 */
@property (nonatomic, assign) SRVideoPlayerEndAction playerEndAction;

/**
 Name of the video which will play.
 */
@property (nonatomic, copy) NSString *videoName;

/**
 Create a SRVideoPlayer object with video's URL.

 @param videoURL        The URL of the video.
 @param playerView      The view which you want to display the video.
 @param playerSuperView PlayerView's super view.
 @return A SRVideoPlayer object
 */
+ (instancetype)playerWithVideoURL:(NSURL *)videoURL playerView:(UIView *)playerView playerSuperView:(UIView *)playerSuperView;

- (void)play;

- (void)pause;

- (void)resume;

- (void)destroyPlayer;

@end
