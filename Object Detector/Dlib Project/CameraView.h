//
//  CameraView.h
//  Dlib Project
//
//  Created by Robert Sanders on 24/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraFeed;
@class ObjectDetector;
@class Detection;

typedef void (^CameraViewObjectDetectionHandler)(NSError * _Nullable error, NSArray<Detection *> * _Nullable detections, BOOL * _Nonnull stop);

@interface CameraView : UIView

/**
 Whether there is a current active stream.
 */
@property (nonatomic, readonly) BOOL isStreamActive;

/**
 Begins streaming the back camera.
 */
- (void)beginCameraFeed;

/**
 Begins streaming the webcam.
 */
- (void)beginWebcamFeed;

/**
 Stops any active stream.
 */
- (void)stopStream;

/**
 Begins running object detection using the given object detector.

 @param objectDetector The object detector to use.
 @param handler An object detection handler.
 */
- (void)beginObjectDetectionWithDetector:(ObjectDetector * _Nonnull)objectDetector handler:(CameraViewObjectDetectionHandler _Nonnull)handler;

@end
