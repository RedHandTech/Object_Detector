//
//  FaceDetectorViewController.m
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import "FaceDetectorViewController.h"
#import "FaceDetectorViewModel.h"

@interface FaceDetectorViewController ()

@property (nonatomic, strong) FaceDetectorViewModel *viewModel;

@end

@implementation FaceDetectorViewController

- (void)viewDidLoad
{
    // TODO: Use dependency injection!
    self.viewModel = [[FaceDetectorViewModel alloc] init];
}

@end
