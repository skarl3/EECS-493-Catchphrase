//
//  UIImage+Additions.h
//  Catchphrase
//
//  Created by Nicholas Gerard on 4/16/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

+ (UIImage *) imageWithColor:(UIColor *)color;
+ (UIImage *) circleWithSize:(CGSize)size
                    andColor:(UIColor*)color;
+ (UIImage *) imageWithGradientFrom:(UIColor*)fromColor
                                 to:(UIColor*)toColor
                         withHeight:(CGFloat)height;

@end
