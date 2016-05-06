//
//  BMVideoPlugin.h
//  Object Detector
//
//  Created by Rob Sanders on 01/02/2016.
//  Copyright © 2016 bmore digital ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMVideoLayer.h"

@protocol BMVideoPlugin <NSObject>

/**Called by the video layer when a new frame arrives. Override this to perform custom functionality.*/
- (void)frameDidArrive:(BMVideoLayer *)player;


@end
