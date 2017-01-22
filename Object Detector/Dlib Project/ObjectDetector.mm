//
//  ObjectDetector.m
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import "ObjectDetector.h"

#include <dlib/image_processing.h>
#include <dlib/image_io.h>

using namespace dlib;

typedef scan_fhog_pyramid<pyramid_down<6> > image_scanner_type;

@interface ObjectDetector ()

@property (nonatomic) object_detector<image_scanner_type> detector;

@end

@implementation ObjectDetector

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
            if (handler) {
                handler(YES, nil);
            }
        });
    });
}

#pragma mark - Private

- (NSError *)errorWithCode:(ObjectDetectorError)code message:(NSString *)message
{
    NSDictionary *info = message ? @{NSLocalizedDescriptionKey: message} : nil;
    return [NSError errorWithDomain:@"ObjectDetectorDomain" code:code userInfo:info];
}

@end





















