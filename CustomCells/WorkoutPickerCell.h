//
//  WorkoutPickerCell.h
//  GymLog
//
//  Created by Amendeep Singh on 29/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkoutPickerCell;
@protocol WorkoutCellDelegate<NSObject>
@optional
-(void)didSelectModifyButtonForCell:(WorkoutPickerCell*)cell;
-(void)didSelectStartButtonForCell:(WorkoutPickerCell*)cell;

@end
@interface WorkoutPickerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *latestIconView;
@property (weak, nonatomic) IBOutlet UILabel *workoutTitleLabel;
@property (unsafe_unretained)  id<WorkoutCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *cell_bg_img_view;

@property (weak, nonatomic) IBOutlet UILabel *workoutDescriptionLabel;
@end
