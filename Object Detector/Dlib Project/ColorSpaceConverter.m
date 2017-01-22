//
//  ColorSpaceConverter.m
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import "ColorSpaceConverter.h"

#include <QuartzCore/QuartzCore.h>

@implementation ColorSpaceConverter

/* 
 * Try this technique:
 * http://stackoverflow.com/questions/19310437/convert-cmsamplebufferref-to-uiimage-with-yuv-color-space
 * Else use dlib::assign_image (probs wont use GPU whereas native iOS code probs will.
 */

core_image_frame* convertFrame(core_image_frame *frame, core_image_format desiredFormat)
{
    return NULL;
}

@end
