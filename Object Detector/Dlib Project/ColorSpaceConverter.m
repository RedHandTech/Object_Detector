//
//  ColorSpaceConverter.m
//  Dlib Project
//
//  Created by Robert Sanders on 21/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import "ColorSpaceConverter.h"

@implementation ColorSpaceConverter

/* 
 * TODO: re-write this code to take advantage of GPU
 */

core_image_frame* convertFrame(core_image_frame *frame, core_image_format destinationFormat)
{
    return NULL;
}

CGImageRef CGImageRefCreateWithCoreImageRGB(core_image_frame *frame)
{
    NSLog(@"MARK");
    core_image_frame *converted = convertBGRA2RGB(frame);
    NSLog(@"MARK");
    core_image_release_frame(frame);
    NSLog(@"MARK");
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSLog(@"MARK");
    NSData *imageData = [NSData dataWithBytes:converted->image_data
                                       length:converted->width * converted->height * converted->depth];
    NSLog(@"MARK");
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((CFDataRef)imageData);
    NSLog(@"MARK");
    
    CGImageRef image = CGImageCreate(converted->width,
                                     converted->height,
                                     8 * converted->depth,
                                     8,
                                     converted->width * converted->depth,
                                     colorSpace,
                                     kCGImageAlphaNone | kCGBitmapByteOrderDefault,
                                     dataProvider,
                                     NULL,
                                     NO,
                                     kCGRenderingIntentDefault);
    NSLog(@"MARK");
    
    CGDataProviderRelease(dataProvider);
    NSLog(@"MARK");
    CGColorSpaceRelease(colorSpace);
    NSLog(@"MARK");
    
    core_image_release_frame(converted);
    NSLog(@"MARK");
    
    return image;
}

#pragma mark - Private

core_image_frame* convertBGRA2RGB(core_image_frame *frame)
{
    unsigned char *data = (unsigned char *)frame->image_data;
    unsigned char *convertedData = malloc(frame->width * frame->height * 3);
    
    for (int i = 0; i < frame->height; i ++) {
        
        int originFirstRowByte = i * (int)frame->width * (int)frame->depth;
        int destinationFirstRowByte = i * (int)frame->width * 3;
        
        for (int j = 0; j < frame->width; j ++) {
            int originIndex = originFirstRowByte + (j * (int)frame->depth);
            int destinationIndex = destinationFirstRowByte + (j * 3);
            
            convertedData[destinationIndex] = data[originIndex + 2];
            convertedData[destinationIndex + 1] = data[originIndex + 1];
            convertedData[destinationIndex + 2] = data[originIndex];
        }
    }
    
    return core_image_create_frame(convertedData, frame->width, frame->height, 3, kCoreImageFormat_rgb);
}


@end































