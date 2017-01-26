//
//  Detection.h
//  Dlib Project
//
//  Created by Robert Sanders on 26/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    long x;
    long y;
    long width;
    long height;
}Bounds;

/**
 A Detection instance represents the bounds, and any associated meta-data, of a dlib object detecion.
 */
@interface Detection : NSObject

/**
 Creates a new Detection instance with the pixel bounds of the detection.

 @param bounds The bounds of the detecion in pixels.
 @return The Detection instance.
 */
- (instancetype _Nonnull)initWithPixelBounds:(Bounds)bounds;

/**
 Creates a new Detection instance with the pixel bounds of the detection.
 
 @param bounds The bounds of the detecion in pixels.
 @return The Detection instance.
 */
+ (Detection * _Nonnull)detectionWithPixelBounds:(Bounds)bounds;

@end
