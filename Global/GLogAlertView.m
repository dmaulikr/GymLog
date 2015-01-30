//
//  GLogAlertView.m
//  GymLog
//
//  Created by Amendeep Singh on 10/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogAlertView.h"

@implementation GLogAlertView
@synthesize delegate;
-(void)awakeFromNib {

   // self.backgroundColor = [UIColor clearColor];
    [_doneButton addTarget:self action:@selector(doneBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

    [_alertTextField becomeFirstResponder];
    self.layer.cornerRadius = 4.0;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0;

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)doneBtnPressed:(UIButton*)sender {
    [_alertTextField resignFirstResponder];

    [self removeFromSuperview];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidPressDoneButton:)])
        [self.delegate alertViewDidPressDoneButton:self];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)cancelBtnPressed:(id)sender {
    
    [_alertTextField resignFirstResponder];
    if(self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidPressCancelButton:)])
        [self.delegate alertViewDidPressCancelButton:self];

}
@end
