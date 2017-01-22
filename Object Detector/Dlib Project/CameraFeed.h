//
//  CameraFeed.h
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreImage.h"

typedef NS_ENUM(int, CameraFeedPixelFormat) {
    CameraFeedPixelFormatBGRA,
    CameraFeedPixelFormatRGBA,
    CameraFeedPixelFormatBGR,
    CameraFeedPixelFormatRGB,
    CameraFeedPixelFormatGreyscale
};

typedef NS_ENUM(int, CameraSource) {
    CameraSourceCamera,
    CameraSourceWebcam
};

typedef NS_ENUM(NSInteger, CameraFeedError) {
    CameraFeedErrorAlreadyActive
};

@class CameraFeed;

@protocol CameraFeedDelegate <NSObject>
@optional

- (void)cameraFeed:(CameraFeed * _Nonnull)cameraFeed didRecieveImageData:(core_image_frame * _Nullable)frame;

@end

typedef void (^CameraFeedHandler)(core_image_frame * _Nonnull frame);

@interface CameraFeed : NSObject


/**
 An optional delegate. NOTE: If the delegate implements any of the methods it is its responsibility to release the image data.
 */
@property (nonatomic, weak, nullable) id<CameraFeedDelegate> delegate;
/**
 An optional camera feed handler. NOTE: If the handler is not nil it MUST release the image data.
 */
@property (nonatomic, copy, nullable) CameraFeedHandler handler;

/**
 Whether a camera feed session is currently active.
 */
@property (nonatomic, readonly) BOOL isActive;
/**
 The current camera source. Invalid if feed is not active.
 */
@property (nonatomic, readonly) CameraSource currentSource;
/**
 The pixel format the camera feed recieves. NOTE: This may be different to the desired format depending on availablility.
 */
@property (nonatomic, readonly) CameraFeedPixelFormat pixelFormat;

/**
 Opens a session for the given camera source if possible using BGRA pixel format.

 @param source The camera source to use.
 @param error An optional error.
 @return Whether the session was successfully opened.
 */
- (BOOL)openSessionForSource:(CameraSource)source error:(NSError * _Nullable * _Nullable)error;

/**
 Opens a session for the given camera source if possible.

 @param source The camera source to use.
 @param format The preffered pixel format. Actual format may be different.
 @param error An optional error.
 @return Whether the session was successfully opened.
 */
- (BOOL)openSessionForSource:(CameraSource)source prefferedPixelFormat:(CameraFeedPixelFormat)format error:(NSError * _Nullable * _Nullable)error;

/**
 Starts the capture session if possible.
 */
- (void)startStream;

/**
 Stops any active stream.
 */
- (void)stopStream;

@end
























