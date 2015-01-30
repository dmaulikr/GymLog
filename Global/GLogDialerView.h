//
//  GLogDialerView.h
//  GymLog
//
//  Created by Amendeep Singh on 27/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLogPlateView.h"
@interface GLogDialerView : GLogWeightBaseView<UITextFieldDelegate>
- (IBAction)dialerBtnPressed:(UIButton *)sender;
- (IBAction)clearBtnPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;

@end
