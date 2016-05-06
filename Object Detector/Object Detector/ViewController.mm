//
//  ViewController.m
//  Object Detector
//
//  Created by Robert Sanders on 31/01/2016.
//  Copyright © 2016 bmore digital ltd. All rights reserved.
//

#import "ViewController.h"
#import "BMVideoLayer.h"
#import "BMObjectDetectorVideoPlugin.h"
#import "BMObjectDetector.h"
#import "BMObjectView.h"

#define FACE_DETECTOR_PATH [[NSBundle mainBundle] pathForResource:@"face-detector" ofType:@"svm"]
#define FACE_DETECTOR_IDENTIFIER @"FACE_DETECTOR"

#define FIREFOX_DETECTOR_PATH [[NSBundle mainBundle] pathForResource:@"firefox-detector" ofType:@"svm"]
#define FIREFOX_DETECTOR_IDENTIFIER @"FIREFOX_DETECTOR"

#define OPEN_HAND_DETECTOR_PATH [[NSBundle mainBundle] pathForResource:@"openhand-detector" ofType:@"svm"]
#define OPEN_HAND_DETECTOR_IDENTIFIER @"OPEN_HAND_DETECTOR"

@interface ViewController () <BMObjectDetectorVideoPluginDelegate>

@property (nonatomic, strong) BMVideoLayer *videoLayer;
@property (nonatomic, strong) CALayer *faceLayer;
@property (nonatomic, strong) BMObjectView *objectView;

@property (nonatomic, strong) NSArray <CALayer *> *featureLayers;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.detectionType == BMDetectionTypeLogo) {
        self.objectView = [BMObjectView objectViewWithFrame:CGRectMake(1, 1, 1, 1) sceneNamed:@"scene.scnassets/table.dae"];
        self.objectView.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Setup video layer
    self.videoLayer = [BMVideoLayer layerWithFrame:self.view.bounds captureSource:self.detectionType == BMDetectionTypeHand ? BMCaptureSourceCamera : BMCaptureSourceWebcam];
    [self.view.layer insertSublayer:self.videoLayer atIndex:0];
    
    self.faceLayer = [CALayer layer];
    self.faceLayer.frame = CGRectZero;
    self.faceLayer.anchorPoint = CGPointZero;
    self.faceLayer.backgroundColor = [[[UIColor redColor] colorWithAlphaComponent:0.3] CGColor];
    [self.videoLayer addSublayer:self.faceLayer];
    
    [self.view addSubview:self.objectView];
    
    // Setup object detection plugin
    BMObjectDetectorVideoPlugin *plugin = nil;
    switch (self.detectionType) {
        case BMDetectionTypeHand:
        {
            plugin = [BMObjectDetectorVideoPlugin pluginWithDetectorPath:OPEN_HAND_DETECTOR_PATH];
            plugin.identitifer = OPEN_HAND_DETECTOR_IDENTIFIER;
        }
            break;
        case BMDetectionTypeLogo:
        {
            plugin = [BMObjectDetectorVideoPlugin pluginWithDetectorPath:FIREFOX_DETECTOR_PATH];
            plugin.identitifer = FIREFOX_DETECTOR_IDENTIFIER;
        }
            break;
        case BMDetectionTypeFace:
        {
            plugin = [BMObjectDetectorVideoPlugin pluginWithDetectorPath:FACE_DETECTOR_PATH];
            plugin.identitifer = FACE_DETECTOR_IDENTIFIER;
        }
            break;
        default:
            break;
    }
    
    plugin.delegate = self;
    [self.videoLayer addPlugin:plugin];
    
    // Start stream
    [self.videoLayer beginStream];
}

#pragma mark - Private

- (void)updateFaceLayer:(CGRect)frame
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.fromValue = [NSValue valueWithCGPoint:self.faceLayer.position];
    anim.toValue = [NSValue valueWithCGPoint:frame.origin];
    anim.duration = 0.2;
    anim.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *sizeAnim = [CABasicAnimation animationWithKeyPath:@"bounds"];
    sizeAnim.fromValue = [NSValue valueWithCGRect:self.faceLayer.bounds];
    sizeAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    sizeAnim.duration = 0.2;
    sizeAnim.fillMode = kCAFillModeForwards;
    
    [self.faceLayer addAnimation:anim forKey:@"facePositionAnimation"];
    [self.faceLayer addAnimation:sizeAnim forKey:@"faceBoundsAnimation"];
    
    self.faceLayer.position = frame.origin;
    self.faceLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)displayHeartScene:(CGRect)frame
{
    if (self.objectView.hidden) {
        self.objectView.hidden = NO;
    }
    [self.objectView updateFrame:frame];
}

- (void)updateFacePoints:(CGPoint *)points objectDetector:(BMObjectDetector *)detector completion:(void (^)(void))handler
{
    if (!self.featureLayers) {
        NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:68];
        for (int i = 0; i < 68; i++) {
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.bounds = CGRectMake(0, 0, 5, 5);
            layer.path = [[UIBezierPath bezierPathWithOvalInRect:layer.bounds] CGPath];
            layer.backgroundColor = [[UIColor greenColor] CGColor];
            [temp addObject:layer];
            
            [self.videoLayer addSublayer:layer];
        }
        self.featureLayers = temp;
    }
    
    if (points == NULL) {
        if (handler) {
            handler();
        }
        return;
    }
    
    for (int i = 0; i < self.featureLayers.count; i++) {
        
        CGPoint converted = [detector convertPoint:points[i] toCoordinateSpace:self.videoLayer.bounds];
        if (isnan(converted.x)) {
            converted.x = 0;
        }
        if (isnan(converted.y)) {
            converted.y = 0;
        }
        self.featureLayers[i].frame = CGRectMake(converted.x, converted.y, 5, 5);
    }
    
    if (handler) {
        handler();
    }
}

#pragma mark - <BMObjectDetectorVideoPluginDelegate>

- (void)plugin:(BMObjectDetectorVideoPlugin *)plugin didRunDetectionOnFrame:(NSArray<NSValue *> *)detections objectDetector:(BMObjectDetector *)objectDetector landmark:(Landmark *)landmark
{
    // iPad Air 2 0.2-0.4 secs processing time
    // iPad Air 1 0.7-0.8 secs processing time
    
    /*
    if (!detections.count) {
        [self updateFaceLayer:CGRectZero];
        return;
    }
    
    CGRect convertedRect = [objectDetector convertDetectionFrame:[detections.lastObject CGRectValue] toCoordinateSpace:self.videoLayer.bounds];
    
    [self updateFaceLayer:convertedRect];
    */
     
    [self updateFacePoints:landmark->landmarks[landmark->setCount - 1] objectDetector:objectDetector completion:^{
        BMLandmarkRelease(landmark);
    }];
    
    /*
    if (self.detectionType == BMDetectionTypeLogo) {
        [self displayHeartScene:convertedRect];
    }
     */
}


@end















































