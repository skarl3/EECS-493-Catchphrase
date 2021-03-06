//
//  UIView+Additions.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "UIView+Additions.h"

const float ANIM_SPRING_DAMPING = 0.7;
const float ANIM_SPRING_VELOCITY = 0.7;
const float ANIM_DURATION_BOUNCE = 0.5;
const float ANIM_DURATION_NOBOUNCE = 0.2;

@implementation UIView (Additions)

- (UIImage *) renderImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void) animateWithBounce:(BOOL)bounce
                   options:(UIViewAnimationOptions)options
                animations:(void (^)(void))animations
{
    if (bounce) {
        [UIView animateWithDuration:ANIM_DURATION_BOUNCE
                              delay:0.0
             usingSpringWithDamping:ANIM_SPRING_DAMPING
              initialSpringVelocity:ANIM_SPRING_VELOCITY
                            options:options
                         animations:^{
                             if (animations) {
                                 animations();
                             }
                         }
                         completion:NULL];
    }
    
    else {
        [UIView animateWithDuration:ANIM_DURATION_NOBOUNCE
                              delay:0.0
                            options:options
                         animations:^{
                             if (animations) {
                                 animations();
                             }
                         }
                         completion:NULL];
    }
}

+ (void) animateWithBounce:(BOOL)bounce
                   options:(UIViewAnimationOptions)options
                  duration:(NSTimeInterval)duration
                animations:(void (^)(void))animations
                completion:(void (^)(void))completion
{
    if (bounce) {
        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:ANIM_SPRING_DAMPING
              initialSpringVelocity:ANIM_SPRING_VELOCITY
                            options:options
                         animations:^{
                             if (animations) {
                                 animations();
                             }
                         }
                         completion:^(BOOL finished) {
                             if (completion) {
                                 completion();
                             }
                         }];
    }
    
    else {
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:options
                         animations:^{
                             if (animations) {
                                 animations();
                             }
                         }
                         completion:^(BOOL finished) {
                             if (completion) {
                                 completion();
                             }
                         }];
    }
}

- (void) animateLayoutIfNeededWithBounce:(BOOL)bounce
                                 options:(UIViewAnimationOptions)options
                              animations:(void (^)(void))animations
{
    NSTimeInterval duration = bounce ? ANIM_DURATION_BOUNCE : ANIM_DURATION_NOBOUNCE;
    [self animateLayoutIfNeededWithDuration:duration bounce:bounce options:options animations:animations completion:nil];
}

- (void) animateLayoutIfNeededWithDuration:(NSTimeInterval)duration
                                    bounce:(BOOL)bounce
                                   options:(UIViewAnimationOptions)options
                                animations:(void (^)(void))animations
                                completion:(void (^)(void))completion
{
    if (bounce) {
        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:ANIM_SPRING_DAMPING
              initialSpringVelocity:ANIM_SPRING_VELOCITY
                            options:options
                         animations:^{
                             [self layoutIfNeeded];
                             
                             if (animations) {
                                 animations();
                             }
                         }
                         completion:^(BOOL finished) {
                             if (completion) {
                                 completion();
                             }
                         }];
    }
    
    else {
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:options
                         animations:^{
                             [self layoutIfNeeded];
                             
                             if (animations) {
                                 animations();
                             }
                         }
                         completion:^(BOOL finished) {
                             if (completion) {
                                 completion();
                             }
                         }];
    }
}

@end
