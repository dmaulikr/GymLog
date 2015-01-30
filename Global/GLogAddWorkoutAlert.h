//
//  GLogAddWorkoutAlert.h
//  GymLog
//
//  Created by Amendeep Singh on 13/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GLogAddWorkoutAlert;
@protocol GLogWorkoutAlertViewDelegate<NSObject>
-(void)alertViewDidPressCreateButton:(GLogAddWorkoutAlert*)alertView ;
-(void)alertViewDidPressCancelButton:(GLogAddWorkoutAlert*)alertView ;

@end
@interface GLogAddWorkoutAlert : UIView
@property (weak, nonatomic) IBOutlet UITextField *workoutTextfield;
@property (weak, nonatomic) IBOutlet UIButton *weightButton;
@property (weak, nonatomic) IBOutlet UIButton *cardioButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (unsafe_unretained) id<GLogWorkoutAlertViewDelegate> delegate;
@property (strong, nonatomic) UIImageView *backgroundView;

-(void)showOnScreen ;
@end
