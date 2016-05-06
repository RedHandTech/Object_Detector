//
//  BMObjectDetector.m
//  Object Detector
//
//  Created by Robert Sanders on 31/01/2016.
//  Copyright © 2016 bmore digital ltd. All rights reserved.
//

#import "BMObjectDetector.h"

#include <dlib/image_processing.h>
#include <dlib/image_io.h>

using namespace dlib;
using namespace std;

typedef scan_fhog_pyramid<pyramid_down<6> > image_scanner_type;

#define TEMP_IMAGE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"temp.jpg"]

@interface BMObjectDetector ()

@property (nonatomic) object_detector<image_scanner_type> detector;
@property (nonatomic) shape_predictor sp;
@property (nonatomic) BOOL initialised;

@property (nonatomic) BOOL isProcessing;

@property (nonatomic) CGSize latestImageSize;

@end

@implementation BMObjectDetector

#pragma mark - Lifecycle

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        
        [self initialiseObjectDetector:path];
    }
    return self;
}

+ (BMObjectDetector *)detectorWithPath:(NSString *)path
{
    return [[BMObjectDetector alloc] initWithPath:path];
}

#pragma mark - Public

- (NSArray<NSValue *> *)processImage:(CGImageRef)image facialLandmarks:(Landmark **)landmarks
{
    if (!self.initialised) {
        NSLog(@"Error: No object detector is currently initalised. %@:%@. %i", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
        return nil;
    }
    if (self.isProcessing) {
        NSLog(@"Error: Cannot currently accept data. %@:%@. %i", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
        return nil;
    }
    self.isProcessing = YES;
    
    NSDate *date = [NSDate date];
    
    NSError *error = nil;
    if (![UIImageJPEGRepresentation([UIImage imageWithCGImage:image], 1.0) writeToFile:TEMP_IMAGE_PATH options:NSDataWritingAtomic error:&error]) {
        NSLog(@"Error writing image to disk: %@. %@:%@. %i", error.localizedDescription, NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
        return nil;
    }
    
    array2d<unsigned char> img;
    load_image(img, TEMP_IMAGE_PATH.UTF8String);
    
    pyramid_up(img);
    
    self.latestImageSize = CGSizeMake(img.nc(), img.nr());
    
    std::vector<dlib::rectangle> dets = self.detector(img);
    
    std::vector<full_object_detection> shapes;
    for (unsigned long i = 0; i < dets.size(); i++) {
        full_object_detection shape = self.sp(img, dets[i]);
        shapes.push_back(shape);
    }
    
    NSMutableArray *rectArr = [[NSMutableArray alloc] initWithCapacity:dets.size()];
    
    for (int i = 0; i < dets.size(); i++) {
        [rectArr addObject:[NSValue valueWithCGRect:CGRectFromDLIBRect(dets[i])]];
    }
    
    // Malloc landmarks
    
    *landmarks = BMLandmarkCreate((int)shapes.size(), 68);
    (*landmarks)->landmarks = (CGPoint **)malloc(sizeof(CGPoint *) * shapes.size());
    
    for (int i = 0; i < shapes.size(); i++) {
        (*landmarks)->landmarks[i] = (CGPoint *)malloc(sizeof(CGPoint) * 68);
        for (int j = 0; j < 68; j++) {
            (*landmarks)->landmarks[i][j] = CGPointMake(shapes[i].part(j).x(), shapes[i].part(j).y());
        }
    }
    
    cout << "Elapsed time: " << [[NSDate date] timeIntervalSinceDate:date] << endl;
    
    self.isProcessing = NO;
    
    return rectArr;
}

- (CGRect)convertDetectionFrame:(CGRect)detection toCoordinateSpace:(CGRect)space
{
    return [self convertDetectionFrame:detection toCoordinateSpace:space imagePixelSize:self.latestImageSize];
}

- (CGRect)convertDetectionFrame:(CGRect)detection toCoordinateSpace:(CGRect)space imagePixelSize:(CGSize)pixelSize
{
    float xPercent = detection.origin.x / pixelSize.width;
    float yPercent = detection.origin.y / pixelSize.height;
    float widthPercent = detection.size.width / pixelSize.width;
    float heightPercent = detection.size.height / pixelSize.height;
    return CGRectMake(space.size.width * xPercent, space.size.height * yPercent, space.size.width * widthPercent, space.size.height * heightPercent);
}

- (CGPoint)convertPoint:(CGPoint)point toCoordinateSpace:(CGRect)space
{
    return [self convertPoint:point toCoordinateSpace:space imagePixelSize:self.latestImageSize];
}

- (CGPoint)convertPoint:(CGPoint)point toCoordinateSpace:(CGRect)space imagePixelSize:(CGSize)pixelSize
{
    float xPercent = point.x / pixelSize.width;
    float yPercent = point.y / pixelSize.height;
    
    return  CGPointMake(space.size.width * xPercent, space.size.height * yPercent);
}

#pragma mark - Private

- (void)initialiseObjectDetector:(NSString *)path
{
    if (![path.pathExtension isEqualToString:@"svm"] || ![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"Error initialising object detector. Invalid path: %@. %@:%@. %i", path, NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
        return;
    }
    
    object_detector<image_scanner_type> det;
    deserialize(path.UTF8String) >> det;
    
    self.detector = det;
    
    // Load landmark data detector
    NSString *landmarkPath = [[NSBundle mainBundle] pathForResource:@"shape_predictor_68_face_landmarks" ofType:@"dat"];
    if (!landmarkPath) {
        NSLog(@"Error finding respource: shape_predictor_68_face_landmarks.dat");
    }
    shape_predictor shapePred;
    deserialize(landmarkPath.UTF8String) >> shapePred;
    
    self.sp = shapePred;
    
    self.initialised = YES;
}

#pragma mark - Funcs

CGRect CGRectFromDLIBRect(dlib::rectangle rect) {
    return CGRectMake(rect.left(), rect.top(), rect.width(), rect.height());
}

Landmark* BMLandmarkCreate(int setCount, int sets) {
    
    Landmark *mark = (Landmark *)malloc(sizeof(Landmark));
    mark->setCount = setCount;
    mark->pointCount = sets;

    return mark;
}

void BMLandmarkRelease(Landmark *landmark) {
    
    if (landmark == NULL) {
        return;
    }
    
    if (landmark->landmarks != NULL) {
        for (int i = 0; i < landmark->setCount; i++) {
            if (landmark->landmarks[i] == NULL) {
                continue;
            }
            free(landmark->landmarks[i]);
        }
        free(landmark->landmarks);
    }
    
    free(landmark);
}

@end

























































