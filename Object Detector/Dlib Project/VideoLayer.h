//
//  VideoLayer.h
//  Dlib Project
//
//  Created by Robert Sanders on 24/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class CameraFeed;

@interface VideoLayer : CALayer

/**
 Creates a video layer with a camera feed instance.

 @param cameraFeed The camera feed for the layer.
 @return The video layer instance
 */
- (instancetype _Nonnull)initWithCameraFeed:(CameraFeed * _Nonnull)cameraFeed;

/**
 Creates a video layer with a camera feed instance.
 
 @param cameraFeed The camera feed for the layer.
 @return The video layer instance
 */
+ (VideoLayer * _Nonnull)layerWithCameraFeed:(CameraFeed * _Nonnull)cameraFeed;

/**
 Instantiates a video layer that takes input from the back camera.
 
 @return The video layer instance.
 */
+ (VideoLayer * _Nullable)cameraLayer;

/**
 Instantiates a video layer that takes input from the webcam.

 @return The video layer instance.
 */
+ (VideoLayer * _Nullable)webcamLayer;

/**
 The camera feed that the video layer uses to display content.
 */
@property (nonatomic, strong, readonly, nonnull) CameraFeed * cameraFeed;

/**
 Whether there is a current video stream.
 */
@property (nonatomic, readonly) BOOL videoStreamActive;


/**
 Begins displaying content from the camera feed.
 */
- (void)beginVideoStream;

/**
 Stops playing content from the camera feed.
 */
- (void)stopVideoStream;

@end































