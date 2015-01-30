//
//  SummaryCell.h
//  GymLog
//
//  Created by Amendeep Singh on 22/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *prImageView;
@property (weak, nonatomic) IBOutlet UIView *setBgView;
@property (weak, nonatomic) IBOutlet UILabel *setLabel;
@property(nonatomic,weak)IBOutlet UILabel *summaryTitleLabel;
@end
