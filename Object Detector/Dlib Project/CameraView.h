//
//  CameraView.h
//  Dlib Project
//
//  Created by Robert Sanders on 24/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraFeed;

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

@end
