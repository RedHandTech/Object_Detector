//
//  ObjectionModule.m
//  Dlib Project
//
//  Created by Robert Sanders on 24/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ObjectionModule.h"

@implementation ObjectionModule

- (void)configure
{
    [self bind:[UIApplication sharedApplication] toClass:[UIApplication class]];
    [self bind:[NSNotificationCenter defaultCenter] toClass:[NSNotificationCenter class]];
}

@end
