//
//  CalendarDailyCell.h
//  GymLog
//
//  Created by Amendeep Singh on 01/12/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarDailyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *summaryView;
@property (weak, nonatomic) IBOutlet UILabel *dayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *recordLabelTwo;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *exerciseCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *setCountLabel;
@property (weak, nonatomic) IBOutlet UIView *dailyContentView;

@end
