//
//  ObjectDetector.h
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>

@class Detection;

typedef NS_ENUM(int, ObjectDetectorError) {
    ObjectDetectorErrorUnknown,
    ObjectDetectorErrorInvalidFilePath,
    ObjectDetectorErrorAlreadyProcessingImage,
    ObjectDetectorErrorObjectDetectorNotLoaded
};

typedef void (^ObjectDetectorLoadingHandler)(BOOL success, NSError * _Nullable error);
typedef void (^ObjectDetectorProcessingHandler)(BOOL success, NSError * _Nullable error, NSArray<Detection *> * _Nullable detections);

@interface ObjectDetector : NSObject

/**
 Asyncronously loads an SVM file for object detection.

 @param path The path to the SVM file.
 @param handler The completion handler.
 */
- (void)loadSVMFile:(NSString * _Nonnull)path handler:(ObjectDetectorLoadingHandler _Nonnull)handler;

/**
 Runs object detection on the image. NOTE: CGImageRef will not be released by the object detector after use.

 @param image The image on with to run object detection. MUST BE RGB.
 @param detectionHandler A handler which is called upon completion.
 */
- (void)processImage:(CGImageRef _Nonnull)image detectionHandler:(ObjectDetectorProcessingHandler _Nonnull)detectionHandler;
/**
 Runs object detection on the image.
 
 @param image The image on with to run object detection. MUST BE RGB.
 @param releaseAfterUse Whether the CGImageRef will be released by the object detector after use.
 @param detectionHandler A handler which is called upon completion.
 */
- (void)processImage:(CGImageRef _Nonnull)image releaseAfterUse:(BOOL)releaseAfterUse detectionHandler:(ObjectDetectorProcessingHandler _Nonnull)detectionHandler;

@end
















