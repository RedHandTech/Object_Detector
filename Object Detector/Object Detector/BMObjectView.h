//
//  BMObjectView.h
//  Object Detector
//
//  Created by Robert Sanders on 01/02/2016.
//  Copyright © 2016 bmore digital ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMObjectView : UIView

- (instancetype)initWithFrame:(CGRect)frame sceneNamed:(NSString *)sceneName;

+ (BMObjectView *)objectViewWithFrame:(CGRect)frame sceneNamed:(NSString *)sceneName;

- (void)updateFrame:(CGRect)frame;

@end
