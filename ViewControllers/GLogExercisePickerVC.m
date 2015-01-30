//
//  GLogExercisePickerVC.m
//  GymLog
//
//  Created by Amendeep Singh on 23/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogExercisePickerVC.h"
#import "ExercisePickerCell.h"
#import "PickerTileCollectionCell.h"
#import "UIImage+BlendMode.h"
#import "GLogBlendView.h"
#import "StyledPullableView.h"
#import "FXBlurView.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "ILTranslucentView.h"

#define kAnimationSpeed 680
@interface GLogExercisePickerVC ()<PullableViewDelegate> {

 BodyPartInfo *selectedPart;
    NSInteger selectedSection;
    NSMutableArray *exerciseArray;
    NSMutableArray *selectedExerciseArray;
    PickerTileCollectionCell *sizingCell;
    UIPanGestureRecognizer *panGesture;
    
    StyledPullableView *pullUpView;
    UIView *currentCellView;
    GLExerciseInfo *popularExercise;
    
}
@property (strong, nonatomic)  UICollectionView *tileCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *pickerTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *bodyPartTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;

@end

@implementation GLogExercisePickerVC
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize selected_day;
@synthesize isOriginalWorkout;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"BodyPartInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"body_part_name" ascending:YES]]];

    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[kAppDelegate managedObjectContext] sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
 //   _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}


-(void)fetch {
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if([self.fetchedResultsController fetchedObjects].count)
        selectedPart = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    
    selectedSection= 0;
    [self prepareExercisesForBodyPart];
//    exerciseArray = [selectedPart.gl_exercise_r.allObjects mutableCopy];
//    _bodyPartTitleLabel.text = selectedPart.body_part_name;
//    NSSortDescriptor*sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"relation_count" ascending:NO];
//    NSArray *array = [exerciseArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
//    if(array.count) {
//        popularExercise = [array objectAtIndex:0];
//    }
    [_pickerTableView reloadData];
        
    
    
}

-(void)createTrayPullableView {
    CGFloat xOffset = 0;

    pullUpView = [[StyledPullableView alloc] initWithFrame:CGRectMake(xOffset, 0, 320, 460)];
    pullUpView.delegate = self;
    pullUpView.openedCenter = CGPointMake(160 + xOffset,self.view.frame.size.height-27);
    pullUpView.closedCenter = CGPointMake(160 + xOffset, self.view.frame.size.height + 80);
    // pullUpView.center = pullUpView.openedCenter;
    pullUpView.backgroundColor = [UIColor clearColor];
    pullUpView.handleView.frame = CGRectMake(0, 0, 320, 80);
    
    UIImageView *pullTrayView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tray_bar"]];
    pullTrayView.frame = CGRectMake(10, 0, self.view.frame.size.width-18, 30);
    [pullUpView addSubview:pullTrayView];
    
    LXReorderableCollectionViewFlowLayout *layout=   [[LXReorderableCollectionViewFlowLayout alloc]init];
    
    self.tileCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, pullUpView.handleView.frame.origin.y+30, self.view.frame.size.width-18, 245)collectionViewLayout:layout];
    self.tileCollectionView.delegate = self;
    
    self.tileCollectionView.backgroundColor = [UIColor clearColor];
    self.tileCollectionView.dataSource = self;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-18, self.tileCollectionView.frame.size.height)];
    [bgView setBackgroundColor:[UIColor colorWithRed:(float)205/255 green:(float)206/255 blue:(float)208/255 alpha:0.36]];
    [pullUpView addSubview:bgView];
    
    
    //    GLogBlendView *imageView = [[GLogBlendView alloc]initWithFrame:self.tileCollectionView.frame];
    //    [pullUpView addSubview:imageView];
    
    [pullUpView addSubview:self.tileCollectionView];
    
    [self.view addSubview:pullUpView];


    
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
    
    
   // self.pickerTableView.scrollEnabled = NO;
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight )];
    [[self pickerTableView] addGestureRecognizer:recognizer];
    
    UISwipeGestureRecognizer *left_recognizer;
    
    left_recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [left_recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft )];
    [[self pickerTableView] addGestureRecognizer:left_recognizer];

    
    
    UIButton *addWorkoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addWorkoutButton setImage:[UIImage imageNamed:@"checkmarkButton"] forState:UIControlStateNormal];
    [addWorkoutButton addTarget:self action:@selector(workoutAddPressed:) forControlEvents:UIControlEventTouchUpInside];
    addWorkoutButton.frame = CGRectMake(0, 0, 37, 37);
    UIBarButtonItem *workoutBarItem = [[UIBarButtonItem alloc]initWithCustomView:addWorkoutButton];

    self.navigationItem.rightBarButtonItem = workoutBarItem;
  
    [self createTrayPullableView];
    UINib *cellNib = [UINib nibWithNibName:@"PickerTileCollectionCell" bundle:nil];
    sizingCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)_tileCollectionView.collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 0;
    [self.tileCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"PickerTileCollectionCell"];

    selectedExerciseArray = [[NSMutableArray alloc]init];
    if(selected_day) {
        for (ExerciseInfo *exercise in selected_day.exercise_r) {
            [selectedExerciseArray addObject:exercise];

        }
        
    }
    
    [_nextButton addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_previousButton addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self fetch];
    _pickerTableView.delegate = self;
    _pickerTableView.dataSource = self;
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark tab button method 
-(void)tabButtonPressed:(UIButton*)sender {

    switch (sender.tag) {
        case 1:
            if(selectedSection>0)
            selectedSection -=1;
            
            else return;
            
            break;
            
        case 2:
            if(selectedSection<[self.fetchedResultsController fetchedObjects].count-1)
                selectedSection +=1;
            
            else return;
            

            break;
    }
    [self prepareExercisesForBodyPart];
    
}

-(void)prepareExercisesForBodyPart {
    selectedPart = [[self.fetchedResultsController fetchedObjects]objectAtIndex:selectedSection];
    NSMutableArray *predicateArray = [NSMutableArray new];
    for (ExerciseInfo *exercise in selectedExerciseArray) {
        [predicateArray addObject:[NSPredicate predicateWithFormat:@"object_id!=%@",exercise.gl_exercise_r.object_id]];
    }
    
    
    
    if(selectedExerciseArray.count)
        exerciseArray = [[selectedPart.gl_exercise_r.allObjects filteredArrayUsingPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicateArray]]mutableCopy];
    else exerciseArray = [[selectedPart.gl_exercise_r allObjects]mutableCopy];
    _bodyPartTitleLabel.text = selectedPart.body_part_name;
    NSSortDescriptor*sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"relation_count" ascending:NO];
    NSArray *array = [selectedPart.gl_exercise_r.allObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
    if(array.count) {
        popularExercise = [array objectAtIndex:0];
    }
    
    [_pickerTableView reloadData];


}
#pragma table methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    GLExerciseInfo *exercise  =[exerciseArray objectAtIndex:indexPath.row];
    
    
    ExerciseInfo *userExercise = [[GLogDataProcessor sharedProcessor]addUserExerciseEntry:exercise workoutDay:selected_day];
    
        [selectedExerciseArray addObject:userExercise];
    [tableView beginUpdates];
    [exerciseArray removeObject:exercise];
    ExercisePickerCell *cell  =(ExercisePickerCell*) [tableView cellForRowAtIndexPath:indexPath];
    if(currentCellView)
        [currentCellView removeFromSuperview];
   currentCellView = [[UIView alloc] initWithFrame:cell.frame];
    
 //   UIImageView *highlightedImageView = [[UIImageView alloc] initWithImage:[GLogUtility rasterizedImage:cell]];
   // highlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   //highlightedImageView.alpha = 1.0f;
    
//    ExercisePickerCell *copy_cell =   [tableView dequeueReusableCellWithIdentifier:@"ExercisePickerCell"];
//;
//    copy_cell.titleLabel.text = exercise.exercise_name;
//    copy_cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//
//    
//    [currentCellView addSubview:copy_cell.contentView];
    
    PickerTileCollectionCell *newCell =(PickerTileCollectionCell*) [GLogUtility loadViewFromNib:@"PickerTileCollectionCell" forClass:[PickerTileCollectionCell class]];
    newCell.title_label.text = exercise.exercise_name;
    newCell.ex_icon.hidden = YES;
    newCell.ex_icon_two.hidden = YES;
    for (ExIconInfo *icon in exercise.icon_r) {
        UIImage *image = [UIImage imageNamed:icon.icon_name];
        if(image) {
            newCell.ex_icon.hidden = NO;
            
            
            newCell.ex_icon.image = image;
            CGRect frame = newCell.ex_icon.frame;
            frame.size.height = image.size.height;
            frame.size.width = image.size.width;
            
            
            newCell.ex_icon.frame = frame;
        }
    }
    
    
    newCell.ex_icon.center = cell.contentView.center;
    CGPoint center = newCell.ex_icon.center;
    
    center.y -=25;
    newCell.ex_icon.center = center;

    
    
    [currentCellView addSubview:newCell];

    [self.view addSubview:currentCellView];
    
    CGRect frame = currentCellView.frame;
    frame.size.width = sizingCell.frame.size.width;
    frame.size.height = sizingCell.frame.size.height;
    NSInteger previousIndex = selectedExerciseArray.count-2 ;
    
    PickerTileCollectionCell *tile_cell = (PickerTileCollectionCell*)[_tileCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:previousIndex inSection:0]];
    CGRect cellFrame;
    if(tile_cell){
        cellFrame = CGRectMake(tile_cell.frame.origin.x+_tileCollectionView.frame.origin.x, pullUpView.frame.origin.y+30+tile_cell.frame.origin.y, tile_cell.frame.size.width, tile_cell.frame.size.height);

        switch (((previousIndex+1)%3)) {
            case 1:
                 case 2:
                cellFrame.origin.x+=cellFrame.size.width;

                break;
                
                
                break;
                
            case 0:
                cellFrame.origin.x=_tileCollectionView.frame.origin.x;
                cellFrame.origin.y+=cellFrame.size.height;
                
            break;                   }
        
    }
    
    else  {
        if(previousIndex>0)
        [_tileCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:previousIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        CGRect collectionFrame =[_tileCollectionView convertRect:_tileCollectionView.frame toView:self.view];
        
        cellFrame = CGRectMake(10, collectionFrame.origin.y-30, sizingCell.frame.size.width, sizingCell.frame.size.height);
        
    }
    float exponentialValue = pow((abs(currentCellView.frame.origin.x-cellFrame.origin.x)), 2)  -pow((abs(currentCellView.frame.origin.y-cellFrame.origin.y)), 2);

    float duration  =sqrt(abs(exponentialValue))/kAnimationSpeed;

    float speed =sqrt(abs(exponentialValue));
    
    duration=  floorf(duration * 1000) / 1000;
    NSLog(@"distance %f",sqrt(abs(exponentialValue)));
//    if(duration<=0)
//        duration = 0.5;
[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    currentCellView.frame = cellFrame;

} completion:^(BOOL finished) {
    if(finished)
        [currentCellView removeFromSuperview];
    
}];

    [_tileCollectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:selectedExerciseArray.count-1 inSection:0]]];

    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    
    [tableView endUpdates];
    

  //  }
    
    
}

- (NSTimeInterval)animationDurationWithVelocity:(CGPoint)velocity {
    
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    NSTimeInterval animationDurationDiff =  - 0.25;
    CGFloat horizontalVelocity = (velocity.x);
    
    if (horizontalVelocity < -width) horizontalVelocity = -width;
    else if (horizontalVelocity > width) horizontalVelocity = width;
    
    return (0.1 + 0.25) - fabs(((horizontalVelocity / width) * animationDurationDiff));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return exerciseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExercisePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExercisePickerCell"];
    GLExerciseInfo *exercise = [exerciseArray objectAtIndex:indexPath.row];
    
    if([popularExercise.object_id isEqualToString:exercise.object_id])
        cell.popularImageView.hidden= NO;
    else cell.popularImageView.hidden= YES;
    
    switch ([exercise.equipment_type integerValue]) {
        case 1:
            cell.typeIconView.backgroundColor = kBarbellIconColor;
            cell.iconTypeLabel.text = @"B";
            break;
        case 2:
            cell.typeIconView.backgroundColor = kBarbellIconColor;
            cell.iconTypeLabel.text = @"B";

            break;
            
        case 3:
            cell.typeIconView.backgroundColor= kPlateStackIconColor;
            cell.iconTypeLabel.text = @"P";

            break;
        case 4:
            cell.typeIconView.backgroundColor= kDumbbellWeightIconColor ;
            cell.iconTypeLabel.text = @"D";


            break;
        case 5:
            cell.typeIconView.backgroundColor= kBodyWeightIconColor ;
            cell.iconTypeLabel.text = @"BW";
            
            
            break;
        default:
            break;
    }
    
    cell.titleLabel.text = exercise.exercise_name;
    return cell;
}

#pragma collection view methods 

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    ExerciseInfo *exercise = [selectedExerciseArray objectAtIndex:indexPath.row];

    if([exercise.gl_exercise_r.body_part_r.body_part_name isEqualToString:[selectedPart body_part_name]]) {
    
        
        
        PickerTileCollectionCell *collectionCell = (PickerTileCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
        ExercisePickerCell *tableCell = (ExercisePickerCell*)[_pickerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:exerciseArray.count-1 inSection:0]];

    
        if(currentCellView)
            [currentCellView removeFromSuperview];
        
        CGRect initialFrame = CGRectMake(collectionCell.frame.origin.x+collectionView.frame.origin.x, collectionCell.frame.origin.y+collectionView.frame.origin.y+pullUpView.frame.origin.y+40, collectionCell.frame.size.width, collectionCell.frame.size.height);
        currentCellView = [[UIView alloc] initWithFrame:initialFrame];
        
        UIImageView *highlightedImageView = [[UIImageView alloc] initWithImage:[GLogUtility rasterizedImage:collectionCell]];
        highlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        highlightedImageView.alpha = 1.0f;
        [currentCellView addSubview:highlightedImageView];
        [self.view addSubview:currentCellView];
        

        
        CGRect finalFrame;
        if(!tableCell)
        {
        finalFrame= CGRectMake(_pickerTableView.frame.origin.x, _pickerTableView.frame.origin.y+_pickerTableView.tableHeaderView.frame.size.height, _pickerTableView.frame.size.width, 36);
        }
        else finalFrame= CGRectMake(tableCell.frame.origin.x, tableCell.frame.origin.y+_pickerTableView.frame.origin.y+tableCell.frame.size.height, tableCell.frame.size.width, tableCell.frame.size.height);
        
        
        [UIView animateWithDuration:0.25 animations:^{
            currentCellView.frame = finalFrame;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                currentCellView.alpha=0;
            } completion:^(BOOL finished) {
                [currentCellView removeFromSuperview];
            }];

        }];


      
        
        
        [exerciseArray addObject:exercise.gl_exercise_r];
        
        
        
        [selectedExerciseArray removeObject:exercise];
        [exercise.managedObjectContext deleteObject:exercise];
        [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        [_pickerTableView beginUpdates];

        
    [_pickerTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:exerciseArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [_pickerTableView endUpdates];
    }
    
}
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
    return selectedExerciseArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(100, 80);
}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    ExerciseInfo *exercise = [selectedExerciseArray objectAtIndex:indexPath.row];
//    
//    sizingCell.title_label.text = [exercise exercise_name];
//  //  CGSize cellRect = [exercise.exercise_name sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(collectionView.bounds.size.width, 50)];
//    
//    return [sizingCell intrinsicContentSize];
//    
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PickerTileCollectionCell";
    
    PickerTileCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    ExerciseInfo *exercise = [selectedExerciseArray objectAtIndex:indexPath.row];
    cell.ex_icon.hidden = YES;
    cell.ex_icon_two.hidden = YES;
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
    
    center.y -=25;
    cell.ex_icon.center = center;
    

    cell.title_label.text = exercise.exercise_name;
    return cell;
}

-(void)workoutAddPressed:(UIButton*)sender {

    NSMutableArray *deleteArray = [NSMutableArray new];
    for (ExerciseInfo *exercise in selected_day.exercise_r) {
        if(exercise.exercise_id.length)
        [deleteArray addObject:[PFObject objectWithoutDataWithClassName:kUserExerciseInfo objectId:exercise.exercise_id]];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:kUserDayInfo];
    
    [query whereKey:@"objectId" equalTo:selected_day.object_id];
    [query includeKey:@"exercise_ar"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count) {
        
            PFObject *dayObject = [objects lastObject];
            NSLog(@"%@",[dayObject objectForKey:@"exercise_ar"]);
            if(![[dayObject objectForKey:@"exercise_ar"] isEqual:[NSNull null]] &&[dayObject objectForKey:@"exercise_ar"])
            [dayObject removeObjectsInArray:[dayObject objectForKey:@"exercise_ar"] forKey:@"exercise_ar"];
            [dayObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [PFObject deleteAllInBackground:deleteArray];
                
                selected_day.exercise_r = nil;
                
                if(!isOriginalWorkout) {
                    [selected_day.managedObjectContext save:nil];
                    
                    PFQuery *dayQuery = [PFQuery queryWithClassName:kUserDayInfo];
                    
                    
                    [dayQuery whereKey:@"objectId" equalTo:selected_day.object_id];
                    dayQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
                    
                    [dayQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if(!error &&objects.count) {
                            
                            
                            PFObject *dayObject = [objects lastObject];
                            
                            [[GLogNetworkEngine sharedEngine]addNewExercisesForDay:dayObject exerciseList:selectedExerciseArray completionBlock:^(id object) {
                                NSArray *objectArray = object;
                                for (int i =0; i<[objectArray count]; i++) {
                                    PFObject *object = [objectArray objectAtIndex:i];
                                    ExerciseInfo *exercise = [selectedExerciseArray objectAtIndex:i];
                                    exercise.exercise_id = object.objectId;
                                    exercise.day_r = selected_day;
                                }
                                
                                [[kAppDelegate managedObjectContext]save:nil];
                                
                            } errorBlock:^(NSError *error) {
                                for (ExerciseInfo *exercise in selectedExerciseArray) {
                                    [[kAppDelegate managedObjectContext]deleteObject:exercise];
                                }
                                [[kAppDelegate managedObjectContext]save:nil];
                                
                            }];
                        }
                    }];
                    //
                    // NSDictionary *exerciseDict = [NSDictionary alloc]initWithObjectsAndKeys:ex, nil
                    
                }
                
            }];
        }
        
    }];
    
    
    

   
   
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath {

    [selectedExerciseArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];

}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer*)sender {
    
    //  NSInteger index = [selected_day.gl_exercise_r indexOfObject:selectedExercise];
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
        {
            //    index-=1;
            [self tabButtonPressed:_nextButton];
            
        }
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
        {
            [self tabButtonPressed:_previousButton];
            
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

@end
