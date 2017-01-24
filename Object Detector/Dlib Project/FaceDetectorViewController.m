//
//  FaceDetectorViewController.m
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import "FaceDetectorViewController.h"

#import <Objection/Objection.h>

#import "FaceDetectorViewModel.h"
#import "CameraView.h"

@interface FaceDetectorViewController ()

@property (nonatomic, weak) IBOutlet CameraView *cameraView;

@property (nonatomic, strong) FaceDetectorViewModel *viewModel;

@end

@implementation FaceDetectorViewController

objection_requires(@"viewModel")

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[JSObjection defaultInjector] injectDependencies:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.cameraView beginCameraFeed];
}

@end










