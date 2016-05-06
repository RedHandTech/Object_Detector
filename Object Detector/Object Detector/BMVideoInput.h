//
//  BMVideoInput.h
//  Hand Detector
//
//  Created by Freelance on 27/01/2016.
//  Copyright © 2016 bmore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BMCaptureSourceWebcam,
    BMCaptureSourceCamera
}BMCaptureSource;

typedef void (^BMFrameDataHandler)(void *data);

@class BMVideoInput;

@protocol BMVideoInputDelegate <NSObject>
@optional

/**Called when a frame's data is available.*/
- (void)videoInput:(BMVideoInput *)input didCaptureFrame:(void *)data width:(size_t)width height:(size_t)height depth:(size_t)depth bytesPerRow:(size_t)bytesPerRow;

@end

@interface BMVideoInput : NSObject

@property (nonatomic, weak) id<BMVideoInputDelegate> delegate;

/**If non-nill will be called when there is frame data available.*/
@property (nonatomic, copy) BMFrameDataHandler frameDataHandler;

+ (BMVideoInput *)input;

/**Readys the video stream for video capture. Pixel format is BGRA.*/
- (BOOL)openVideoStream:(BMCaptureSource)captureSource error:(NSError **)error;
/**Begins video capture.*/
- (void)startStream;
/**Ends video capture.*/
- (void)stopStream;

@end



































































