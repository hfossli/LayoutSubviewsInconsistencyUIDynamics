//
//  XYZAppDelegate.m
//  LayoutSubviewsInconsistencyUIDynamics
//
//  Created by Håvard Fossli on 09.07.14.
//  Copyright (c) 2014 Agens AS. All rights reserved.
//

#import "XYZAppDelegate.h"
#import "RootViewController.h"

@interface XYZAppDelegate ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) RootViewController *controller;

@end

@implementation XYZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    printf("\n--------------------------\n");
    printf("Initial application launch\n");
    printf("Expects: All views/layers to layout subviews/sublayers\n");

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    self.controller = [RootViewController new];
    self.window.rootViewController = self.controller;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self changeTransformAndPosition];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addDynamics];
    });

    return YES;
}

- (void)changeTransformAndPosition
{
    printf("\n-------------------------------\n");
    printf("Changing transform and position\n");
    printf("Expects: No updates\n");
    self.controller.redView.transform = CGAffineTransformMakeRotation(0.5);
    self.controller.redView.center = CGPointMake(100, self.controller.view.bounds.size.height - 200);
}

- (void)addDynamics
{
    printf("\n------------------------------------------------------------\n");
    printf("Adding dynamic behavior which changes transform and position\n");
    printf("Expects: No updates\n");

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.controller.view];

    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[ self.controller.redView ]];
    gravity.magnitude = 8;
    [self.animator addBehavior:gravity];

    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[ self.controller.redView ]];
    [collision setTranslatesReferenceBoundsIntoBoundary:YES];
    [self.animator addBehavior:collision];
}

@end
