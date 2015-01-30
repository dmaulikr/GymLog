//
//  GLogAlertView.h
//  GymLog
//
//  Created by Amendeep Singh on 10/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GLogAlertView;
@protocol GLogAlertViewDelegate<NSObject>
-(void)alertViewDidPressDoneButton:(GLogAlertView*)alertView ;
-(void)alertViewDidPressCancelButton:(GLogAlertView*)alertView ;

@end

@interface GLogAlertView : UIView<UITextFieldDelegate>
- (IBAction)cancelBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *alertTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *alertTextField;
@property (unsafe_unretained) id<GLogAlertViewDelegate> delegate;

@end
