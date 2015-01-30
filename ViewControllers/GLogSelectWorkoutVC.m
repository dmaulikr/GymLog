//
//  GLogSelectWorkoutVC.m
//  GymLog
//
//  Created by Amendeep Singh on 29/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogSelectWorkoutVC.h"
#import "WorkoutPickerCell.h"
#import "TagCollectionViewCell.h"
#import "GLogExercisePickerVC.h"
#import "GLogInWorkoutVC.h"
#import "GLogDaySelectorVC.h"
#import "GLogAddWorkoutAlert.h"
#import "FXBlurView.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
@interface GLogSelectWorkoutVC ()<WorkoutCellDelegate,GLogWorkoutAlertViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate> {
    TagCollectionViewCell *sizingCell;
    GLogAddWorkoutAlert *workout_alert_view;
    WorkoutInfo *selectedWorkout;
    NSInteger actionSheetButtonIndex;
    UIDatePicker *datePicker;
   HMSegmentedControl *segControl;
    int swipeMode;
    UIRefreshControl *refreshControl;
    NSDate *refreshDate;
    __weak IBOutlet FXBlurView *blurView;
}
@property (weak, nonatomic) IBOutlet UISearchBar *workoutSearchBar;
- (IBAction)segmentValueChanged:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UITableView *workoutTableView;
@property (weak, nonatomic) IBOutlet UIView *workoutTagView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *tagFetchedResultsController;

@property (weak, nonatomic) IBOutlet UICollectionView *tagCollectionView;


@end

@implementation GLogSelectWorkoutVC
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize tagFetchedResultsController = _tagFetchedResultsController;


- (NSFetchedResultsController *)tagFetchedResultsController {
    
    if (_tagFetchedResultsController != nil) {
        return _tagFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TagInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"tag_name" ascending:YES]]];
    
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[kAppDelegate managedObjectContext] sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.tagFetchedResultsController = theFetchedResultsController;
    //   _fetchedResultsController.delegate = self;
    
    return _tagFetchedResultsController;
    
}


- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString *entityName = @"";
    if(segControl.selectedSegmentIndex==0)
        entityName =@"GLWorkoutInfo";
    
    else entityName = @"WorkoutInfo";
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName inManagedObjectContext:[kAppDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"create_date" ascending:NO]]];
    
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[kAppDelegate managedObjectContext] sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    
    return _fetchedResultsController;
    
}


-(void)fetchTags {
    NSError *error = nil;
    [self.tagFetchedResultsController performFetch:&error];
    
    
    
    [self.tagCollectionView reloadData];
    
    
    
}



-(void)fetchWorkouts {
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
  
    
      [_workoutTableView reloadData];
    
    
    
}


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
   blurView.tintColor = [UIColor clearColor];
    blurView.blurRadius = 35;
   // blurView.updateInterval = 5;
     //  _workoutSearchBar.layer.borderColor = [UIColor darkGrayColor].CGColor;
    //_workoutSearchBar.layer.borderWidth= 0.5f;
   
    segControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"GymLog", @"User"]];
    segControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    [segControl setFrame:CGRectMake(0, 64, 320, 40)];
    [segControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    segControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [segControl setBackgroundColor:[UIColor colorWithRed:(float)34/255 green:(float)83/255 blue:(float)139/255 alpha:1]];
     //[UIColor colorWithRed:(float)30/255 green:(float)83/255 blue:(float)90/255 alpha:1]];
     
     //[UIColor colorWithRed:(float)30/255 green:(float)83/255 blue:(float)90/255 alpha:1]];
   [segControl setSelectionStyle:HMSegmentedControlSelectionStyleBox];

    [segControl setTextColor:[UIColor whiteColor]];
    [segControl setSelectedTextColor:[UIColor whiteColor]];
    [segControl setSelectionIndicatorColor:[UIColor colorWithRed:(float)255/255 green:(float)255/255 blue:(float)255/255 alpha:0.7]];
     //[UIColor colorWithRed:(float)54/255 green:(float)133/255 blue:(float)198/255 alpha:1]];
     //[UIColor colorWithRed:(float)21/255 green:(float)164/255 blue:(float)255/255 alpha:1]];
     //[UIColor colorWithRed:(float)21/255 green:(float)164/255 blue:(float)255/255 alpha:1]];

   [self.workoutTableView.tableHeaderView addSubview:segControl];

   
//    HMSegmentedControl *segmentedControl3 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"GymLog", @"User"]];
//    [segmentedControl3 setSelectionIndicatorHeight:4.0f];
//    [segmentedControl3 setBackgroundColor:[UIColor colorWithRed:(float)21/255 green:(float)164/255 blue:(float)255/255 alpha:1]];
//    [segmentedControl3 setTextColor:[UIColor whiteColor]];
//    [segmentedControl3 setSelectedTextColor:[UIColor whiteColor]];
//    [segmentedControl3 setSelectionIndicatorColor:[UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1]];
//    [segmentedControl3 setSelectionStyle:HMSegmentedControlSelectionStyleBox];
//    [segmentedControl3 setSelectedSegmentIndex:HMSegmentedControlNoSegment];
//    [segmentedControl3 setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
//[segmentedControl3 setFrame:CGRectMake(0, 0 , 320, 40)];
// //   [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
//    segmentedControl3.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
//    [self.view addSubview:segmentedControl3];

    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshWorkouts:) forControlEvents:UIControlEventValueChanged];
    [_workoutTableView addSubview:refreshControl];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[GLogNetworkEngine sharedEngine]syncAdminWorkoutsWithApp:^(id object) {
        [self fetchWorkouts];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NZAlertView *alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                          title:@""
                                                        message:[NSString stringWithFormat:@"Logged in as %@ successfully",[PFUser currentUser].username]
                                                       delegate:nil];
        
        [alert setStatusBarColor:[UIColor colorWithRed:(float)137/255 green:(float)210/255 blue:(float)57/255 alpha:1.0]];
        
        [alert setTextAlignment:NSTextAlignmentCenter];
        
        [alert show];

    }];
    
[[GLogNetworkEngine sharedEngine]getUserWorkouts:^(id object) {
    
}];
    //  _workoutTableView.separatorColor = kBorderColor;
 //   _workoutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[_workoutTableView setSeparatorInset:UIEdgeInsetsZero];

    
    UIButton *addWorkoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addWorkoutButton setImage:[UIImage imageNamed:@"addBtn"] forState:UIControlStateNormal];
    [addWorkoutButton addTarget:self action:@selector(setAddPressed:) forControlEvents:UIControlEventTouchUpInside];
    addWorkoutButton.frame = CGRectMake(0, 0, 37, 37);
    UIBarButtonItem *workoutBarItem = [[UIBarButtonItem alloc]initWithCustomView:addWorkoutButton];
    
    self.navigationItem.rightBarButtonItem = workoutBarItem;

    self.workoutTableView.delegate = self;
    self.workoutTableView.dataSource = self;
    [self fetchWorkouts];
    [self fetchTags];
    
   
    

	// Do any additional setup after loading the view.
}

#pragma mark table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.fetchedResultsController.fetchedObjects.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id workout = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [self performSegueWithIdentifier:@"daySegue" sender:workout];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkoutPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutPickerCell"];
    
    WorkoutInfo *workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.delegate = self;
//    [cell.contentView.layer setBorderColor:kBorderColor.CGColor];
  //  [cell.contentView.layer setBorderWidth:1.0f];
   // cell.workoutTitleLabel.textColor = kBorderColor;
    cell.workoutTitleLabel.text = workout.workout_name;
   // [cell.workoutTitleLabel setFont:[UIFont fontWithName:@"DKCrayonCrumble" size:30]];
 //   [cell.workoutDescriptionLabel setFont:[UIFont fontWithName:@"DKCrayonCrumble" size:22]];

    cell.cell_bg_img_view.image = [UIImage imageNamed:@"select_workout_cell_bg"];
    cell.workoutDescriptionLabel.text = workout.workout_description;
    if(indexPath.row==0 ||indexPath.row==2)
        cell.latestIconView.hidden = NO;
    
    else cell.latestIconView.hidden = YES;
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Gesture Method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    return NO;
}

#pragma mark Tag Collection View Methods

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagFetchedResultsController.fetchedObjects.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    TagInfo *tag = [self.tagFetchedResultsController objectAtIndexPath:indexPath];

    sizingCell.tagLabel.text = tag.tag_name;
    NSLog(@"SIZE: %@",NSStringFromCGSize(sizingCell.intrinsicContentSize));
    return [sizingCell intrinsicContentSize];

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TagCollectionViewCell";
    
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    TagInfo *tag = [self.tagFetchedResultsController objectAtIndexPath:indexPath];
    //   cell.titleTextView.text = exercise.exercise_name;
    
    cell.tagLabel.text = tag.tag_name;
    return cell;
}

#pragma segue perform method

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    if([segue.identifier isEqualToString:@"modifySegue"]){
    GLogExercisePickerVC *pickerVC = segue.destinationViewController;
    pickerVC.selected_day = sender;
    }

    else if([segue.identifier isEqualToString:@"daySegue"]) {
        GLogDaySelectorVC *dayVC = segue.destinationViewController;
        if([sender isKindOfClass:[GLWorkoutInfo class]])
            dayVC.isGLWorkout = YES;
        else dayVC.isGLWorkout = NO;
        dayVC.selected_workout = sender;
    }
    else if([segue.identifier isEqualToString:@"inWorkoutSegue"]){
       GLogInWorkoutVC *pickerVC = segue.destinationViewController;
        pickerVC.selected_day = sender;
        pickerVC.selectedDate = datePicker.date;
        pickerVC.shouldAddTracking = YES;

    
    }
}

-(void)displayActionSheet {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select The Day"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for (DayInfo *day in selectedWorkout.day_r) {
        [actionSheet addButtonWithTitle:day.day_name];
        
    }
    actionSheet.cancelButtonIndex = 0;
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];

}

#pragma cell delegates
-(void)didSelectModifyButtonForCell:(WorkoutPickerCell*)cell {
    NSIndexPath *indexPath = [self.workoutTableView indexPathForCell:cell];
   selectedWorkout = [self.fetchedResultsController objectAtIndexPath:indexPath];
   // [self performSegueWithIdentifier:@"exerciseSegue" sender:workout];
    swipeMode = 1;

    selectedWorkout  = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self displayActionSheet];

    
}
-(void)didSelectStartButtonForCell:(WorkoutPickerCell*)cell {
    NSIndexPath *indexPath = [self.workoutTableView indexPathForCell:cell];
    
    
   selectedWorkout  = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
   
    swipeMode = 2;
    [self displayActionSheet];
  //  [self performSegueWithIdentifier:@"modifySegue" sender:workout];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if(buttonIndex==0) {
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        return;
    }
    
    actionSheetButtonIndex = buttonIndex-1;
    DayInfo *selectedDay = [selectedWorkout.day_r objectAtIndex:actionSheetButtonIndex];

    switch (swipeMode) {
        case 1:
            [self performSegueWithIdentifier:@"modifySegue" sender:selectedDay];

            break;
            
        case 2:
            [self performSegueWithIdentifier:@"inWorkoutSegue" sender:selectedDay];

            break;
    }
    
    

   // [self showTabPickerView];
    
    
    
}




#pragma mark add button method
-(void)setAddPressed:(UIButton*)sender {
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
  workout_alert_view = (GLogAddWorkoutAlert*)[GLogUtility loadViewFromNib:@"GLogAlertView" forClass:[GLogAddWorkoutAlert class]];
    CGRect frame =workout_alert_view.frame;
    workout_alert_view.delegate = self;
    
  //  frame.origin.x = self.view.frame.size.width/2-frame.size.width/2;
    //frame.origin.y = self.view.frame.size.height/2-frame.size.height;
 //   workout_alert_view.frame = frame;
    workout_alert_view.center = self.view.center;
   // [self.view addSubviewWithBounce:workout_alert_view];

    [workout_alert_view showOnScreen];
    //[self performSegueWithIdentifier:@"calendarSegue" sender:self];
}

#pragma mark alert view delegates
-(void)alertViewDidPressCreateButton:(GLogAddWorkoutAlert*)alertView  {
self.navigationItem.rightBarButtonItem.enabled = YES;
    [alertView.backgroundView removeFromSuperviewWithFade];

    [alertView removeFromSuperviewWithFade];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFObject *workout = [PFObject objectWithClassName:kUserWorkoutInfo];
    [workout setObject:alertView.workoutTextfield.text forKey:@"workout_name"];
    [workout setObject:[PFUser currentUser] forKey:@"user_info_p"];
    [workout saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(!error) {
        
            [[GLogDataProcessor sharedProcessor]addParseUserWorkout:workout];
            [segControl setSelectedSegmentIndex:1];
            self.fetchedResultsController = nil;
            [self fetchWorkouts];
        }
    }];
    //[[GLogDataProcessor sharedProcessor]addWorkoutWithName:alertView.workoutTextfield.text description:@""];
   // [self fetchWorkouts];
    
    
}
-(void)alertViewDidPressCancelButton:(GLogAddWorkoutAlert*)alertView {
self.navigationItem.rightBarButtonItem.enabled = YES;
    [alertView.backgroundView removeFromSuperviewWithFade];
    [alertView removeFromSuperviewWithFade];

}

#pragma mark Segment Value Changed
- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    self.fetchedResultsController = nil;
    [self fetchWorkouts];
    

  }

-(void)refreshWorkouts:(UIRefreshControl*)sender {

    switch (segControl.selectedSegmentIndex) {
        case 0:
        {
            [[GLogNetworkEngine sharedEngine]syncAdminWorkoutsWithApp:^(id object) {
                self.fetchedResultsController = nil;
                [self fetchWorkouts];
                [refreshControl endRefreshing];
    
            }];
        }
            break;
            
        default: {
        [[GLogNetworkEngine sharedEngine]getUserWorkouts:^(id object) {
            self.fetchedResultsController = nil;
            [self fetchWorkouts];
            [refreshControl endRefreshing];

        }];
        }
            break;
    }
  
    
}
@end
