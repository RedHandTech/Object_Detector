//
//  Detection.m
//  Dlib Project
//
//  Created by Robert Sanders on 26/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import "Detection.h"

@implementation Detection
{
    Bounds _bounds;
}

#pragma mark - Constructors

- (instancetype)initWithPixelBounds:(Bounds)bounds
{
    self = [super init];
    if (self) {
        _bounds = bounds;
    }
    return self;
}

+ (Detection *)detectionWithPixelBounds:(Bounds)bounds
{
    return [[Detection alloc] initWithPixelBounds:bounds];
}

#pragma mark - Overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"X: %li, Y: %li, Width: %li, Height: %li", _bounds.x, _bounds.y, _bounds.width, _bounds.height];
}

@end
