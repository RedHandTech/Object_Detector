//
//  CoreImage.h
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#include <stdio.h>

typedef enum {
    kCoreImageFormat_rgb,
    kCoreImageFormat_rgba,
    kCoreImageFormat_bgr,
    kCoreImageFormat_bgra,
    kCoreImageFormat_greyscale
}core_image_format;

typedef struct {
    
    void *image_data;
    size_t width;
    size_t height;
    size_t depth;
    core_image_format image_format;
    
}core_image_frame;


/**
 Creates a core_image_frame on the heap.

 @param data A pointer to the data.
 @param width The number of pixel per row.
 @param height The number of pixels per column.
 @param depth The number of channels per pixel
 @param format The pixel format
 @return The instantiated image format.
 */
core_image_frame* core_image_create_frame(void *data, size_t width, size_t height, size_t depth, core_image_format format);

/**
 Frees a core_image_frame allocation.

 @param frame The core_image_frame to release.
 */
void core_image_release_frame(core_image_frame *frame);









