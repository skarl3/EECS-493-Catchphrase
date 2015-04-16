//
//  ModalTransitionDelegate.m
//  artsyu
//
//  Created by Nicholas Gerard on 3/8/15.
//  Copyright (c) 2015 eecs481. All rights reserved.
//

#import "ModalTransitionDelegate.h"
#import "ModalTransitionAnimator.h"
#import "ModalPresentationController.h"

@interface ModalTransitionDelegate()

@property (nonatomic, strong) ModalTransitionAnimator *animator;

@end

@implementation ModalTransitionDelegate

- (ModalTransitionAnimator*) animator
{
    if(!_animator) {
        _animator = [ModalTransitionAnimator new];
    }
    
    return _animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    return [self animator];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [self animator];
}

- (UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                     presentingViewController:(UIViewController *)presenting
                                                         sourceViewController:(UIViewController *)source
{
    return [[ModalPresentationController alloc] initWithPresentedViewController:presented
                                                       presentingViewController:source];
}

@end
