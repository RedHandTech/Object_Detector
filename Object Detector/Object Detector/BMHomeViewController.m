//
//  BMHomeViewController.m
//  Object Detector
//
//  Created by Rob Sanders on 02/02/2016.
//  Copyright © 2016 bmore digital ltd. All rights reserved.
//

#import "BMHomeViewController.h"
#import "ViewController.h"

@interface BMHomeViewController ()

@end

@implementation BMHomeViewController

#pragma mark - Actions

- (IBAction)go:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            [self performSegueWithIdentifier:@"home_to_main" sender:@(BMDetectionTypeFace)];
            break;
        case 1:
            [self performSegueWithIdentifier:@"home_to_main" sender:@(BMDetectionTypeLogo)];
            break;
        case 2:
            [self performSegueWithIdentifier:@"home_to_main" sender:@(BMDetectionTypeHand)];
            break;
        default:
            break;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ViewController class]]) {
        [(ViewController *)segue.destinationViewController setDetectionType:[sender intValue]];
    }
}

@end
