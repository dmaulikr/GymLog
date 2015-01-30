//
//  UIView+Animation.h
//  GymLog
//
//  Created by Amendeep Singh on 13/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)
-(void)removeFromSuperviewWithFade;
-(void)addSubviewWithBounce:(UIView*)theView;
-(void)hideViewWithAnimation;
- (void)showViewWithAnimation;
@end
