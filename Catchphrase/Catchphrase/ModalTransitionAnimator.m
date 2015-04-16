//
//  ModalTransitionAnimator.m
//  artsyu
//
//  Created by Nicholas Gerard on 3/8/15.
//  Copyright (c) 2015 eecs481. All rights reserved.
//

#import "ModalTransitionAnimator.h"

@implementation ModalTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if([destination isBeingPresented]) {
        [self animatePresentation:transitionContext];
    }
    
    else {
        [self animateDismissal:transitionContext];
    }
}

- (CGRect)presentingControllerFrameWithContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    CGRect frame = transitionContext.containerView.bounds;
    return CGRectMake(0, CGRectGetHeight(frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
}

- (void)animateDismissal:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    UIView* sourceView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView* destinationView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView* container = transitionContext.containerView;
    
    // Add destination view to container
    destinationView.frame = [self presentingControllerFrameWithContext:transitionContext];
    CGRect finalFrame = destinationView.frame;
    finalFrame.origin.y = 0;
    destinationView.frame = finalFrame;
    
    [container insertSubview:destinationView aboveSubview:sourceView];
    
    // Move destination snapshot back in Z plane
    CATransform3D perspectiveTransform = destinationView.layer.transform;
    perspectiveTransform.m34 = -1.0 / 1500.0;
    perspectiveTransform = CATransform3DTranslate(perspectiveTransform, 0, 0, -100);
    
    destinationView.layer.transform = CATransform3DIdentity;
    sourceView.layer.transform = CATransform3DIdentity;
    
    destinationView.frame = [self presentingControllerFrameWithContext:transitionContext];
    
    
    // Animate
    [UIView animateKeyframesWithDuration:transitionDuration
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
                                      sourceView.layer.transform = perspectiveTransform;
                                      
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.7 animations:^{
                                      destinationView.frame = finalFrame;
                                  }];
                                  
                              }
     
                              completion:^(BOOL finished) {
                                  [transitionContext completeTransition:YES];
                              }];
}

- (void)animatePresentation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    UIView* sourceView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView* destinationView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView* container = transitionContext.containerView;
    
    // Add destination view to container
    [container insertSubview:destinationView atIndex:0];
    
    // Move destination snapshot back in Z plane
    CATransform3D perspectiveTransform = destinationView.layer.transform;
    perspectiveTransform.m34 = -1.0 / 1500.0;
    perspectiveTransform = CATransform3DTranslate(perspectiveTransform, 0, 0, -100);
    destinationView.layer.transform = perspectiveTransform;
    
    // Animate
    [UIView animateKeyframesWithDuration:transitionDuration
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
                                      sourceView.frame = [self presentingControllerFrameWithContext:transitionContext];
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.7 animations:^{
                                      destinationView.layer.transform = CATransform3DIdentity;
                                  }];
                                  
                              }
     
                              completion:^(BOOL finished) {
                                  [transitionContext completeTransition:YES];
                              }];
}

@end
