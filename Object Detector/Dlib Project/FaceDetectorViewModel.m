//
//  FaceDetectorViewModel.m
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import "FaceDetectorViewModel.h"

#import "ObjectDetector.h"

#import "CameraFeed.h"

@interface FaceDetectorViewModel ()

@property (nonatomic, strong) ObjectDetector *objectDetector;

@property (nonatomic, strong) CameraFeed *test;

@end

@implementation FaceDetectorViewModel

#pragma mark - Constructors

- (instancetype)init
{
    self = [super init];
    if (self) {
        // TODO: Use dependency injection!
        [self setup];
    }
    return self;
}

#pragma mark - Private

- (void)setup
{
    self.objectDetector = [[ObjectDetector alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"face-detector" ofType:@"svm"];
    if (!path) {
        // TODO: Handle error...
        NSLog(@"AHH NOOOO!");
        return;
    }
    
    [self.objectDetector loadSVMFile:path handler:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"AHH NOOO: %@", error.localizedDescription);
        } else {
            NSLog(@"Loaded SVM file. Alls good!");
        }
    }];
}

@end














