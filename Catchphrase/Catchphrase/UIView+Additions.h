//
//  UIView+Additions.h
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const float ANIM_DURATION_BOUNCE;
extern const float ANIM_DURATION_NOBOUNCE;

@interface UIView (Additions)

- (UIImage *) renderImage;

/**
 Animates the views with UIView singleton block: [UIView animateLayout...
 
 @param bounce YES to use spring damping/velocity
 @param options UIViewAnimationOptions
 @param animations Additional block for animations.
 */
+ (void) animateWithBounce:(BOOL)bounce
                   options:(UIViewAnimationOptions)options
                animations:(void (^)(void))animations;

+ (void) animateWithBounce:(BOOL)bounce
                   options:(UIViewAnimationOptions)options
                  duration:(NSTimeInterval)duration
                animations:(void (^)(void))animations
                completion:(void (^)(void))completion;

/**
 Animates the view's constraints by calling layoutIfNeeded.
 
 @param bounce YES to use spring damping/velocity
 @param options UIViewAnimationOptions
 @param animations Additional block for animations.
 */
- (void) animateLayoutIfNeededWithBounce:(BOOL)bounce
                                 options:(UIViewAnimationOptions)options
                              animations:(void (^)(void))animations;

/**
 Animates the view's constraints by calling layoutIfNeeded.
 
 @param duration The total duration of the animations, measured in seconds.
 @param bounce YES to use spring damping/velocity
 @param options UIViewAnimationOptions
 @param animations Additional block for animations.
 */
- (void) animateLayoutIfNeededWithDuration:(NSTimeInterval)duration
                                    bounce:(BOOL)bounce
                                   options:(UIViewAnimationOptions)options
                                animations:(void (^)(void))animations;

@end
