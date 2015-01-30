//
//  UIImage+BlendMode.m
//  GymLog
//
//  Created by Amendeep Singh on 28/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "UIImage+BlendMode.h"

@implementation UIImage (BlendMode)
- (UIImage *)blendedImageWithBlendingMode:(CGBlendMode)blendMode
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}


@end
