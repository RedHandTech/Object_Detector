//
//  BMHelper.h
//  Hand Detector
//
//  Created by Freelance on 27/01/2016.
//  Copyright © 2016 bmore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMHelper : NSObject

void BMDispatchMain(void (^dispatchBlock)(void));
void BMDispatchAsync(void (^dispatchBlock)(void));
void BMDispatchSync(void (^dispatchBlock)(void));


@end
