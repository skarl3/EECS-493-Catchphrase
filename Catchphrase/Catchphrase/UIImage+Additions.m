//
//  UIImage+Additions.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 4/16/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

+ (UIImage *) imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *) circleWithSize:(CGSize)size
                    andColor:(UIColor*)color
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [color setFill];
    CGContextFillEllipseInRect(ctx, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImage;
}

+ (UIImage *) imageWithGradientFrom:(UIColor*)fromColor
                                 to:(UIColor*)toColor
                         withHeight:(CGFloat)height
{
    CGSize size = CGSizeMake(1.0f, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    const size_t fromSize = CGColorGetNumberOfComponents(fromColor.CGColor);
    const CGFloat *fromComponents = CGColorGetComponents(fromColor.CGColor);
    const size_t toSize = CGColorGetNumberOfComponents(toColor.CGColor);
    const CGFloat *toComponents = CGColorGetComponents(toColor.CGColor);
    
    float r1, g1, b1, a1, r2, g2, b2, a2;
    
    // Set up from color components
    if(fromComponents==NULL) {
        r1 = g1 = b1 = a1 = 0;
    }
    
    r1 = fromComponents[0];
    
    if (fromSize >= 4) {
        g1 = fromComponents[1];
        b1 = fromComponents[2];
        a1 = fromComponents[3];
    }
    
    else {
        g1 = b1 = r1;
        a1 = fromComponents[1];
    }
    
    // Set up to color components
    if(toComponents==NULL) {
        r2 = g2 = b2 = a2 = 0;
    }
    
    r2 = toComponents[0];
    
    if (toSize >= 4) {
        g2 = toComponents[1];
        b2 = toComponents[2];
        a2 = toComponents[3];
    }
    
    else {
        g2 = b2 = r2;
        a2 = toComponents[1];
    }
    
    size_t gradientNumberOfLocations = 2;
    CGFloat gradientLocations[2] = { 0.0, 1.0 };
    CGFloat gradientComponents[8] = { r2, g2, b2, a2,     // Start color
        r1, g1, b1, a1 };  // End color
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents (colorspace, gradientComponents, gradientLocations, gradientNumberOfLocations);
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return image;
}

@end
