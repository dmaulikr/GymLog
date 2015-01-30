//
//  UIView+Animation.m
//  GymLog
//
//  Created by Amendeep Singh on 13/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)
-(void)addSubviewWithBounce:(UIView*)theView
{
    theView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [self addSubview:theView];
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        theView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            theView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                theView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

-(void)removeFromSuperviewWithFade {

   [UIView animateWithDuration:0.25 animations:^{
       self.alpha = 0.0;
   } completion:^(BOOL finished) {
       
       if(finished) {
           [self removeFromSuperview];
       }
       
   }];
}

-(void)hideViewWithAnimation {
    
    if(!self.hidden) {
        [UIView animateWithDuration:0.7 animations:^{
            self.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            self.hidden = YES;
            
        }];
    }
    
    
}
- (void)showViewWithAnimation {
    
    if(self.hidden) {
        self.alpha = 0.0;
        self.hidden = NO;
        [UIView animateWithDuration:0.7 animations:^{
            self.alpha =1.0;
            
        }];
    }
}


@end
