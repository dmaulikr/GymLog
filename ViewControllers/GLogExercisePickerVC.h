//
//  GLogExercisePickerVC.h
//  GymLog
//
//  Created by Amendeep Singh on 23/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLogExercisePickerVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,strong) DayInfo *selected_day;
@property(nonatomic,assign) BOOL isOriginalWorkout;
@end
