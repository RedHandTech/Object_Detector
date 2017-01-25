//
//  ObjectDetector.h
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(int, ObjectDetectorError) {
    ObjectDetectorErrorUnknown,
    ObjectDetectorErrorInvalidFilePath
};

typedef void (^ObjectDetectorLoadingHandler)(BOOL success, NSError * _Nullable error);

@interface ObjectDetector : NSObject


/**
 Asyncronously loads an SVM file for object detection.

 @param path The path to the SVM file.
 @param handler The completion handler.
 */
- (void)loadSVMFile:(NSString * _Nonnull)path handler:(ObjectDetectorLoadingHandler _Nonnull)handler;

- (void)processImage:(CGImageRef _Nonnull)image;

@end
