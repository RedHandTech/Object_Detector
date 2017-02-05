//
//  FaceDetectorViewController.m
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import "FaceDetectorViewController.h"

#import "CameraView.h"
#import "ObjectDetector.h"

@interface FaceDetectorViewController ()

@property (nonatomic, weak) IBOutlet CameraView *cameraView;

@end

@implementation FaceDetectorViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.cameraView beginCameraFeed];
    [self setupObjectDetection];
}

#pragma mark - Private

- (void)setupObjectDetection
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"face-detector" ofType:@"svm"];
    if (!path) { return; }
    
    ObjectDetector *detector = [[ObjectDetector alloc] init];
    
    [detector loadSVMFile:path handler:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Error loading svm file: %@", error.localizedDescription);
        } else {
            [self.cameraView beginObjectDetectionWithDetector:detector handler:^(NSError *error, NSArray<Detection *> * detections, BOOL *stop){
                [self objectsDetectedWithError:error detections:detections stop:stop];
            }];
        }
    }];
}

- (void)objectsDetectedWithError:(NSError *)error detections:(NSArray<Detection *> *)detections stop:(BOOL *)stop
{
    
}

@end










