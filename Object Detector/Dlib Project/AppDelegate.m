//
//  AppDelegate.m
//  Dlib Project
//
//  Created by Robert Sanders on 08/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

#import "AppDelegate.h"

#import <Objection/Objection.h>

#import "ObjectionModule.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    JSObjectionInjector *injector = [JSObjection createInjector:[[ObjectionModule alloc] init]];
    [JSObjection setDefaultInjector:injector];
    
    return YES;
}


@end
