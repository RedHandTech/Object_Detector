//
//  ObjectDetector.m
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import "ObjectDetector.h"

#import <UIKit/UIKit.h>

#import "Detection.h"

#include <dlib/image_processing.h>
#include <dlib/image_io.h>

#define TEMP_IMAGE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"temp.jpg"]

using namespace dlib;

typedef scan_fhog_pyramid<pyramid_down<6> > image_scanner_type;

@interface ObjectDetector ()

@property (nonatomic) object_detector<image_scanner_type> detector;
@property (nonatomic) BOOL processingImage;
@property (nonatomic) BOOL isObjectDetectorReady;

@end

@implementation ObjectDetector
{
    dispatch_queue_t _detectionQueue;
}

#pragma mark - Constructors

#pragma mark - Public

- (void)loadSVMFile:(NSString *)path handler:(ObjectDetectorLoadingHandler)handler
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if (handler) {
            NSError *error = [self errorWithCode:ObjectDetectorErrorInvalidFilePath message:@"Unable to load SVM file"];
            handler(NO, error);
        }
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        object_detector<image_scanner_type> det;
        deserialize(path.UTF8String) >> det;
        self.detector = det;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // setup detection queue
            _detectionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
            if (handler) {
                self.isObjectDetectorReady = YES;
                handler(YES, nil);
            }
        });
    });
}

- (void)processImage:(CGImageRef)image detectionHandler:(ObjectDetectorProcessingHandler _Nonnull)detectionHandler
{
    [self processImage:image releaseAfterUse:NO detectionHandler:detectionHandler];
}

- (void)processImage:(CGImageRef)image releaseAfterUse:(BOOL)releaseAfterUse detectionHandler:(ObjectDetectorProcessingHandler)detectionHandler
{
    if (self.processingImage) {
        
        if (releaseAfterUse) {
            CGImageRelease(image);
        }
        
        NSError *error = [self errorWithCode:ObjectDetectorErrorAlreadyProcessingImage message:@"Already processing image."];
        if (detectionHandler) { detectionHandler(NO, error, nil); }
        return;
    }
    
    if (!self.isObjectDetectorReady) {
        
        if (releaseAfterUse) {
            CGImageRelease(image);
        }
        
        NSError *error = [self errorWithCode:ObjectDetectorErrorObjectDetectorNotLoaded message:@"Already processing image."];
        if (detectionHandler) { detectionHandler(NO, error, nil); }
        return;
    }
    
    self.processingImage = YES;
    
    dispatch_async(_detectionQueue, ^{
        
        /*
         * NOTE: The following code is not efficient.
         * A better way would be to convert the CGImageRef to a Open CV image and then convert that to the dlib image.
         * This would only involve pointer assigment and wouldn't actually copy the values of the data accross.
         */
        
        NSLog(@"begin");
        
        UIImage *uiImage = [UIImage imageWithCGImage:image];
        NSError *error = nil;
        if (![UIImageJPEGRepresentation(uiImage, 1.0) writeToFile:TEMP_IMAGE_PATH options:NSDataWritingAtomic error:&error]) {
            NSLog(@"Failed to write image to path: %@. Error: %@", TEMP_IMAGE_PATH, error.localizedDescription);
            return;
        }
        
        array2d<unsigned char> dlibImg;
        load_image(dlibImg, TEMP_IMAGE_PATH.UTF8String);
        pyramid_up(dlibImg);
        
        std::vector<dlib::rectangle> detections = self.detector(dlibImg);
        
        NSLog(@"Detected: %lu", detections.size());
        
        /*
        // get image info
        size_t width = CGImageGetWidth(image);
        size_t height = CGImageGetHeight(image);
        //size_t bytesPerRow = CGImageGetBytesPerRow(image);
        //size_t bytesPerPixel = bytesPerRow / width;
        
        // get image data
        CGDataProviderRef dataProvider = CGImageGetDataProvider(image);
        CFDataRef data = CGDataProviderCopyData(dataProvider);
        const unsigned char *rawData = CFDataGetBytePtr(data);
        
        // setup dlib rgb image
        array2d<rgb_pixel> dlibImg;
        dlibImg.set_size(width, height);
        
        // copy values into dlib image
        dlibImg.reset();
        long position = 0;
        while (dlibImg.move_next()) {
            rgb_pixel& pixel = dlibImg.element();
            long bufLocation = position * 3;
            char r = rawData[bufLocation];
            char g = rawData[bufLocation + 1];
            char b = rawData[bufLocation + 2];
            
            pixel = rgb_pixel(r, g, b);
            
            position++;
        }
        
        NSLog(@"Data converted");
        
        // release quartz resources
        CGDataProviderRelease(dataProvider);
        CFRelease(data);
        
        // TODO: Work out leaks here... tricky buggers...
        //CGImageRelease(image);
        
        // apply object detector
        pyramid_up(dlibImg);
        std::vector<dlib::rectangle> detectionBounds = self.detector(dlibImg);
        
        NSLog(@"Detection run: %lu", detectionBounds.size());
         */
        
        /*
         * Here is where shape / landmark detection can take place
         */
        
        /*
        // convert detections into objc
        NSMutableArray *detections = [[NSMutableArray alloc] initWithCapacity:detectionBounds.size()];
        for (int i = 0; i < detectionBounds.size(); i++) {
            Bounds b;
            b.x = detectionBounds[i].left();
            b.y = detectionBounds[i].top();
            b.width = detectionBounds[i].width();
            b.height = detectionBounds[i].height();
            [detections addObject:[Detection detectionWithPixelBounds:b]];
        }
         */
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (detectionHandler) { detectionHandler(YES, nil, @[]); }
        });
        
        CGImageRelease(image);
        
        self.processingImage = NO;
    });
}

#pragma mark - Private

- (NSError *)errorWithCode:(ObjectDetectorError)code message:(NSString *)message
{
    NSDictionary *info = message ? @{NSLocalizedDescriptionKey: message} : nil;
    return [NSError errorWithDomain:@"ObjectDetectorDomain" code:code userInfo:info];
}

@end





















