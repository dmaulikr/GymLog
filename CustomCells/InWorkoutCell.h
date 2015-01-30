//
//  InWorkoutCell.h
//  GymLog
//
//  Created by Amendeep Singh on 01/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InWorkoutCell : UITableViewCell
@property(weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *cell_bgView;
@property (weak, nonatomic) IBOutlet UILabel *setLabel;
@property (weak, nonatomic) IBOutlet UIView *setBgView;

@end
