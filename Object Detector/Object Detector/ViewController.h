//
//  ViewController.h
//  Object Detector
//
//  Created by Robert Sanders on 31/01/2016.
//  Copyright © 2016 bmore digital ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BMDetectionTypeFace,
    BMDetectionTypeLogo,
    BMDetectionTypeHand
}BMDetectionType;

@interface ViewController : UIViewController

@property (nonatomic) BMDetectionType detectionType;

@end

