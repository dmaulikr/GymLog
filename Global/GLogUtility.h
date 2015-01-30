//
//  GLogUtility.h
//  GymLog
//
//  Created by Amendeep Singh on 23/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NZAlertView/NZAlertView.h>
@interface GLogUtility : NSObject
+ (UIImage *)rasterizedImage:(UIView*)view;
+(void)insertTestData;
+(UIButton*)createAddButton;
+(void)showAlertWithString:(NSString*)message;
+(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;
+ (UIView *)loadViewFromNib:(NSString *)nibName forClass:(id)forClass;
+(UIImage *)getRoundedRectImageFromImage :(UIImage *)image onReferenceView :(UIImageView*)imageView withCornerRadius :(float)cornerRadius;
+(void)addPaddingToTextField:(UITextField*)textField;
+(BOOL)NSStringIsValidEmail:(NSString *)checkString;
+(void)showNZAlertWithString:(NSString*)message andType:(NZAlertStyle)style ;
@end
