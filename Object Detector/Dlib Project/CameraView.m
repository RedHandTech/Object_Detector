//
//  CameraView.m
//  Dlib Project
//
//  Created by Robert Sanders on 24/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import "CameraView.h"

#import "VideoLayer.h"

@interface CameraView ()

@property (nonatomic) BOOL isStreamActive;

@property (nonatomic, strong) VideoLayer *videoLayer;

@end

@implementation CameraView

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

#pragma mark - Private

- (VideoLayer *)cameraLayer
{
    return [VideoLayer cameraLayer];
}

- (VideoLayer *)webcamLayer
{
    return [VideoLayer webcamLayer];
}

@end

























