//
//  GLogDaySelectorVC.m
//  GymLog
//
//  Created by Amendeep Singh on 10/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogDaySelectorVC.h"
#import "DayPickerCell.h"
#import "GLogExercisePickerVC.h"
#import "GLogInWorkoutVC.h"
#import "TagCollectionViewCell.h"
@interface GLogDaySelectorVC ()<UITableViewDataSource,UITableViewDelegate,GLogAlertViewDelegate,DayCellDelegate> {
    TagCollectionViewCell *sizingCell;

    
      id selectedDay;
    
    
}
- (IBAction)addTagButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *dayTableView;
@property (weak, nonatomic) IBOutlet UIView *workoutTagView;
@property (weak, nonatomic) IBOutlet UICollectionView *tagCollectionView;
@end

@implementation GLogDaySelectorVC
@synthesize selected_workout;
@synthesize isGLWorkout;
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
    UINib *cellNib = [UINib nibWithNibName:@"TagCollectionViewCell" bundle:nil];
    sizingCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    [_dayTableView setBackgroundColor:[UIColor clearColor]];
    UIButton *addButton = [GLogUtility createAddButton];
    [addButton addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addItem;
    [self.tagCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"TagCollectionViewCell"];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([selected_workout isKindOfClass:[GLWorkoutInfo class]])
    return ((GLWorkoutInfo*)self.selected_workout).day_r.count;
    
    else {
        return ((WorkoutInfo*)self.selected_workout).day_r.count;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([selected_workout isKindOfClass:[GLWorkoutInfo class]])
     selectedDay = [((GLWorkoutInfo*)self.selected_workout).day_r objectAtIndex:indexPath.row];
    
    else selectedDay = [((WorkoutInfo*)self.selected_workout).day_r objectAtIndex:indexPath.row];
    
    UIAlertView *checkoutAlert =[ [UIAlertView alloc]initWithTitle:@"" message:@"Do you want to modify this workout?." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [checkoutAlert show];
    
//    if(selectedDay.exercise_r.count)
//        [self performSegueWithIdentifier:@"modifySegue" sender:selectedDay];
//    
//    else [self performSegueWithIdentifier:@"exerciseSegue" sender:selectedDay];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag==999) {
        switch (buttonIndex) {
            case 1:
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                GLWorkoutInfo *workout = (GLWorkoutInfo*)selected_workout;
                NSMutableDictionary *workoutDict = [[NSMutableDictionary alloc]init];
                workoutDict[@"workout_name"] = workout.workout_name;
                workoutDict[@"workout_description"] = workout.workout_description;
                NSMutableArray *dayArray= [[NSMutableArray alloc]init];
                for (GLDayInfo *day in workout.day_r) {
                    NSMutableDictionary *dayDict = [[NSMutableDictionary alloc]init];
                    dayDict[@"day_name"] = day.day_name;
                    dayDict[@"day_description"] = day.day_description;
                    [dayArray addObject:day];

                }
                workoutDict[@"day_info_ar"] = dayArray;
                [[GLogNetworkEngine sharedEngine]addNewWorkoutForParseUser:workoutDict completionBlock:^(id object) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    isGLWorkout = NO;
                 selected_workout =   [[GLogDataProcessor sharedProcessor]addParseUserWorkout:object];
                    [self addDayToSelectedWorkout];
                    
                    
                } errorBlock:^(NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                }];
            
            }
                break;
                
            default:
                break;
        }
    
    }
    
    else {
    switch (buttonIndex) {
        case 0:
        {
            
            [self performSegueWithIdentifier:@"modifySegue" sender:selectedDay];
        }
            
            break;
            
        default: {
            [self performSegueWithIdentifier:@"exerciseSegue" sender:selectedDay];
        
        }break;
            
            
    }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DayPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayPickerCell"];
    if([selected_workout isKindOfClass:[GLWorkoutInfo class]]){
        GLDayInfo *day = [((GLWorkoutInfo*)self.selected_workout).day_r objectAtIndex:indexPath.row];
        cell.dayTextField.text = day.day_name;

    }
    else {
    DayInfo *day = [((WorkoutInfo*)self.selected_workout).day_r objectAtIndex:indexPath.row];
        cell.dayTextField.text = day.day_name;

    }
    cell.delegate = self;
    return cell;
}

-(void)addBtnPressed:(UIButton*)sender {

    if(isGLWorkout) {
    
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Modifying one of our workouts will create a copy in your workout list. Are you sure you want to do this?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alertView.tag =999;
        [alertView show];
        
    }
    
    else {
    
        [self addDayToSelectedWorkout];
    }
     
}




-(void)alertViewDidPressCancelButton:(GLogAlertView*)alertView {
    [alertView removeFromSuperviewWithFade];
    self.navigationItem.rightBarButtonItem.enabled = YES;

}

-(void)alertViewDidPressDoneButton:(GLogAlertView*)alertView  {

    
    switch (alertView.tag) {
        case 100:
        {
            if(!alertView.alertTextField.text.length) {
                
                [GLogUtility showAlertWithString:@"Please enter a valid name"];
            }
            
           // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            WorkoutInfo *workout = (WorkoutInfo*)selected_workout;
         //   [MBProgressHUD hideHUDForView:self.view animated:YES];
         DayInfo *day =   [[GLogDataProcessor sharedProcessor]addNewDayForWorkout:selected_workout name:alertView.alertTextField.text];
            [alertView removeFromSuperviewWithFade];
            NSInteger index = (workout.day_r.count>0)?workout.day_r.count-1:0;
            [_dayTableView beginUpdates];
            [_dayTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [_dayTableView endUpdates];

            PFQuery *query  = [PFQuery queryWithClassName:kUserWorkoutInfo];
            
            query.cachePolicy = kPFCachePolicyCacheElseNetwork;
            [query whereKey:@"objectId" equalTo:workout.workout_id];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error) {
                    if(query.hasCachedResult) {
                        NSLog(@"CACHED");
                    }
                    PFObject *workout_object = [objects lastObject];
                    NSMutableDictionary *dayDict = [[NSMutableDictionary alloc]init];
                    [dayDict setObject:alertView.alertTextField.text forKey:@"day_name"];
                    [[GLogNetworkEngine sharedEngine]addNewDayForUserWorkout:workout_object params:dayDict completionBlock:^(id object) {
                        
                        PFObject *dayObject = object;
                        day.object_id = dayObject.objectId;
                        [day.managedObjectContext save:nil];
                                         } errorBlock:^(NSError *error) {
                     //   [MBProgressHUD hideHUDForView:self.view animated:YES];

                    }];
                    
                    
                }
                
            }];
            
            
            
            
          //  [[GLogDataProcessor sharedProcessor]addNewDayForWorkout:selected_workout name:alertView.alertTextField.text];
            //[_dayTableView reloadData];
            
        }
            break;
            
        default: {
            if(!alertView.alertTextField.text.length) {
                
                [GLogUtility showAlertWithString:@"Please enter a valid name"];
            }
            [[GLogDataProcessor sharedProcessor]addTagWithName:alertView.alertTextField.text workout:self.selected_workout];
            [_tagCollectionView reloadData];

        }
            break;
    }
    
}

-(void)addDayToSelectedWorkout {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    GLogAlertView *alertView = (GLogAlertView*)[GLogUtility loadViewFromNib:@"GLogAlertView" forClass:[GLogAlertView class]];
    
    alertView.alertTitleLabel.text = @"Enter a suitable name for the day";
    alertView.delegate = self;
    
    alertView.tag = 100;
    CGRect frame =alertView.frame;
    
    frame.origin.x = self.view.frame.size.width/2-frame.size.width/2;
    frame.origin.y = self.view.frame.size.height/2-frame.size.height;
    alertView.frame = frame;
    [self.view addSubviewWithBounce:alertView];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if([segue.identifier isEqualToString:@"exerciseSegue"]){
        GLogExercisePickerVC *pickerVC = segue.destinationViewController;
          pickerVC.selected_day = sender;
    }
    
   
    else {
         GLogInWorkoutVC *pickerVC = segue.destinationViewController;
           pickerVC.selected_day = sender;
        pickerVC.shouldAddTracking = YES;

        
    }
}

-(void)didRenameDayForCell:(DayPickerCell*)cell {

    
    if(!cell.dayTextField.text.length)
    {
        [GLogUtility showAlertWithString:@"Please enter a valid name."]
        ;
        return;
    
    }
    
    
    
    NSIndexPath *indexPath = [_dayTableView indexPathForCell:cell];
    DayInfo *day = [((WorkoutInfo*)self.selected_workout).day_r objectAtIndex:indexPath.row];

    day.day_name = cell.dayTextField.text;
    [day.managedObjectContext save:nil];
    
}

#pragma mark tag collection view methods
#pragma mark Tag Collection View Methods

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   // TagInfo *tag = [self.selected_workout.tag_r objectAtIndex:indexPath.row];
    
  //  sizingCell.tagLabel.text = tag.tag_name;
    NSLog(@"SIZE: %@",NSStringFromCGSize(sizingCell.intrinsicContentSize));
    return [sizingCell intrinsicContentSize];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TagCollectionViewCell";
    
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    TagInfo *tag = [self.selected_workout.tag_r objectAtIndex:indexPath.row];
    //   cell.titleTextView.text = exercise.exercise_name;
  
  //  cell.tagLabel.text = tag.tag_name;
    return cell;
}

- (IBAction)addTagButtonPressed:(UIButton *)sender {
    GLogAlertView *alertView = (GLogAlertView*)[GLogUtility loadViewFromNib:@"GLogAlertView" forClass:[GLogAlertView class]];
    
    alertView.alertTitleLabel.text = @"Enter the name of the tag";
    alertView.delegate = self;
    alertView.alertTextField.placeholder = @"Tag Name";
    alertView.tag = 200;
    CGRect frame =alertView.frame;
    
    frame.origin.x = self.view.frame.size.width/2-frame.size.width/2;
    frame.origin.y = self.view.frame.size.height/2-frame.size.height;
    alertView.frame = frame;
    [self.view addSubviewWithBounce:alertView];

    
}
@end
