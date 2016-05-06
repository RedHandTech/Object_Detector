//
//  BMVideoLayer.m
//  Object Detector
//
//  Created by Robert Sanders on 31/01/2016.
//  Copyright © 2016 bmore digital ltd. All rights reserved.
//

#import "BMVideoLayer.h"
#import "BMVideoInput.h"
#import "BMHelper.h"

#import "BMVideoPlugin.h"

#include <opencv2/imgproc/imgproc_c.h>

typedef struct {
    
    void *data;
    int width;
    int height;
    int nChannels;
    int bytesPerRow;
    
}BMFrameBuffer;

@interface BMVideoLayer () <BMVideoInputDelegate>

@property (nonatomic, strong) BMVideoInput *videoInput;
@property (nonatomic) BOOL processingFrame;
@property (nonatomic, strong) NSArray<id<BMVideoPlugin>> *plugins;

@property (nonatomic) BMCaptureSource captureSource;

@end

@implementation BMVideoLayer
{
    BMFrameBuffer _frameBuffer;
    CGImageRef _frameImage;
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.videoInput = [BMVideoInput input];
        self.videoInput.delegate = self;
        
        NSError *error = nil;
        if (![self.videoInput openVideoStream:BMCaptureSourceWebcam error:&error]) {
            NSLog(@"Error opening video stream. ERR: %@. %@:%@. %i", error.localizedDescription, NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame captureSource:BMCaptureSourceWebcam];
}

- (instancetype)initWithFrame:(CGRect)frame captureSource:(BMCaptureSource)captureSource
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.captureSource = captureSource;
        self.videoInput = [BMVideoInput input];
        self.videoInput.delegate = self;
        
        NSError *error = nil;
        if (![self.videoInput openVideoStream:self.captureSource error:&error]) {
            NSLog(@"Error opening video stream. ERR: %@. %@:%@. %i", error.localizedDescription, NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
        }
    }
    return self;
}

+ (BMVideoLayer *)layerWithFrame:(CGRect)frame
{
    return [[BMVideoLayer alloc] initWithFrame:frame];
}

+ (BMVideoLayer *)layerWithFrame:(CGRect)frame captureSource:(BMCaptureSource)captureSource
{
    return [[BMVideoLayer alloc] initWithFrame:frame captureSource:captureSource];
}

- (void)dealloc
{
    if (_frameBuffer.data != NULL) {
        free(_frameBuffer.data);
    }
    if (_frameImage != NULL) {
        CGImageRelease(_frameImage);
    }
}

#pragma mark - Pubic

- (void *)getLatestFrame
{
    return _frameBuffer.data;
}

- (void *)getLatestFrameCopy
{
    void *copy = malloc(sizeof(unsigned char) * _frameBuffer.bytesPerRow * _frameBuffer.height);
    memcpy(copy, _frameBuffer.data, _frameBuffer.bytesPerRow * _frameBuffer.height);
    return copy;
}

- (CGImageRef)getLatestFrameImage
{
    return _frameImage;
}

- (CGImageRef)getLatestFrameImageCopy
{
    void *cpy = malloc(sizeof(unsigned char) * _frameBuffer.bytesPerRow * _frameBuffer.height);
    memcpy(cpy, _frameBuffer.data, _frameBuffer.bytesPerRow * _frameBuffer.height);
    
    IplImage *cvImage = cvCreateImage(cvSize(_frameBuffer.width, _frameBuffer.height), IPL_DEPTH_8U, _frameBuffer.nChannels);
    cvImage->imageData = (char *)cpy;
    IplImage *converted = cvCreateImage(cvGetSize(cvImage), IPL_DEPTH_8U, 3);
    cvCvtColor(cvImage, converted, CV_BGRA2RGB);
    int flipCode = self.captureSource == BMCaptureSourceWebcam ? ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ? 0 : 1) : ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ? -2 : -1);
    if (flipCode != -2) {
        cvFlip(converted, converted, flipCode);
    }
    
    CGImageRef image = CGImageFromIplImage(converted, NO);
    
    free(cpy);
    cvReleaseImage(&cvImage);
    cvReleaseImage(&converted);
    
    return image;
}

- (CGImageRef)getLatestFrameImageScaled:(CGFloat)scaleFactor
{
    IplImage *cvImage = cvCreateImage(cvSize(_frameBuffer.width, _frameBuffer.height), IPL_DEPTH_8U, _frameBuffer.nChannels);
    cvImage->imageData = (char *)_frameBuffer.data;
    
    IplImage *converted = cvCreateImage(cvGetSize(cvImage), IPL_DEPTH_8U, 3);
    cvCvtColor(cvImage, converted, CV_BGRA2RGB);
    
    int flipCode = self.captureSource == BMCaptureSourceWebcam ? ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ? 0 : 1) : ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ? -2 : -1);
    if (flipCode != -2) {
        cvFlip(converted, converted, flipCode);
    }
    IplImage *scaled = cvCreateImage(cvSize(_frameBuffer.width * scaleFactor, _frameBuffer.height * scaleFactor), IPL_DEPTH_8U, 3);
    cvResize(converted, scaled, CV_INTER_CUBIC);
    
    CGImageRef image = CGImageFromIplImage(scaled, NO);
    
    cvReleaseImage(&cvImage);
    cvReleaseImage(&converted);
    cvReleaseImage(&scaled);
    
    return image;
}

- (void)beginStream
{
    [self.videoInput startStream];
}

- (void)endStream
{
    [self.videoInput stopStream];
}

- (void)addPlugin:(id<BMVideoPlugin>)plugin
{
    if ([self.plugins containsObject:plugin]) {
        return;
    }
    
    if (!self.plugins) {
        self.plugins = @[plugin];
    } else {
        NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.plugins];
        [temp addObject:plugin];
        self.plugins = temp;
    }
}

- (void)removePlugin:(id<BMVideoPlugin>)plugin
{
    if (![self.plugins containsObject:plugin]) {
        return;
    }
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.plugins];
    [temp removeObject:plugin];
    self.plugins = temp;
}

#pragma mark - Private

- (void)processFrameBuffer
{
    // Will be in BGRA format
    IplImage *cvImage = cvCreateImage(cvSize(_frameBuffer.width, _frameBuffer.height), IPL_DEPTH_8U, _frameBuffer.nChannels);
    cvImage->imageData = (char *)_frameBuffer.data;
    // Convert to RGB
    IplImage *converted = cvCreateImage(cvGetSize(cvImage), IPL_DEPTH_8U, 3);
    cvCvtColor(cvImage, converted, CV_BGRA2RGB);
    // Flip image
    int flipCode = self.captureSource == BMCaptureSourceWebcam ? ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ? 0 : 1) : ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ? -2 : -1);
    if (flipCode != -2) {
        cvFlip(converted, converted, flipCode);
    }
    
    // Convert to CGImage
    if (_frameImage != NULL) {
        CGImageRelease(_frameImage);
    }
    _frameImage = CGImageFromIplImage(converted, NO);
    
    // Set layer contents
    self.contents = (__bridge id)_frameImage;
    
    // Clean up
    cvReleaseImage(&cvImage);
    cvReleaseImage(&converted);

    // Let the plugins do their thing
    [self notifyPlugins];
    
    // NOTE: By putting this here it means that plugins can slow down the frame rate
    self.processingFrame = NO;
}

- (void)notifyPlugins
{
    for (id<BMVideoPlugin> plugin in self.plugins) {
        [plugin frameDidArrive:self];
    }
}

#pragma mark - <BMVideoInputDelegate>

- (void)videoInput:(BMVideoInput *)input didCaptureFrame:(void *)data width:(size_t)width height:(size_t)height depth:(size_t)depth bytesPerRow:(size_t)bytesPerRow
{
    if (data == NULL) {
        return;
    }
    
    if (self.processingFrame) {
        free(data);
        return;
    }
    self.processingFrame = YES;
    
    if (_frameBuffer.data != NULL) {
        free(_frameBuffer.data);
        _frameBuffer.data = NULL;
    }
    
    _frameBuffer.data = data;
    _frameBuffer.height = (int)height;
    _frameBuffer.width = (int)width;
    _frameBuffer.bytesPerRow = (int)bytesPerRow;
    _frameBuffer.nChannels = (int)depth;
    
    [self processFrameBuffer];
}

#pragma mark - Funcs

// Assumes RGB data format
CGImageRef CGImageFromIplImage(IplImage *cvImage, bool greyscale) {
    
    CGColorSpaceRef colorSpace = greyscale ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB();
    NSData *imageData = [NSData dataWithBytes:cvImage->imageData length:cvImage->imageSize];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((CFDataRef)imageData);
    
    CGImageRef imageRef = CGImageCreate(cvImage->width, cvImage->height, cvImage->depth, cvImage->depth * cvImage->nChannels, cvImage->widthStep, colorSpace, kCGImageAlphaNone | kCGBitmapByteOrderDefault, dataProvider, NULL, NO, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    CGColorSpaceRelease(colorSpace);
    
    return imageRef;
}

@end
























