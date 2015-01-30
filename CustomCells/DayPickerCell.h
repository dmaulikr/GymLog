//
//  DayPickerCell.h
//  GymLog
//
//  Created by Amendeep Singh on 10/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DayPickerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *dayTextField;
@property (unsafe_unretained) id delegate;

@end

@protocol DayCellDelegate<NSObject>
-(void)didRenameDayForCell:(DayPickerCell*)cell;
@end
