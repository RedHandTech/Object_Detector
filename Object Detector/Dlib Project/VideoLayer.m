//
//  VideoLayer.m
//  Dlib Project
//
//  Created by Robert Sanders on 24/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import "VideoLayer.h"

#import "CameraFeed.h"
#import "ColorSpaceConverter.h"

@interface VideoLayer () <CameraFeedDelegate>

@property (nonatomic, strong) CameraFeed *cameraFeed;
@property (nonatomic) BOOL videoStreamActive;

@property (nonatomic) BOOL processingFrame;

@end

@implementation VideoLayer
{
    CGImageRef _currentFrame;
}

#pragma mark - Constructors

- (instancetype)initWithCameraFeed:(CameraFeed *)cameraFeed
{
    self = [super init];
    if (self) {
        self.cameraFeed = cameraFeed;
        
        [self configureFeed];
    }
    return self;
}

+ (VideoLayer *)layerWithCameraFeed:(CameraFeed *)cameraFeed
{
    return [[VideoLayer alloc] initWithCameraFeed:cameraFeed];
}

+ (VideoLayer *)cameraLayer
{
    CameraFeed *feed = [VideoLayer backCameraFeed];
    if (!feed) {
        return nil;
    }
    
    return [[VideoLayer alloc] initWithCameraFeed:feed];
}

+ (VideoLayer *)webcamLayer
{
    CameraFeed *feed = [VideoLayer webcamFeed];
    if (!feed) {
        return nil;
    }
    
    return [[VideoLayer alloc] initWithCameraFeed:feed];
}

#pragma mark - Public

- (void)beginVideoStream
{
    if (self.videoStreamActive) {
        return;
    }
    
    [self.cameraFeed startStream];
    
    self.videoStreamActive = YES;
}

- (void)stopVideoStream
{
    if (!self.videoStreamActive) {
        return;
    }
    
    [self.cameraFeed stopStream];
    
    self.videoStreamActive = NO;
}

#pragma mark - Private

- (void)configureFeed
{
    self.cameraFeed.delegate = self;
    if (!self.cameraFeed.isActive) {
        NSLog(@"Inactive camera feed. Opening session on back camera.");
        NSError *error = nil;
        if (![self.cameraFeed openSessionForSource:CameraSourceCamera error:&error]) {
            NSLog(@"Failed to open session on back camera: %@", error.localizedDescription);
            return;
        }
    }
}

#pragma mark - <CameraFeedDelegate>

- (void)cameraFeed:(CameraFeed *)cameraFeed didRecieveImage:(CGImageRef _Nullable)image
{
    // not called on main thread...
    
    if (self.processingFrame) {
        // skip frame
        CGImageRelease(image);
        return;
    }
    
    self.processingFrame = YES;

    if (_currentFrame != NULL) {
        CGImageRelease(_currentFrame);
    }
    
    _currentFrame = image;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.contents = (__bridge id)_currentFrame;
    });
    
    self.processingFrame = NO;
}

#pragma mark - Private Class

+ (CameraFeed *)backCameraFeed
{
    CameraFeed *feed = [[CameraFeed alloc] init];
    
    NSError *error = nil;
    if (![feed openSessionForSource:CameraSourceCamera error:&error]) {
        NSLog(@"Error opening feed for back camera: %@", error.localizedDescription);
        return nil;
    }
    
    return feed;
}

+ (CameraFeed *)webcamFeed
{
    CameraFeed *feed = [[CameraFeed alloc] init];
    
    NSError *error = nil;
    if (![feed openSessionForSource:CameraSourceWebcam error:&error]) {
        NSLog(@"Error opening feed for webcam: %@", error.localizedDescription);
        return nil;
    }
    
    return feed;
}

@end























