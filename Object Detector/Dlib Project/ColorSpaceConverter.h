//
//  ColorSpaceConverter.h
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#include "CoreImage.h"

@interface ColorSpaceConverter : NSObject


/**
 Converts a given frame to the device RGB color space.

 @param frame The frame to convert.
 @return The converted frame.
 */
core_image_frame* convertFrame(core_image_frame *frame, core_image_format destinationFormat);

/**
 Creates a RGB CGImageRef from a core_image_frame.

 @param frame The core_image_frame
 @return The CGImageRef
 */
CGImageRef CGImageRefCreateWithCoreImageRGB(core_image_frame *frame);


@end
