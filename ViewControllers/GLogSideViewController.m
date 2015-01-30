//
//  GLogSideViewController.m
//  GymLog
//
//  Created by Amendeep Singh on 06/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogSideViewController.h"
#import "FXBlurView.h"
#import "SideMenuCell.h"
@interface GLogSideViewController (){
    NSMutableArray *titleArray;
}
@property (weak, nonatomic) IBOutlet FXBlurView *blurView;
@property (weak, nonatomic) IBOutlet UITableView *sideTableView;

@end

@implementation GLogSideViewController

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
    
    titleArray = [[NSMutableArray alloc]initWithObjects:@"Workout Manager",@"Exercise Manager",@"Performance Metrics",@"Community",@"Settings", nil];
//    FXBlurView *blurView =(FXBlurView*)self.view;
    _blurView.tintColor = [UIColor clearColor];
//    blurView.blurRadius =40;
//    blurView.dynamic  = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SideMenuCell"];
    
    if(!cell) {
        cell = (SideMenuCell*)[GLogUtility loadViewFromNib:@"SideMenuCell" forClass:[SideMenuCell class]];
    }
    
    cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
