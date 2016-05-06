//
//  BMVideoLayer.h
//  Object Detector
//
//  Created by Robert Sanders on 31/01/2016.
//  Copyright © 2016 bmore digital ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BMVideoInput.h"

@protocol BMVideoPlugin;

@interface BMVideoLayer : CALayer

/**The video input stream for the player.*/
@property (nonatomic, strong, readonly) BMVideoInput *videoInput;
/**An array of the current video plugins associated with the player.*/
@property (nonatomic, strong, readonly) NSArray<id<BMVideoPlugin>> *plugins;
/**The capture source. Use layerWithFrame:captureSource: to set.*/
@property (nonatomic, readonly) BMCaptureSource captureSource;

/**Instantiates a video player with default configuration assiged to the given frame.*/
- (instancetype)initWithFrame:(CGRect)frame;
/**Instantiates a video player with the given capture source assiged to the given frame.*/
- (instancetype)initWithFrame:(CGRect)frame captureSource:(BMCaptureSource)captureSource;

/**Returns a video player with default configuration assiged to the given frame.*/
+ (BMVideoLayer *)layerWithFrame:(CGRect)frame;
/**Returns a video player with the given capture source assiged to the given frame.*/
+ (BMVideoLayer *)layerWithFrame:(CGRect)frame captureSource:(BMCaptureSource)captureSource;

/**Returns a pointer to the latest frame buffer. NOTE: The data is managed by BMVideoLayer and is released when the next frame arrives.*/
- (void *)getLatestFrame;
/**Copies the data in the latest frame buffer and returns it. NOTE: The dataa is allocated on the heap.*/
- (void *)getLatestFrameCopy;
/**Returns the latest frame as a CGImageRef. The data used to allocate the image is managed by BMVideoLayer and is released when the next frame arrives.*/
- (CGImageRef)getLatestFrameImage;
/**Returns an allocated copy of the latest frame data as an image.*/
- (CGImageRef)getLatestFrameImageCopy;
/**Returns an allocated copy of the latest frame data as an image. Scales the image by the given factor. DO NOT CALL FROM BACKGROUND THREAD.*/
- (CGImageRef)getLatestFrameImageScaled:(CGFloat)scaleFactor;

/**Begins streaiming from video feed.*/
- (void)beginStream;
/**Ends streaming from video feed.*/
- (void)endStream;

/**Adds a plugin to the player.*/
- (void)addPlugin:(id<BMVideoPlugin>)plugin;
/**Removes a plugin from the player.*/
- (void)removePlugin:(id<BMVideoPlugin>)plugin;

@end
