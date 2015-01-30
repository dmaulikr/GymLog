//
//  GLogAddWorkoutAlert.m
//  GymLog
//
//  Created by Amendeep Singh on 13/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogAddWorkoutAlert.h"
#import <UIImage-Helpers/UIImage+Blur.h>
#import <UIImage-Helpers/UIImage+Screenshot.h>

@interface GLogAddWorkoutAlert()<UITextFieldDelegate>{

    UIButton *lastBtn;
}

- (IBAction)tabBtnPressed:(id)sender;
- (IBAction)createBtnPressed:(id)sender;
- (IBAction)cancelBtnPressed:(id)sender;

@end
@implementation GLogAddWorkoutAlert
@synthesize delegate;
@synthesize backgroundView;
-(void)awakeFromNib {

  //  self.layer.cornerRadius = 4.0;
  //  self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //self.layer.borderWidth = 1.0;
    
    lastBtn = _weightButton;
    _cardioButton.enabled = YES;
  CGRect  frame = [[UIScreen mainScreen] bounds];

    self.backgroundView = [[UIImageView alloc] initWithFrame:frame];
    self.backgroundView.userInteractionEnabled = YES;


}
-(void)didMoveToSuperview {
    if(!self.superview) {
    
        
    }
    
}

-(void)showOnScreen {
    UIApplication *application = [UIApplication sharedApplication];
    UIImage *screenshot = [UIImage screenshot];
    NSData *imageData = UIImageJPEGRepresentation(screenshot, .0001);
    UIImage *blurredSnapshot = [[UIImage imageWithData:imageData] blurredImage:.4f];
    
    self.backgroundView.image = blurredSnapshot;
    self.backgroundView.hidden =YES;
  //  self.backgroundView.alpha = 0;
   // self.alpha = 0;
    self.hidden = YES;
    NSInteger index = [[application keyWindow].subviews count];
   [[application keyWindow] insertSubview:self atIndex:index];

    
    [[application keyWindow] insertSubview:self.backgroundView atIndex:index];
    [self showViewWithAnimation];

    [self.backgroundView showViewWithAnimation];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)tabBtnPressed:(UIButton*)sender {
    
    lastBtn.enabled = YES;
    
    sender.enabled = NO;
    
    lastBtn = sender;
}

- (IBAction)createBtnPressed:(id)sender {
    
    if(self.delegate &&[self.delegate respondsToSelector:@selector(alertViewDidPressCreateButton:)])
        [self.delegate alertViewDidPressCreateButton:self];
}

- (IBAction)cancelBtnPressed:(id)sender {
    
    if(self.delegate &&[self.delegate respondsToSelector:@selector(alertViewDidPressCancelButton:)])
        [self.delegate alertViewDidPressCancelButton:self];

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

@end
