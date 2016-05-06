//
//  BMObjectDetectorVideoPlugin.h
//  Object Detector
//
//  Created by Robert Sanders on 31/01/2016.
//  Copyright © 2016 bmore digital ltd. All rights reserved.
//

#include <Foundation/Foundation.h>
#import "BMObjectDetector.h"

#import "BMVideoPlugin.h"

@class BMObjectDetectorVideoPlugin;
@class BMObjectDetector;

@protocol BMObjectDetectorVideoPluginDelegate <NSObject>
@optional

/**Called when a frame of data has been run through the object detector.*/
- (void)plugin:(BMObjectDetectorVideoPlugin *)plugin didRunDetectionOnFrame:(NSArray<NSValue *> *)detections objectDetector:(BMObjectDetector *)objectDetector;
- (void)plugin:(BMObjectDetectorVideoPlugin *)plugin didRunDetectionOnFrame:(NSArray<NSValue *> *)detections objectDetector:(BMObjectDetector *)objectDetector landmark:(Landmark *)landmark;

@end

@interface BMObjectDetectorVideoPlugin : NSObject <BMVideoPlugin>

/**A unique identifier for the plugin.*/
@property (nonatomic, copy) NSString *identitifer;
/**The plugin delegate.*/
@property (nonatomic, weak) id<BMObjectDetectorVideoPluginDelegate> delegate;

/**Inits a detector with the given path.*/
- (instancetype)initWithDetectorPath:(NSString *)path;
/**Returns an initialised plugin with the given path.*/
+ (BMObjectDetectorVideoPlugin *)pluginWithDetectorPath:(NSString *)path;

@end
