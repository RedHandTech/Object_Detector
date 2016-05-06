//
//  BMHelper.m
//  Hand Detector
//
//  Created by Freelance on 27/01/2016.
//  Copyright © 2016 bmore. All rights reserved.
//

#import "BMHelper.h"

@implementation BMHelper

void BMDispatchMain(void (^dispatchBlock)(void)) {
    
    if (!dispatchBlock) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatchBlock();
    });
}

void BMDispatchAsync(void (^dispatchBlock)(void)) {
    
    if (!dispatchBlock) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatchBlock();
    });
}

void BMDispatchSync(void (^dispatchBlock)(void)) {
    
    if (!dispatchBlock) {
        return;
    }
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatchBlock();
    });
}

@end
