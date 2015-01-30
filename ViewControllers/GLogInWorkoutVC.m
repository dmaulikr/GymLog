//
//  GLogInWorkoutVC.m
//  GymLog
//
//  Created by Amendeep Singh on 01/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogInWorkoutVC.h"
#import "InWorkoutCell.h"
#import "GLogBlendView.h"
#import "GLogPlateView.h"
#import "StyledPullableView.h"
#import "InWorkoutTileCell.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "GLogBarbellView.h"
#import "GLogAddWorkoutAlert.h"
#import "GLogPickerCollectionLayout.h"
#import "GLogWorkoutSummaryVC.h"
#import "GLogSelectWorkoutVC.h"
#import "SPUserResizableView.h"
#import "GLogDialerView.h"
#import "GLogExercisePickerVC.h"
#import "GLogCollectionFlowLayout.h"
#import "GLogDumbellView.h"
//#import "GLogPullableView.h"
@interface GLogInWorkoutVC () <UICollectionViewDataSource,UICollectionViewDelegate,WeightViewDelegate,UIAlertViewDelegate,PullableViewDelegate>{
    NSMutableArray *pickerDataSouceArray ;
    SPUserResizableView *resizableView;
    StyledPullableView *pullUpView;
    ExerciseInfo *selectedExercise;
    SetInfo *selected_set;
    CGFloat totalSelectedWeight;
    GLogBarbellView *barbellView;
    GLogPlateView *plateView;
    GLogDialerView *dialerView;
    GLogDumbellView *dumbellView;
    HistoryInfo *current_history_object;
    NSMutableArray *exerciseArray;
    __weak IBOutlet UIView *repetitionSliderView;
  __weak  id weightView;
    __weak IBOutlet UIImageView *dividerView;
    __weak IBOutlet UISlider *repSlider;
    UIDatePicker *datePicker;
}
@property (weak, nonatomic) IBOutlet UIButton *finishSetBtn;
- (IBAction)nextButtonPressed:(UIButton *)sender;
- (IBAction)previousBtnPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *currentExerciseLabel;
@property (strong, nonatomic)  UICollectionView *tileCollectionView;

@property (weak, nonatomic) IBOutlet UIPickerView *repetitionPicker;
@property (weak, nonatomic) IBOutlet UIView *weightPickerView;
@property (weak, nonatomic) IBOutlet UITableView *workoutTableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation GLogInWorkoutVC
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize shouldAddTracking;
@synthesize selected_day;
@synthesize selectedDate;

-(void)createDumbellView {
    
    dumbellView =(GLogDumbellView*) [GLogUtility loadViewFromNib:@"GLogDumbellView" forClass:[GLogDumbellView class]];
    dumbellView.delegate = self;
    CGRect frame = dumbellView.frame;
    frame.origin.x =0;
    frame.origin.y = 38;
    dumbellView.frame = frame;
    
    dumbellView.totalWeightValue = 0;
    dumbellView.totalWeightLabel.text = [NSString stringWithFormat:@"0 %@",kDefaultWeightMetric];
    [self.selectionPickView addSubview:dumbellView];
    dumbellView.hidden = YES;


}

-(void)createPlateView {
    
        plateView =(GLogPlateView*) [GLogUtility loadViewFromNib:@"GLogPlateView" forClass:[GLogPlateView class]];
        CGRect frame = plateView.frame;
        frame.origin.x =0;
        frame.origin.y = 38;
    plateView.frame = frame;
    plateView.delegate = self;
   //     plateView.totalWeightValue = 100;
        plateView.totalWeightLabel.text = [NSString stringWithFormat:@"100 %@",kDefaultWeightMetric];
        [self.selectionPickView addSubview:plateView];
   plateView.hidden = YES;
   // weightView = plateView;
}

-(void)createDialerView {
    
    dialerView =(GLogDialerView*) [GLogUtility loadViewFromNib:@"GLogDialerView" forClass:[GLogDialerView class]];
    CGRect frame = dialerView.frame;
    frame.origin.x =0;
    frame.origin.y = 38;
    dialerView.delegate = self;
    dialerView.frame = frame;
    dialerView.hidden = YES;
    [self.selectionPickView addSubview:dialerView];
    //  weightView = dialerView;
    
    
}
-(void)createBarbellView {

     barbellView =(GLogBarbellView*) [GLogUtility loadViewFromNib:@"GLogBarbellView" forClass:[GLogBarbellView class]];
    barbellView.delegate = self;
    CGRect frame = barbellView.frame;
    frame.origin.x =0;
    frame.origin.y = 38;
    barbellView.frame = frame;

    barbellView.totalWeightValue = 0;
    barbellView.totalWeightLabel.text = [NSString stringWithFormat:@"0 %@",kDefaultWeightMetric];
    [self.selectionPickView addSubview:barbellView];
    barbellView.hidden = YES;

}

-(void)createTileView {
    
    CGFloat xOffset =0;
    
    //resizableView = [[SPUserResizableView alloc]initWithFrame:CGRectMake(xOffset, 480, 320, 40)];
   // [resizableView showEditingHandles];

    pullUpView = [[StyledPullableView alloc] initWithFrame:CGRectMake(xOffset, 0, 320, 460)];
    pullUpView.openedCenter = CGPointMake(160 + xOffset,self.view.frame.size.height+130);
    pullUpView.closedCenter = CGPointMake(160 + xOffset, self.view.frame.size.height +200);
   // pullUpView.center = pullUpView.openedCenter;
    pullUpView.backgroundColor = [UIColor clearColor];
    pullUpView.handleView.frame = CGRectMake(0, 0, 320, 40);
    pullUpView.delegate =  self;
 //   pullUpView.clipsToBounds = YES;
    UIImageView *pullTrayView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tray_bar"]];
    pullTrayView.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    [pullUpView addSubview:pullTrayView];
  //  [GLogUtility setAnchorPoint:CGPointMake(1, 0) forView:pullUpView];
    GLogCollectionFlowLayout *layout=[[GLogCollectionFlowLayout alloc] init];
  //  self.tileCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 320, 400)collectionViewLayout:layout];

   
    

    
    self.tileCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, pullUpView.handleView.frame.origin.y+30, 320, 240)collectionViewLayout:layout];
    self.tileCollectionView.delegate = self;
  //  self.tileCollectionView.scrollEnabled = NO;
    self.tileCollectionView.scrollEnabled = NO;

    self.tileCollectionView.backgroundColor = [UIColor clearColor];
    self.tileCollectionView.dataSource = self;    [resizableView setContentView:self.tileCollectionView];
//    [self.view addSubview:resizableView];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-18, self.tileCollectionView.frame.size.height)];
    [bgView setBackgroundColor:[UIColor colorWithRed:(float)205/255 green:(float)206/255 blue:(float)208/255 alpha:0.36]];
    [pullUpView addSubview:bgView];
   [pullUpView addSubview:self.tileCollectionView];
    
    [self.view addSubview:pullUpView];

    UINib *cellNib = [UINib nibWithNibName:@"InWorkoutTileCell" bundle:nil];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)_tileCollectionView.collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 0;
    [self.tileCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"InWorkoutTileCell"];
  //  [self.tileCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionTop];

    
}


- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"ExerciseInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date_added" ascending:YES]]];
    
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[kAppDelegate managedObjectContext] sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    
    return _fetchedResultsController;
    
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
    
 //   CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 0.5);
  //  repSlider.transform = trans;
    
    if(shouldAddTracking)
        [self beginWorkoutTracking];

    
    
    
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight )];
    [[self workoutTableView] addGestureRecognizer:recognizer];
    
    UISwipeGestureRecognizer *left_recognizer;
    
    left_recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [left_recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft )];
    [[self workoutTableView] addGestureRecognizer:left_recognizer];
    [_finishSetBtn addTarget:self action:@selector(setAddPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addWorkoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addWorkoutButton setImage:[UIImage imageNamed:@"addBtn"] forState:UIControlStateNormal];
    [addWorkoutButton addTarget:self action:@selector(modifyWorkoutPressed:) forControlEvents:UIControlEventTouchUpInside];
    addWorkoutButton.frame = CGRectMake(0, 0, 37, 37);
    UIBarButtonItem *workoutBarItem = [[UIBarButtonItem alloc]initWithCustomView:addWorkoutButton];
    
    
    UIButton *checkMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [checkMarkButton setImage:[UIImage imageNamed:@"checkmarkButton"] forState:UIControlStateNormal];
    [checkMarkButton addTarget:self action:@selector(checkBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    checkMarkButton.frame = CGRectMake(0, 0, 37, 37);
    UIBarButtonItem *checkMarkButtonItem = [[UIBarButtonItem alloc]initWithCustomView:checkMarkButton];

    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:checkMarkButtonItem,workoutBarItem, nil];
    [self clearPreviousSets];
       self.title = selected_day.workout_r.workout_name;
    pickerDataSouceArray = [NSMutableArray new];
    for (int count=1; count<51; count++) {
        
        [pickerDataSouceArray addObject:[NSNumber numberWithInt:count]];
        
    }
    [self.repetitionPicker reloadAllComponents];
    [self createTileView];
    [self createBarbellView];
    [self createPlateView];
    [self createDialerView];
    [self createDumbellView];
    
    
   	// Do any additional setup after loading the view.
}

-(void)clearPreviousSets {

    for (ExerciseInfo *exercise in selected_day.exercise_r) {
        exercise.set_r = nil;
    }
    
    [selected_day.managedObjectContext save:nil];
}

-(void)showWeightSelectorForExercise:(ExerciseInfo*)exercise {
    if(weightView)
        ((GLogWeightBaseView*)weightView).hidden = YES;
    
    
    switch ([exercise.gl_exercise_r.equipment_type intValue]) {
        case 1:
        {
            barbellView.hidden = NO;
            weightView = barbellView;
            
        }
            break;
            
        case 2:
        {
            dialerView.hidden = NO;
            weightView = dialerView;
            
        }
            
            break;
            
        case 3:
        {
            plateView.hidden = NO;
            weightView = plateView;
            
        }
            
            break;
            
            case 4:
        {
            dumbellView.hidden = NO;
        
            weightView = dumbellView;
        }
            break;
            
            
        case 5: {
                  }
            
            break;
    }
    
    
    if([exercise.equipment_type integerValue]==5) {
        CGRect frame = _repetitionPicker.frame;
        dividerView.hidden = YES;
        frame.origin.x = 70;
        [UIView animateWithDuration:0.25 animations:^{
            _repetitionPicker.frame = frame;
        }];

    }
    else {
        CGRect frame = _repetitionPicker.frame;
        dividerView.hidden = NO;

        frame.origin.x = 157;
        [UIView animateWithDuration:0.25 animations:^{
            _repetitionPicker.frame = frame;
        }];

    }

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(exerciseArray) {
        [exerciseArray removeAllObjects];
        exerciseArray =  nil;
    }
    exerciseArray = [[NSMutableArray alloc]initWithArray:[selected_day.exercise_r array]];
    
    [exerciseArray insertObject:@"" atIndex:0];

    if(selected_day.exercise_r.count) {
        ExerciseInfo *exercise = [selected_day.exercise_r objectAtIndex:0];
        _currentExerciseLabel.text = exercise.exercise_name;
        selectedExercise = exercise;
        
       
        [self showWeightSelectorForExercise:selectedExercise];
        if(selectedExercise.set_r.count)
        {
            selected_set = [selectedExercise.set_r objectAtIndex:0];
            NSInteger index = [selectedExercise.set_r indexOfObject:selected_set];
            
            [self performSelector:@selector(selectRowForTableView:) withObject:[NSIndexPath indexPathForRow:index inSection:0] afterDelay:0.25];
        }
        [_workoutTableView reloadData];


//        [_workoutTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[selectedExercise.set_r count]-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
//        [self tableView:_workoutTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[selectedExercise.set_r count]-1 inSection:0]];

    }
    

    [self.tileCollectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark picker delegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    return [pickerDataSouceArray count];

}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 64;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UILabel *)label
{
    NSNumber *number = [pickerDataSouceArray objectAtIndex:row];
    if(!label){
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 64)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:37];
    }
    label.text = [NSString stringWithFormat:@"%d reps",[number intValue]];
    return label;
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//
//{
//    NSNumber *number = [pickerDataSouceArray objectAtIndex:row];
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d reps",[number intValue]] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:13]}];
//    
//    return attString;
//
//}
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
//{
//    
//    NSNumber *number = [pickerDataSouceArray objectAtIndex:row];
//    return [NSString stringWithFormat:@"%d reps",[number intValue]];
//    
//}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    
    NSNumber *number = [pickerDataSouceArray objectAtIndex:row];
    
    
    if(selected_set)
    {
    
        selected_set.set_repetitions = number;
        [self reloadSelectedSetRow];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        SetInfo *set = [selectedExercise.set_r objectAtIndex:indexPath.row];
        
        
        
        [tableView beginUpdates];
        [[kAppDelegate managedObjectContext]deleteObject:set];
        [[kAppDelegate managedObjectContext]save:nil];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        NSInteger tileIndex = [exerciseArray indexOfObject:selectedExercise];

        [_tileCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:tileIndex inSection:0]]];

    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(selectedExercise)
     return selectedExercise.set_r.count;
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger previousIndex = [selectedExercise.set_r indexOfObject:selected_set];

    
    SetInfo *set =  [selectedExercise.set_r objectAtIndex:indexPath.row];
    selected_set= set;
    
[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:previousIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
  InWorkoutCell*  cell  =(InWorkoutCell*) [tableView cellForRowAtIndexPath:indexPath];
    cell.cell_bgView.backgroundColor = [UIColor colorWithRed:(float)74/255 green:(float)74/255 blue:(float)74/255 alpha:1.0];
    cell.setBgView.backgroundColor =[UIColor colorWithRed:(float)198/255 green:(float)76/255 blue:(float)76/255 alpha:1.0];
    cell.titleLabel.textColor = [UIColor whiteColor];
    
    [weightView updateCurrentWeightValue:[set.set_weight floatValue]];
    [self.repetitionPicker selectRow:[selected_set.set_repetitions integerValue]-1  inComponent:0 animated:YES];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InWorkoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InWorkoutCell"];
    
    SetInfo *set =  [selectedExercise.set_r objectAtIndex:indexPath.row];
    if([set.objectID isEqual:selected_set.objectID]) {
        
        cell.cell_bgView.backgroundColor = [UIColor colorWithRed:(float)74/255 green:(float)74/255 blue:(float)74/255 alpha:1.0];
        cell.setBgView.backgroundColor =[UIColor colorWithRed:(float)198/255 green:(float)76/255 blue:(float)76/255 alpha:1.0];
        cell.titleLabel.textColor = [UIColor whiteColor];

      

    //    cell.cell_bgImgView.image = [UIImage imageNamed:@"selectedSetBg"];
    }
    else {
        cell.cell_bgView.backgroundColor =[UIColor colorWithRed:(float)252/255 green:(float)252/255 blue:(float)252/255 alpha:1.0];
        cell.setBgView.backgroundColor =[UIColor colorWithRed:(float)120/255 green:(float)142/255 blue:(float)168/255 alpha:1.0];
        cell.titleLabel.textColor = [UIColor blackColor];

        
    }
    if([selectedExercise.equipment_type integerValue]==5)
        cell.titleLabel.text = [NSString stringWithFormat:@"SET %ld: %d %@",(long)indexPath.row +1,[set.set_repetitions intValue],@"reps"];

        else
    cell.titleLabel.text = [NSString stringWithFormat:@"%d %@ x %d %@",[set.set_weight intValue],kDefaultWeightMetric,[set.set_repetitions intValue],@"reps"];
    
    cell.setLabel.text = [NSString stringWithFormat:@"Set %d",indexPath.row +1];
    
    

  //  InWorkoutCell *workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
 
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 36;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
#pragma mark collection view methods
#pragma mark collection view cell paddings
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}


- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [exerciseArray count];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  //  if(indexPath.row==0)
    //    return CGSizeMake(212, 80);

    return CGSizeMake(106, 80);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"InWorkoutTileCell";
    
    InWorkoutTileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    
    ExerciseInfo *exercise = [exerciseArray objectAtIndex:indexPath.row];
    if([exercise isKindOfClass:[ExerciseInfo class]]) {
        
        cell.setCountLabel.text = [NSString stringWithFormat:@"%d",exercise.set_r.count];
        
        cell.pr_icon_imageView.hidden = YES;

        
        BOOL hasPRRecord = NO;
        
        
            
        
        if(indexPath.row==1){
                hasPRRecord = YES;
                cell.pr_icon_imageView.hidden = NO;
        }

        
       
        
        
        
        
        
        if(exercise.set_r.count)
            cell.tick_imgView.image = [UIImage imageNamed:@"tick_selected_icon"];
        
        else cell.tick_imgView.image= [UIImage imageNamed:@"tick_unselected_icon"];
        
        cell.ex_icon.hidden = YES;
        for (ExIconInfo *icon in exercise.icon_r) {
            UIImage *image = [UIImage imageNamed:icon.icon_name];
            if(image) {
                cell.ex_icon.hidden = NO;
                
                
                cell.ex_icon.image = image;
                CGRect frame = cell.ex_icon.frame;
                frame.size.height = image.size.height;
                frame.size.width = image.size.width;
                
                
                cell.ex_icon.frame = frame;
            }
        }
        
        
        
        cell.ex_icon.center = cell.contentView.center;
        CGPoint center = cell.ex_icon.center;
        
        center.y +=25;
        if(hasPRRecord)
            center.x -=5;
        
        else center.x -=20;

        cell.ex_icon.center = center;

        cell.hidden = NO;
    //   cell.titleTextView.text = exercise.exercise_name;
    if([selectedExercise isEqual:exercise]) {
        cell.bgImageView.image = [UIImage imageNamed:@"selected_tile_button"];

    }
    else cell.bgImageView.image = nil;
    cell.title_label.text = exercise.exercise_name;
    }
    
    
    else {
        
        cell.title_label.text = @"";
        cell.bgImageView.image = nil;
        cell.hidden = YES;

        
    }
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    InWorkoutTileCell *cell = (InWorkoutTileCell*)[collectionView cellForItemAtIndexPath:indexPath];


    ExerciseInfo *exercise = [exerciseArray objectAtIndex:indexPath.row];

    if(![exercise isKindOfClass:[ExerciseInfo class]])
        return;
    
    
    int deletedBlankCount =0;
    if(selectedExercise) {
        NSInteger last_index = [exerciseArray indexOfObject:selectedExercise];
        
        InWorkoutTileCell *lastCell =(InWorkoutTileCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:last_index inSection:0]];
        
        lastCell.bgImageView.image = nil;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF==%@",@""];
        
        NSArray *filteredArray = [exerciseArray filteredArrayUsingPredicate:predicate];
        
        for (NSString *string in filteredArray) {
            deletedBlankCount +=1;
            NSInteger blankObjectIndex =    [exerciseArray indexOfObject:string];
            [exerciseArray removeObjectAtIndex:blankObjectIndex];
            [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:blankObjectIndex inSection:0]]];
        }
        
        
            }
    
    
    
    
    
        cell.bgImageView.image = [UIImage imageNamed:@"selected_tile_button"];
    
    NSInteger acutalIndex = (indexPath.row+1 )-deletedBlankCount;
    
    switch (acutalIndex%3) {
        case 0:
        {
            [exerciseArray insertObject:@"" atIndex:0];
            [exerciseArray insertObject:@"" atIndex:1];
            [collectionView insertItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForItem:0 inSection:0],[NSIndexPath indexPathForItem:1 inSection:0], nil]];

            
        }
            break;
            
        case 1: {
            [exerciseArray insertObject:@"" atIndex:0];
  [collectionView insertItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForItem:0 inSection:0], nil]];
            
            
        }
            break;
            
        case 2: {
            
        }
            break;
    }

//    [collectionView.collectionViewLayout invalidateLayout];

    selectedExercise = exercise;
   
    [self showWeightSelectorForExercise:selectedExercise];
    
    
    if(selectedExercise.set_r.count) {
        selected_set = [selectedExercise.set_r objectAtIndex:0];
    }
    _currentExerciseLabel.text = selectedExercise.exercise_name;
 //   NSInteger newIndex = [exerciseArray indexOfObject:exercise];
  //  NSIndexPath *newIP = [NSIndexPath indexPathForItem:newIndex inSection:0];
   [collectionView reloadData];
    [_workoutTableView reloadData];
    [collectionView setContentOffset:CGPointMake(0, cell.frame.origin.y) animated:YES];
    //[collectionView scrollToItemAtIndexPath:newIP atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
  //  [collectionView scrollRectToVisible:cell.frame animated:YES];

}

-(void)modifyWorkoutPressed:(UIButton*)sender{

    [self performSegueWithIdentifier:@"exerciseSegue" sender:selected_day];
}

-(void)setAddPressed:(UIButton*)sender {

    if(selectedExercise) {
    
      SetInfo *set =  [[GLogDataProcessor sharedProcessor]addNewSetForExercise:selectedExercise];
        
        if(selected_set) {
        
            set.set_repetitions = [NSNumber numberWithInt:[selected_set.set_repetitions integerValue]];
            set.set_weight = [NSNumber numberWithInt:[selected_set.set_weight floatValue]];

        }
        
        else {
          NSNumber *number=   [pickerDataSouceArray objectAtIndex:[self.repetitionPicker selectedRowInComponent:0]];
            set.set_repetitions = number;
            set.set_weight = [NSNumber numberWithFloat:((GLogWeightBaseView*)weightView).totalWeightValue];
         //   selected_set = set;
        }
        
        [_workoutTableView beginUpdates];
       [_workoutTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[selectedExercise.set_r count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [_workoutTableView endUpdates];
        
    
        [_workoutTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[selectedExercise.set_r count]-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:_workoutTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[selectedExercise.set_r count]-1 inSection:0]];


        NSInteger tileIndex = [exerciseArray indexOfObject:selectedExercise];
        
        [_tileCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:tileIndex inSection:0]]];
        
    }
}

-(void)reloadSelectedSetRow {

    if(selected_set) {
        NSInteger index = [selectedExercise.set_r indexOfObject:selected_set];
        [_workoutTableView beginUpdates];
        [_workoutTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [_workoutTableView endUpdates];

        [self performSelector:@selector(selectRowForTableView:) withObject:[NSIndexPath indexPathForRow:index inSection:0] afterDelay:0.25];
    }
}


-(void)selectRowForTableView:(NSIndexPath*)indexPath {
    [_workoutTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];

}

-(void)didSelectWeightWithValue:(CGFloat)weight_value {

    
    selected_set.set_weight = [NSNumber numberWithFloat:weight_value];
    
    [self reloadSelectedSetRow];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer*)sender {
    
  //  NSInteger index = [selected_day.exercise_r indexOfObject:selectedExercise];
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
        {
        //    index-=1;
            [self nextButtonPressed:nil];
        
        }
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
        {
            [self previousBtnPressed:nil];

         //   ;

        }
            break;
        case UISwipeGestureRecognizerDirectionUp: {
        
        }
            break;
            
        case UISwipeGestureRecognizerDirectionDown: {
        
        }
            break;
    }

}

- (IBAction)nextButtonPressed:(UIButton *)sender {
    
    NSInteger index = [selected_day.exercise_r indexOfObject:selectedExercise];
    
    if(index<[selected_day.exercise_r count]-1) {
        index+=1;
        ((GLogWeightBaseView*)weightView).totalWeightValue = 0.0;
        ((GLogWeightBaseView*)weightView).totalWeightLabel.text = [NSString stringWithFormat:@"0 %@",kDefaultWeightMetric];
        

        ExerciseInfo *newExercise = [selected_day.exercise_r objectAtIndex:index];
        if(newExercise.set_r.count) {
            selected_set = [newExercise.set_r objectAtIndex:0];
        }
        else {
                     selected_set = nil;
        }
        NSIndexPath *ip = [NSIndexPath indexPathForItem:[exerciseArray indexOfObject:newExercise] inSection:0];
        //[self.tileCollectionView selectItemAtIndexPath:ip animated:YES scrollPosition:UICollectionViewScrollPositionTop];
        [self collectionView:self.tileCollectionView didSelectItemAtIndexPath:ip];
        [_workoutTableView reloadData];
        if(newExercise.set_r.count) {
        [_workoutTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:_workoutTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

        }
    }

    
    
}

- (IBAction)previousBtnPressed:(UIButton *)sender {
    NSInteger index = [selected_day.exercise_r indexOfObject:selectedExercise];
    
    if(index>0) {
        index-=1;

        ExerciseInfo *newExercise = [selected_day.exercise_r objectAtIndex:index];
        ((GLogWeightBaseView*)weightView).totalWeightValue = 0.0;
        
        ((GLogWeightBaseView*)weightView).totalWeightLabel.text = [NSString stringWithFormat:@"0 %@",kDefaultWeightMetric];

        if(newExercise.set_r.count) {
            selected_set = [newExercise.set_r objectAtIndex:0];
        }
        else  {
            
            selected_set = nil;
         

        }
        NSIndexPath *ip = [NSIndexPath indexPathForItem:[exerciseArray indexOfObject:newExercise] inSection:0];
      //  [self.tileCollectionView selectItemAtIndexPath:ip animated:YES scrollPosition:UICollectionViewScrollPositionTop];
        [self collectionView:self.tileCollectionView didSelectItemAtIndexPath:ip];
        
        [_workoutTableView reloadData];
        if(newExercise.set_r.count) {

        [_workoutTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:_workoutTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
    }

}

-(void)checkBtnPressed:(UIButton*)sender {

    UIAlertView *checkoutAlert =[ [UIAlertView alloc]initWithTitle:@"" message:@"Do you want to finish this workout?." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [checkoutAlert show];
    
  //  [self performSegueWithIdentifier:@"summarySegue" sender:current_history_object];
}

#pragma mark date picker
-(void)pickerDoneButtonPressed:(UIBarButtonItem*)sender {
    
    UIToolbar *doneToolBar = (UIToolbar*)[self.view viewWithTag:33];
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame =   datePicker.frame ;
        CGRect toolBarFrame = doneToolBar.frame;
        
        toolBarFrame.origin.y +=202;
        frame.origin.y +=162;
        
        
        
        doneToolBar.frame = toolBarFrame;
        datePicker.frame = frame;
        
    }completion:^(BOOL finished) {
        
        
        current_history_object.workout_duration = [NSNumber numberWithInteger:[current_history_object.workout_end_time timeIntervalSinceDate:current_history_object.workout_start_time]];
        
        current_history_object.workout_end_time = [NSDate date];

        current_history_object.workout_start_time = datePicker.date;
        [current_history_object.managedObjectContext save:nil];
        [[GLogNetworkEngine sharedEngine]addWorkoutHistory:current_history_object completion:^(id object) {
            
        } errorBlock:^(NSError *error) {
            
        }];
        
        GLogWorkoutSummaryVC *summaryVC = [kStoryboard_iPhone instantiateViewControllerWithIdentifier:@"GLogWorkoutSummaryVC"];
        
        
        GLogSelectWorkoutVC *workoutVC = [kStoryboard_iPhone instantiateViewControllerWithIdentifier:@"GLogSelectWorkoutVC"];
        summaryVC.workout_history = current_history_object;
       // [self.navigationController pushViewController:summaryVC animated:YES];
        [self.navigationController setViewControllers:[NSArray arrayWithObjects:workoutVC,summaryVC, nil] animated:YES];

    }];
    
}


-(void)showTabPickerView {
    UIToolbar *doneToolBar;
    if(!datePicker){
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, 50)];
        
        [self.view addSubview:datePicker];
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.tag = 2;
    }
    
    if(![self.view viewWithTag:33]){
        doneToolBar = [[UIToolbar alloc] init];
        doneToolBar.barStyle = UIBarStyleDefault;
        doneToolBar.translucent = YES;
        doneToolBar.tintColor = nil;
        [doneToolBar sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(pickerDoneButtonPressed:)] ;
        doneToolBar.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, 44);
        [doneToolBar setItems:[NSArray arrayWithObjects:doneButton, nil]];
        doneToolBar.tag = 33;
        [self.view addSubview:doneToolBar];
        
    }
    else doneToolBar = (UIToolbar*)[self.view viewWithTag:33];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame =   datePicker.frame ;
        CGRect toolBarFrame = doneToolBar.frame;
        frame.origin.y -=162;
        toolBarFrame.origin.y-=202;
        
        doneToolBar.frame = toolBarFrame;
        datePicker.frame = frame;
        
    }completion:^(BOOL finished) {
       
    }];
  }


-(void)saveSetsForAllExercises {
  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 1:
        {
            [[GLogNetworkEngine sharedEngine]insertSetsForAllExercises:selected_day.exercise_r completion:^(id object) {
                
            } errorBlock:^(NSError *error) {
                
            }];
           
           // [self saveSetsForAllExercises];
            
            [self showTabPickerView];
            

        }
            break;
            
        default: {
        
        }
            break;
    }
}

-(void)beginWorkoutTracking {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [dict setValue:selected_day.workout_r.workout_name forKey:@"workout_name"];
    
    
    
    current_history_object = [[GLogDataProcessor sharedProcessor]createWorkoutHistory:dict exerciseList:selected_day.exercise_r];
    
//    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
  //  unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;

//    NSDateComponents *dateComp = [gregorian components:unitFlags fromDate:[NSDate date]];
//    NSDateComponents *components = [[NSDateComponents alloc]init];
//	[components setDay:22];
//	[components setMonth:[dateComp month]-1];
//	[components setYear:[dateComp year]];
//    
//	// create a gregorian calendar
//    
//    
//	// create the startDate date object
//	NSDate *startDate = [gregorian dateFromComponents:components];
//    NSDateFormatter *df = [[NSDateFormatter alloc]init];
//    [df setDateStyle:NSDateFormatterFullStyle];
//    NSLog(@"%@",[df stringFromDate:startDate]);
  //  current_history_object.workout_start_time = selectedDate;
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    if([segue.identifier isEqualToString:@"summarySegue"]) {
    GLogWorkoutSummaryVC *summaryVC = segue.destinationViewController;
    
    summaryVC.workout_history = sender;
    }
    
    else if([segue.identifier isEqualToString:@"exerciseSegue"]) {
        
        GLogExercisePickerVC *exerciseVC = segue.destinationViewController;
        exerciseVC.selected_day = sender;
    }
    
}

-(void)pullableViewDidSnapToTopRow {
    NSInteger newIndex = [exerciseArray indexOfObject:selectedExercise];
    NSIndexPath *ip = [NSIndexPath indexPathForItem:newIndex inSection:0];
    InWorkoutCell *cell =(InWorkoutCell*) [self.tileCollectionView cellForItemAtIndexPath:ip];
    if(cell)
    [self.tileCollectionView setContentOffset:CGPointMake(0, cell.frame.origin.y) animated:YES];
    
    else {
        [self.tileCollectionView scrollToItemAtIndexPath:ip atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
     
         cell =(InWorkoutCell*) [self.tileCollectionView cellForItemAtIndexPath:ip];
        [self.tileCollectionView setContentOffset:CGPointMake(0, cell.frame.origin.y) animated:YES];

    }

    self.tileCollectionView.scrollEnabled  = NO;
}
-(void)pullableViewDidExpandFull {
    self.tileCollectionView.scrollEnabled  = YES;
    
}
-(void)pullableViewDidClose {}

@end
