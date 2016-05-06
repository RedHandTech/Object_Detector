//
//  BMVideoInput.m
//  Hand Detector
//
//  Created by Freelance on 27/01/2016.
//  Copyright © 2016 bmore. All rights reserved.
//

#import "BMVideoInput.h"

#import <AVFoundation/AVFoundation.h>

#import "BMHelper.h"


#define WEBCAM_ID @"com.apple.avfoundation.avcapturedevice.built-in_video:1"
#define CAMERA_ID @"com.apple.avfoundation.avcapturedevice.built-in_video:0"
#define DOMAIN_KEY @"BMVideoInputDomain"


@interface BMVideoInput () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic) BOOL isProcessingFrame;

@end

@implementation BMVideoInput

#pragma mark - Lifecycle

+ (BMVideoInput *)input
{
    return [[BMVideoInput alloc] init];
}

#pragma mark - Public

- (BOOL)openVideoStream:(BMCaptureSource)captureSource error:(NSError *__autoreleasing *)error
{
    self.captureSession = [[AVCaptureSession alloc] init];
    
    // Configure input
    
    NSString *ID = captureSource == BMCaptureSourceWebcam ? WEBCAM_ID : CAMERA_ID;
    AVCaptureDevice *device = [AVCaptureDevice deviceWithUniqueID:ID];
    
    if (!device) {
        if (error) {
            NSString *description = [NSString stringWithFormat:@"Failed to get device with ID: %@. %@:%@. %i", ID, NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__];
            *error = [NSError errorWithDomain:DOMAIN_KEY code:0 userInfo:@{NSLocalizedDescriptionKey : description}];
        }
        return NO;
    }
    
    NSError *err = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&err];
    if (err) {
        if (error) {
            *error = err;
        }
        return NO;
    }
    
    [self.captureSession addInput:input];
    
    // Configure output
    
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    dispatch_queue_t queue = dispatch_queue_create("outputQueue", DISPATCH_QUEUE_SERIAL);
    
    [output setSampleBufferDelegate:self queue:queue];
    output.videoSettings = @{(__bridge id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
    
    [self.captureSession addOutput:output];
    
    return YES;
}

- (void)startStream
{
    if (self.captureSession.isRunning) {
        return;
    }
    [self.captureSession startRunning];
}

- (void)stopStream
{
    if (!self.captureSession.isRunning) {
        return;
    }
    [self.captureSession stopRunning];
}

#pragma mark - Private

#pragma mark - <AVCaptureVideoDataOutputSampleBufferDelegate>

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (self.isProcessingFrame) {
        return;
    }
    
    self.isProcessingFrame = YES;
    
    // Called when a frame arrives
    // Should be in BGRA format
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    unsigned char *raw = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Copy memory into allocated buffer
    unsigned char *buffer = (unsigned char *)malloc(sizeof(unsigned char) * bytesPerRow * height);
    memcpy(buffer, raw, bytesPerRow * height);
    
    // Release image data
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    BOOL shouldReleaseData = YES;
    
    // Delegate handlers
    if ([self.delegate respondsToSelector:@selector(videoInput:didCaptureFrame:width:height:depth:bytesPerRow:)]) {
        shouldReleaseData = NO;
        BMDispatchMain(^{
            [self.delegate videoInput:self didCaptureFrame:buffer width:width height:height depth:4 bytesPerRow:bytesPerRow];
        });
    }
    
    // Block handlers
    if (self.frameDataHandler) {
        shouldReleaseData = NO;
        self.frameDataHandler(buffer);
    }
    
    // Clean
    if (shouldReleaseData) {
        free(buffer);
    }
    
    self.isProcessingFrame = NO;
}

@end




















































