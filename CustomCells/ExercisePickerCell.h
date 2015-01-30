//
//  ExercisePickerCell.h
//  GymLog
//
//  Created by Amendeep Singh on 23/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExercisePickerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *popularImageView;
@property (weak, nonatomic) IBOutlet UILabel *iconTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *exerciseTypeLabel;
@property (weak, nonatomic) IBOutlet UIView *typeIconView;
@property(weak,nonatomic) IBOutlet UILabel *titleLabel;
@end
