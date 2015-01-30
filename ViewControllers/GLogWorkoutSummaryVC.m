//
//  GLogWorkoutSummaryVC.m
//  GymLog
//
//  Created by Amendeep Singh on 22/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogWorkoutSummaryVC.h"
#import "SummaryCell.h"
#import "SummarySectionView.h"
@interface GLogWorkoutSummaryVC ()<UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *summaryArray;
}
@property (weak, nonatomic) IBOutlet UITableView *summaryTableView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end

@implementation GLogWorkoutSummaryVC
@synthesize workout_history;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self generateSetSummary];
    self.title = [NSString stringWithFormat:@"Workout Summary"];
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd MMMM yyyy"];
    
    NSString *workoutDateString = [df stringFromDate:workout_history.workout_start_time];
    
//    int currentSecond = [workout_history.workout_duration integerValue] % 60;
//    int currentMinute = [workout_history.workout_duration integerValue] / 60;
//   NSMutableString *duration = [[NSMutableString alloc]initWithString:@"Duration: "];
//if(currentMinute>0)
//   [duration appendFormat:@"%d minute ",currentMinute];
//   
//    if(currentSecond>0)
//        [duration appendFormat:@"%d seconds",currentSecond];
    
    _durationLabel.text = workoutDateString;

	// Do any additional setup after loading the view.
}

-(void)generateSetSummary {
    
     summaryArray = [NSMutableArray new];
    
    
    for (ExerciseInfo *exercise in workout_history.exercise_r) {
        NSMutableDictionary *exerciseDict = [NSMutableDictionary new];
        [exerciseDict setObject:exercise forKey:@"exercise"];
        
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"SetInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]]];
        NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"set_weight" ascending:NO];
        
        NSPredicate*predicate = [NSPredicate predicateWithFormat:@"exercise_r.exercise_name==%@",exercise.exercise_name];
        [fetchRequest setPredicate:predicate];
        
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
        
        [fetchRequest setFetchLimit:1];
        
        NSError *error=nil;
        NSArray *setArray =[[kAppDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        
        if(setArray.count)
            
        {
            
            NSMutableArray *prArray = [NSMutableArray new];
            
            SetInfo *set = [setArray lastObject];
            
            if([exercise.set_r containsObject:set]){
                [prArray addObject:set];
            }
            
            [exerciseDict setObject:prArray forKey:@"prArray"];
        }
        [summaryArray addObject:exerciseDict];
    }
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Table view methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 26;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return summaryArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary *dict =  [summaryArray objectAtIndex:section];
    ExerciseInfo *exercise = [dict objectForKey:@"exercise"];
    
    return exercise.set_r.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 26;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    SummarySectionView *sectionView = (SummarySectionView*)[GLogUtility loadViewFromNib:@"SummarySectionView" forClass:[SummarySectionView class]];


    NSMutableDictionary *dict =  [summaryArray objectAtIndex:section];
        ExerciseInfo *exercise = [dict objectForKey:@"exercise"];
    UIImage *iconImage;
    switch ([exercise.equipment_type integerValue]) {
        case 1:{
            sectionView.sectionView.backgroundColor = kSummaryBarbellSectionColor;
            iconImage = [UIImage imageNamed:@"summary_barbell_icon"];
        }
            break;
        case 2:
            sectionView.sectionView.backgroundColor = kSummaryBarbellSectionColor;
            iconImage = [UIImage imageNamed:@"summary_barbell_icon"];

            break;
            
        case 3:
            sectionView.sectionView.backgroundColor = kSummaryPlateSectionColor;
            iconImage = [UIImage imageNamed:@"summary_plate_icon"];

            break;
        case 4:
            sectionView.sectionView.backgroundColor = kSummaryDumbbellSectionColor;
            iconImage = [UIImage imageNamed:@"summary_dumbbell_icon"];

            
            break;
        case 5:
            sectionView.sectionView.backgroundColor = kSummaryBodyWeightSectionColor;
            
            
            break;
        default:
            sectionView.sectionView.backgroundColor = kSummaryBarbellSectionColor;
            iconImage = [UIImage imageNamed:@"summary_barbell_icon"];

            break;
    }
    
    
    CGSize maximumLabelSize = CGSizeMake(9999,sectionView.titleLabel.frame.size.height);
    
  CGRect expectedLabelRect =   [exercise.exercise_name boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@
     {NSFontAttributeName: [UIFont fontWithName:@"STHeitiSC-Light" size:15.0]} context:nil];
    
    CGRect frame = sectionView.titleLabel.frame;
    frame.size.width = expectedLabelRect.size.width+10;
    sectionView.titleLabel.frame = frame;
    
    sectionView.iconImageView.center = sectionView.sectionView.center;
    sectionView.iconImageView.image = iconImage;
    frame = sectionView.iconImageView.frame;
    frame.size.height = iconImage.size.height;
    frame.size.width = iconImage.size.width;
    sectionView.titleLabel.text = exercise.exercise_name;

    frame.origin.x = sectionView.titleLabel.frame.origin.x+sectionView.titleLabel.frame.size.width;
    sectionView.iconImageView.frame = frame;
    
    frame = sectionView.sectionView.frame;
    frame.size.width = sectionView.iconImageView.frame.origin.x+sectionView.iconImageView.frame.size.width+10;
    sectionView.sectionView.frame = frame;
        return sectionView;

}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSMutableDictionary *dict =  [summaryArray objectAtIndex:section];
//    ExerciseInfo *exercise = [dict objectForKey:@"exercise"];
//
//    return exercise.exercise_name;
//    
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SummaryCell"];
    
    NSMutableDictionary *dict =  [summaryArray objectAtIndex:indexPath.section];
    ExerciseInfo *exercise = [dict objectForKey:@"exercise"];
    
    SetInfo *set = [exercise.set_r objectAtIndex:indexPath.row];
    NSArray *prArray = [dict objectForKey:@"prArray"];
    if([prArray containsObject:set]) {
        cell.prImageView.hidden = NO;
    }
    
    
    else {
        cell.prImageView.hidden = YES;

    }
    cell.setLabel.text =[NSString stringWithFormat:@"Set %d:",indexPath.row+1];
    switch (indexPath.row%3) {
        case 0:
            cell.setBgView.backgroundColor = kSummarySetColorOne;
            break;
        case 1:
            cell.setBgView.backgroundColor = kSummarySetColorTwo;

            break;
        default:
            cell.setBgView.backgroundColor = kSummarySetColorThree;

            break;
    }
    
    cell.summaryTitleLabel.text =[NSString stringWithFormat:@"%d %@ x %d %@",[set.set_weight intValue],kDefaultWeightMetric,[set.set_repetitions intValue],@"reps"];
    
    return cell;
}

@end
