//
//  ColorSpaceConverter.h
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "CoreImage.h"

@interface ColorSpaceConverter : NSObject

core_image_frame* convertFrame(core_image_frame *frame, core_image_format desiredFormat);

@end
