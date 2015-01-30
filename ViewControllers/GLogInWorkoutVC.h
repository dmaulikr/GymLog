//
//  GLogInWorkoutVC.h
//  GymLog
//
//  Created by Amendeep Singh on 01/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLogInWorkoutVC : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *selectionPickView;
@property(nonatomic,strong) DayInfo *selected_day;
@property(nonatomic,assign) BOOL shouldAddTracking;
@property(nonatomic,strong) NSDate *selectedDate;

@end
