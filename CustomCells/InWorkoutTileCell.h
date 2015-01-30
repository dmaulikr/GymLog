//
//  InWorkoutTileCell.h
//  GymLog
//
//  Created by Sunny on 05/12/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InWorkoutTileCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ex_icon;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *setCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIImageView *tick_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *pr_icon_imageView;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@end
