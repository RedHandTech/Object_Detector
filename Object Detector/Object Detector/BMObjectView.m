//
//  BMObjectView.m
//  Object Detector
//
//  Created by Robert Sanders on 01/02/2016.
//  Copyright © 2016 bmore digital ltd. All rights reserved.
//

#import "BMObjectView.h"

#import <SceneKit/SceneKit.h>

@interface BMObjectView ()

@property (nonatomic, strong) SCNView *sceneView;

@end

@implementation BMObjectView

#pragma mark - Lifecylce

- (instancetype)initWithFrame:(CGRect)frame sceneNamed:(NSString *)sceneName
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initScene:sceneName];
    }
    return self;
}

+ (BMObjectView *)objectViewWithFrame:(CGRect)frame sceneNamed:(NSString *)sceneName
{
    return [[BMObjectView alloc] initWithFrame:frame sceneNamed:sceneName];
}

#pragma mark - Public

- (void)updateFrame:(CGRect)frame
{
    self.frame = frame;
    self.sceneView.frame = self.bounds;
}

#pragma mark - Private

- (void)initScene:(NSString *)name
{
    self.sceneView = [[SCNView alloc] initWithFrame:self.bounds];
    self.sceneView.scene = [SCNScene sceneNamed:name];
    [self addSubview:self.sceneView];
    
    self.backgroundColor = [UIColor clearColor];
    self.sceneView.backgroundColor = [UIColor clearColor];
    
    SCNNode *table = [self.sceneView.scene.rootNode childNodeWithName:@"Table" recursively:NO];
    if (table) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"rotation"];
        anim.fromValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 0, 0, 1)];
        anim.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 1, M_PI * 2)];
        anim.duration = 4.0;
        anim.repeatCount = FLT_MAX;
        [table addAnimation:anim forKey:@"rotation"];
    }
}

@end
