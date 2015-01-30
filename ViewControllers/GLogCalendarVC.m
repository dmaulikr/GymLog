//
//  GLogCalendarVC.m
//  GymLog
//
//  Created by Amendeep Singh on 01/12/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogCalendarVC.h"
#import "CalendarDailyCell.h"
#import "CalendarRestDayCell.h"

#define kDateKey @"date"
#define kWorkoutKey @"workout"
#define kSetCountKey @"set_count"

#define kHeightKey @"height"
#define kRestDayKey @"is_rest_day"
#define kPrKey @"pr_key"
#import "PRDailyCellView.h"

@interface GLogCalendarVC () {

    NSInteger numberOfDays;
    NSString *currentMonth;
    NSMutableArray *summaryArray;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegmentControl;
@property (weak, nonatomic) IBOutlet UITableView *dailyTableView;
@property (weak, nonatomic) IBOutlet UILabel *bestDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestLiftLabel;
@property (weak, nonatomic) IBOutlet UILabel *gainsLabel;

@end

@implementation GLogCalendarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)findNumberOfDaysInMonth {
    NSDate *today = [NSDate date]; //Get a date object for today's date
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:today];
    numberOfDays= days.length;
    
    
}

-(void)findMonthNameForDate:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM"];
   currentMonth = [formatter stringFromDate:date];
    
}

- (NSDate *)dateBySubtractingOneDayFromDate:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *minusOneDay = [[NSDateComponents alloc] init];
    [minusOneDay setDay:-1];
    NSDate *newDate = [cal dateByAddingComponents:minusOneDay
                                           toDate:date
                                          options:NSWrapCalendarComponents];
    return newDate;
}

-(void)calculatePreviousDatesTill:(int)days {

    NSDate *currentDate = [NSDate date];
    
    NSCalendar *cal =  [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:currentDate];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    currentDate = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    
   
 //   currentDate = [cal dateFromComponents:components];
    
    
   
    
    for (int i=0; i<30; i++) {
        NSMutableDictionary *dateDict  =[[NSMutableDictionary alloc]init];
        [components setHour:-24];
        [components setMinute:0];
        [components setSecond:0];

        NSDate *yesterday = [cal dateByAddingComponents:components toDate: currentDate options:0];
        NSLog(@" %d %@",i,yesterday);
        [dateDict setObject:yesterday forKey:kDateKey];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"workout_start_time>%@ AND workout_start_time<%@",yesterday,currentDate];
        
        NSArray *fetchArray = [[GLogDataProcessor sharedProcessor]fetchMultipleEntitiesByName:@"HistoryInfo" withPredicate:predicate];
        if(fetchArray.count) {
            NSLog(@"%@",fetchArray);
            
        //    HistoryInfo *workout = [fetchArray lastObject];
            for (HistoryInfo *workout in fetchArray) {
                int setCount = 0;
                NSInteger personalRecordCount = 0;
                NSMutableArray *prArray = [[NSMutableArray alloc]init];
                for (ExerciseInfo *exercise in workout.exercise_r) {
                    setCount +=exercise.set_r.count;
                    
                    
                    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
                    [fetchRequest setEntity:[NSEntityDescription entityForName:@"SetInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]]];
                    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"set_weight" ascending:NO];
                    
                    predicate = [NSPredicate predicateWithFormat:@"exercise_r.exercise_name==%@",exercise.exercise_name];
                    [fetchRequest setPredicate:predicate];
                    
                    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
                    
                    [fetchRequest setFetchLimit:1];
                    
                    NSError *error=nil;
                    NSArray *setArray =[[kAppDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
                    
                    if(setArray.count)
                        
                    {
                        
                        
                        
                        SetInfo *set = [setArray lastObject];
                        
                        if([exercise.set_r containsObject:set]){
                            personalRecordCount +=1;
                            [prArray addObject:set];
                        }
                    }
                    
                }
                if(prArray.count) {
                    
                    [dateDict setObject:prArray forKey:kPrKey];
                    NSLog(@"PERSONAL RECORD");
                }
                int prHeight  = (int)(prArray.count*20);
                [dateDict setObject:[NSNumber numberWithInt:setCount] forKey:kSetCountKey];
                
                [dateDict setObject:workout forKey:kWorkoutKey];
                [dateDict setObject:[NSNumber numberWithBool:NO] forKey:kRestDayKey];
                [dateDict setObject:[NSNumber numberWithInt:65+prHeight] forKey:kHeightKey];
                [summaryArray addObject:[dateDict mutableCopy]];

            }
            

        }
        else {
            [dateDict setObject:[NSNumber numberWithBool:YES] forKey:kRestDayKey];
            [dateDict setObject:[NSNumber numberWithInt:38] forKey:kHeightKey];
            [summaryArray addObject:dateDict];


        }
        
        
        currentDate = yesterday;
        
        
        

        
    }
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Workout Summary";
    summaryArray = [[NSMutableArray alloc]init];
    _dailyTableView.backgroundColor = [UIColor clearColor];
    [self findNumberOfDaysInMonth];
    [self findMonthNameForDate:[NSDate date]];
    [self calculatePreviousDatesTill:1];
	// Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dict = [summaryArray objectAtIndex:indexPath.row];
    
    return [[dict objectForKey:kHeightKey]integerValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
   return summaryArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [summaryArray objectAtIndex:indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd"];
    NSString *dateLabelText = [formatter stringFromDate:[dict objectForKey:kDateKey]];

    if([[dict objectForKey:kRestDayKey]boolValue]) {
        CalendarRestDayCell *restCell =[tableView dequeueReusableCellWithIdentifier:@"CalendarRestDayCell"];
        
        
        if(!restCell)
        {
            restCell = (CalendarRestDayCell*)[GLogUtility loadViewFromNib:@"CalendarDailyCell" forClass:[CalendarRestDayCell class]];
        }
        restCell.dateLabel.text = [NSString stringWithFormat:@"%@",[dateLabelText uppercaseString]];

        
        return restCell;

    }
    
    else {
    
        CalendarDailyCell *dailyCell = [tableView dequeueReusableCellWithIdentifier:@"CalendarDailyCell"];
        
        if(!dailyCell)
        {
            dailyCell = (CalendarDailyCell*)[GLogUtility loadViewFromNib:@"CalendarDailyCell" forClass:[CalendarDailyCell class]];        }
        
        for (UIView *subview in [dailyCell.dailyContentView subviews]) {
            if([subview isKindOfClass:[PRDailyCellView class]])
                [subview removeFromSuperview];
        }
        
        NSArray *prArray = [dict objectForKey:kPrKey];
        CGFloat yOffset = 20;
        for (int i=0; i<[prArray count]; i++) {
            SetInfo *set = [prArray objectAtIndex:i];
            
            PRDailyCellView *prView = (PRDailyCellView*)[GLogUtility loadViewFromNib:@"CalendarDailyCell" forClass:[PRDailyCellView class]];
            CGRect frame = prView.frame;
            frame.origin.x = 8;
            frame.origin.y = yOffset;
            prView.exerciseLabel.text = set.exercise_r.exercise_name;
            prView.weightLabel.text = [NSString stringWithFormat:@"%@ %@",[set.set_weight stringValue],kDefaultWeightMetric];
            [dailyCell.dailyContentView addSubview:prView];
         //   NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(dailyCell.dailyContentView,prView);
           // NSString *xConstraint = [NSString stringWithFormat:@"H:|-%f-[prView]",frame.origin.x];
            //NSString *YConstraint = [NSString stringWithFormat:@"V:|-%f-[prView]",frame.origin.y];

          //  [dailyCell.dailyContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:xConstraint options:0 metrics:nil views:viewsDictionary]];
           // [dailyCell.dailyContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:YConstraint options:0 metrics:nil views:viewsDictionary]];

            [prView setTranslatesAutoresizingMaskIntoConstraints:NO];
            prView.frame = frame;
            yOffset+= frame.size.height;
        }
               dailyCell.dateLabel.text = [NSString stringWithFormat:@"%@",[dateLabelText uppercaseString]];
        HistoryInfo *history = [dict objectForKey:kWorkoutKey];
        [dailyCell.summaryView setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSMutableDictionary *viewDict = [NSMutableDictionary new];
        [viewDict setObject:dailyCell.summaryView forKey:@"summaryView"];
        ;
        
//       NSString *YConstraint = [NSString stringWithFormat:@"V:|[summaryView]-%f-|",yOffset];
//        [dailyCell.dailyContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:YConstraint options:0 metrics:nil views:viewDict]];
//        
//        NSString *XConstraint = [NSString stringWithFormat:@"H:|[summaryView]-%f-|",20.0];
//        [dailyCell.dailyContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:XConstraint options:0 metrics:nil views:viewDict]];
       // summaryFrame.origin.y = dailyCell.dailyContentView.frame.size.height-(summaryFrame.size.height);
  //  dailyCell.summaryView.frame = summaryFrame;

        if(history) {
              int currentMinute = (int)[history.workout_duration integerValue] / 60;
            if(currentMinute>0)
            dailyCell.durationLabel.text = [NSString stringWithFormat:@"%d min",currentMinute];
            
            else {
                int currentSecond = [history.workout_duration integerValue] % 60;
                dailyCell.durationLabel.text = [NSString stringWithFormat:@"%d sec",currentSecond];

            }
            
            if(history.exercise_r.count) {
                
                ExerciseInfo *exercise = [history.exercise_r objectAtIndex:0];
                
                dailyCell.recordLabelOne.text = [NSString stringWithFormat:@"%@ -",exercise.exercise_name];
                
                if(history.exercise_r.count>1){
                    exercise = [history.exercise_r objectAtIndex:1];
                    dailyCell.recordLabelTwo.text =[NSString stringWithFormat:@"%@ -",exercise.exercise_name] ;

                }
            }
            dailyCell.dayNameLabel.text = history.workout_name;
            
            dailyCell.setCountLabel.text =[NSString stringWithFormat:@"%@ sets",[[dict objectForKey:kSetCountKey]stringValue]];
            
        }
        return dailyCell;
}
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
