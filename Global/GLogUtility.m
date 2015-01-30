//
//  GLogUtility.m
//  GymLog
//
//  Created by Amendeep Singh on 23/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogUtility.h"
#import "BodyPartInfo.h"
#import "WorkoutInfo.h"
#import "ExerciseInfo.h"
@implementation GLogUtility

+(void)insertTestData {

//    NSArray *bodyParts = @[@"Shoulders",@"Chest",@"Back",@"Biceps",@"Triceps",@"Legs",@"Abs"];
    
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"WorkoutList" ofType:@"plist"]];
    
    for (NSString *keyName in [dataDict allKeys]) {
        NSDictionary *workoutDict = [dataDict objectForKey:keyName];
        
   WorkoutInfo *workout =  [[GLogDataProcessor sharedProcessor]addWorkoutWithName:keyName description:[workoutDict objectForKey:@"description"]];
        NSArray *tagArray = [workoutDict objectForKey:@"tag"];
        
        for (NSString *tag in tagArray) {
            [[GLogDataProcessor sharedProcessor]addTagWithName:tag workout:workout];

            
        }
        
        
    }
    

    
     dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ExerciseList" ofType:@"plist"]];
    
    for (NSString *keyName in [dataDict allKeys]) {
        [[GLogDataProcessor sharedProcessor]addBodyPartWithName:keyName];
        
    }
    
    
    
    
    
    NSArray *fetchArray = [[GLogDataProcessor sharedProcessor]fetchMultipleEntitiesByName:@"BodyPartInfo"];
    
    for (BodyPartInfo *part in fetchArray) {
        
        NSArray *exerciseArray  = [dataDict objectForKey:part.body_part_name];
        for (NSDictionary *exerciseDict in exerciseArray) {
            
        
          //  NSMutableDictionary *exerciseDict = [[NSMutableDictionary alloc]init];
          
            [[GLogDataProcessor sharedProcessor]addExercise:exerciseDict bodyPart:part];
        }
        
        
        
    }
    
}

+ (UIView *)loadViewFromNib:(NSString *)nibName forClass:(id)forClass{
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    for(id currentObject in topLevelObjects)
        if([currentObject isKindOfClass:forClass])
        {
          
            return currentObject ;
        }
    
    return nil;
    
    
}

+(void)addPaddingToTextField:(UITextField*)textField {

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    
}

+(void)showNZAlertWithString:(NSString*)message andType:(NZAlertStyle)style {
    NZAlertView *alert = [[NZAlertView alloc] initWithStyle:style
                                                      title:@""
                                                    message:message
                                                   delegate:nil];
    
    if(style==NZAlertStyleError)
    [alert setStatusBarColor:[UIColor colorWithRed:(float)231/255 green:(float)96/255 blue:(float)82/255 alpha:1.0]];
    
    [alert setTextAlignment:NSTextAlignmentCenter];
    
    [alert show];
    

}

+(void)showAlertWithString:(NSString*)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    });
    
    
}

+(UIButton*)createAddButton {
    UIButton *addWorkoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addWorkoutButton setImage:[UIImage imageNamed:@"addBtn"] forState:UIControlStateNormal];
    //  [addWorkoutButton addTarget:self action:@selector(setAddPressed:) forControlEvents:UIControlEventTouchUpInside];
    addWorkoutButton.frame = CGRectMake(0, 0, 37, 37);
    
    return addWorkoutButton;
}
+ (UIImage *)rasterizedImage:(UIView*)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0f);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+(UIImage *)getRoundedRectImageFromImage :(UIImage *)image onReferenceView :(UIImageView*)imageView withCornerRadius :(float)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];
    [image drawInRect:imageView.bounds];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}
@end
