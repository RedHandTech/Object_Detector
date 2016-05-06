//
//  BMObjectDetectorVideoPlugin.m
//  Object Detector
//
//  Created by Robert Sanders on 31/01/2016.
//  Copyright © 2016 bmore digital ltd. All rights reserved.
//

#import "BMObjectDetectorVideoPlugin.h"
#import "BMHelper.h"

@interface BMObjectDetectorVideoPlugin ()

@property (nonatomic, strong) BMObjectDetector *objectDetector;

@end

@implementation BMObjectDetectorVideoPlugin

#pragma mark - Lifecylce

- (instancetype)initWithDetectorPath:(NSString *)path
{
    self = [super init];
    if (self) {
        self.objectDetector = [BMObjectDetector detectorWithPath:path];
    }
    return self;
}

+ (BMObjectDetectorVideoPlugin *)pluginWithDetectorPath:(NSString *)path
{
    return [[BMObjectDetectorVideoPlugin alloc] initWithDetectorPath:path];
}

#pragma mark - <BMVideoPlugin>

- (void)frameDidArrive:(BMVideoLayer *)player
{
    if (self.objectDetector.isProcessing) {
        return;
    }
    
    bool detectLandmarks = [self.delegate respondsToSelector:@selector(plugin:didRunDetectionOnFrame:objectDetector:landmark:)];
    bool standardDetection = [self.delegate respondsToSelector:@selector(plugin:didRunDetectionOnFrame:objectDetector:)];
    
    if (!detectLandmarks && !standardDetection) {
        return;
    }
    
    CGImageRef frame = [player getLatestFrameImageScaled:player.captureSource == BMCaptureSourceWebcam ? 0.4f : 0.25f];

    BMDispatchAsync(^{
        // Run detection on background thread
        
        Landmark *landmark = NULL;
        NSArray<NSValue *> *detections = [self.objectDetector processImage:frame facialLandmarks:&landmark];
        BMDispatchMain(^{
            // Notify delegate
            if (standardDetection) {
                [self.delegate plugin:self didRunDetectionOnFrame:detections objectDetector:self.objectDetector];
            }
            if (detectLandmarks) {
                [self.delegate plugin:self didRunDetectionOnFrame:detections objectDetector:self.objectDetector landmark:landmark];
            } else {
                BMLandmarkRelease(landmark);
            }
        });
        
        // Clean
        CGImageRelease(frame);
    });
}

@end




















































