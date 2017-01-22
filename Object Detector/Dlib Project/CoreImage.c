//
//  CoreImage.c
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#include "CoreImage.h"

#include <stdlib.h>

core_image_frame* core_image_create_frame(void *data, size_t width, size_t height, size_t depth, core_image_format format)
{
    core_image_frame *frame = malloc(sizeof(core_image_frame));
    frame->image_data = data;
    frame->depth = depth;
    frame->height = height;
    frame->width = width;
    
    return frame;
}

void core_image_release_frame(core_image_frame *frame)
{
    if (frame->image_data != NULL) {
        free(frame->image_data);
    }
    free(frame);
    
    frame->image_data = NULL;
    frame = NULL;
}
