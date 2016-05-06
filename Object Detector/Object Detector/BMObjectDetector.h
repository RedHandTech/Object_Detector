//
//  BMObjectDetector.h
//  Object Detector
//
//  Created by Robert Sanders on 31/01/2016.
//  Copyright © 2016 bmore digital ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

struct Landmark {
    CGPoint **landmarks;
    int setCount;
    int pointCount;
};

@interface BMObjectDetector : NSObject

/**Whether the object detector is currently processing data. Only one set of data at a time can be processed.*/
@property (nonatomic, readonly) BOOL isProcessing;
/**The final image size for the latest analuzed image in pixels. All detection frames are given in pixel coordinates*/
@property (nonatomic, readonly) CGSize latestImageSize;

- (instancetype)initWithPath:(NSString *)path;
+ (BMObjectDetector *)detectorWithPath:(NSString *)path;

- (NSArray<NSValue *> *)processImage:(CGImageRef)image facialLandmarks:(Landmark **)landmarks;

/**Converts the detection frame to a given coordinate system.*/
- (CGRect)convertDetectionFrame:(CGRect)detection toCoordinateSpace:(CGRect)space;

/**Converts the detection frame to a given coordinate system using the given pixel size.*/
- (CGRect)convertDetectionFrame:(CGRect)detection toCoordinateSpace:(CGRect)space imagePixelSize:(CGSize)pixelSize;

- (CGPoint)convertPoint:(CGPoint)point toCoordinateSpace:(CGRect)space;
- (CGPoint)convertPoint:(CGPoint)point toCoordinateSpace:(CGRect)space imagePixelSize:(CGSize)pixelSize;

void BMLandmarkRelease(Landmark *landmark);

@end
