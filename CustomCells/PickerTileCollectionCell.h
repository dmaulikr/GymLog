//
//  PickerTileCollectionCell.h
//  GymLog
//
//  Created by Amendeep Singh on 24/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerTileCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ex_icon;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UIImageView *ex_icon_two;

@end
