//
//  CameraView.m
//  Dlib Project
//
//  Created by Robert Sanders on 24/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import "CameraView.h"

#import "VideoLayer.h"
#import "ObjectDetector.h"

@interface CameraView ()

@property (nonatomic) BOOL isStreamActive;
@property (nonatomic, strong) VideoLayer *videoLayer;
@property (nonatomic, strong) ObjectDetector *objectDetector;
@property (nonatomic, copy) CameraViewObjectDetectionHandler objectDetectionHandler;

@property (nonatomic) BOOL processingFrame;

@end

@implementation CameraView
{
    dispatch_queue_t _detectionQueue;
}

#pragma mark - Public

- (void)beginCameraFeed
{
    if (self.isStreamActive) {
        NSLog(@"Camera stream already active.");
        return;
    }
    
    self.videoLayer = [self cameraLayer];
    
    if (!self.videoLayer) {
        NSLog(@"Error setting up feed. Could not get feed for front camera.");
    }
    
    self.videoLayer.frame = self.layer.bounds;
    [self.layer addSublayer:self.videoLayer];
    [self.videoLayer beginVideoStream];
    
    self.isStreamActive = YES;
}

- (void)beginWebcamFeed
{
    if (self.isStreamActive) {
        NSLog(@"Camera stream already active.");
        return;
    }
    
    self.videoLayer = [self webcamLayer];
    
    if (!self.videoLayer) {
        NSLog(@"Error setting up feed. Could not get feed for webcam.");
    }
    
    self.videoLayer.frame = self.layer.bounds;
    [self.layer addSublayer:self.videoLayer];
    [self.videoLayer beginVideoStream];
    
    self.isStreamActive = YES;
}

- (void)stopStream
{
    if (!self.isStreamActive) {
        return;
    }
    
    [self.videoLayer stopVideoStream];
    
    self.isStreamActive = NO;
}

- (void)beginObjectDetectionWithDetector:(ObjectDetector *)objectDetector handler:(CameraViewObjectDetectionHandler)handler
{
    __weak typeof(self) welf = self;
    
    // NOTE:Probably not on main thread
    self.objectDetector = objectDetector;
    self.objectDetectionHandler = handler;
    _detectionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    self.videoLayer.refresh = ^{
        [welf handleFrameRefreshWithObjectDetectionHandler:handler];
    };
}

#pragma mark - Private

- (VideoLayer *)cameraLayer
{
    return [VideoLayer cameraLayer];
}

- (VideoLayer *)webcamLayer
{
    return [VideoLayer webcamLayer];
}

- (void)handleFrameRefreshWithObjectDetectionHandler:(CameraViewObjectDetectionHandler)handler
{
    // TODO: Work out where crash occurs.
    // run object detection
    
    __weak typeof(self) welf = self;
    
    // check to see if object detection is currently in progress
    if (self.processingFrame) { return; }
    if (!handler) { return; }
    
    // get image copy
    CGImageRef frame = self.videoLayer.currentFrameCopy;
    if (frame == NULL) { return; }
    
    // process the image
    /*
    [self.objectDetector processImage:frame detectionHandler:^(BOOL success, NSError * _Nullable error, NSArray<Detection *> * _Nullable detections){
        BOOL stop = NO;
        handler(error, detections, &stop);
        
        if (stop) {
            welf.videoLayer.refresh = nil;
            welf.objectDetectionHandler = nil;
            welf.objectDetector = nil;
        }
        
        self.processingFrame = NO;
    }];
     */

    [self.objectDetector processImage:frame releaseAfterUse:YES detectionHandler:^(BOOL success, NSError * error, NSArray<Detection *> * detections) {
        if (success) {
            NSLog(@"Processed frame %i", detections.count);
        }
    }];
}

#pragma mark - Overrides

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.videoLayer.frame = self.layer.bounds;
}

@end

























