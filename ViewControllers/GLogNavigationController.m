//
//  GLogNavigationController.m
//  GymLog
//
//  Created by Amendeep Singh on 29/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogNavigationController.h"
#import "GLogSideViewController.h"
#import "InWorkoutCell.h"
#import "FXBlurView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface GLogNavigationController ()<UIGestureRecognizerDelegate>
{
    UIBarButtonItem *backButtonItem;
    UIBarButtonItem *menuButtonItem;
    UIButton *backButton;
    GLogSideViewController *sideMenuVC;
    CGPoint lastPanPoint;
    UIButton *menuButton;

}
@end

@implementation GLogNavigationController

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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    
    self.navigationBar.barTintColor = kNavBarColor;
    
  //  [self.navigationBar.layer insertSublayer:colourView.layer atIndex:1];
    
//[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg_new_4"] forBarMetrics:UIBarMetricsDefault];
  //  [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(float)52/255 green:(float)73/255 blue:(float)94/255 alpha:1]];
    //[UIColor colorWithRed:(float)7/255 green:(float)39/255 blue:(float)91/255 alpha:1]
     //[UIColor colorWithRed:(float)17/255 green:(float)209/255 blue:(float)154/255 alpha:1]];

    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"STHeitiSC-Light" size:21.0], NSFontAttributeName,nil]];
    self.delegate = self;
  // self.navigationBar.translucent = NO;

 //   CGRect frame = CGRectMake(0.0f, 0.0f, 320.0f, 100);
  //  [self.navigationBar setFrame:frame];
   // [self.navigationBar.layer setBorderWidth:1.0];
    //[self.navigationBar.layer setBorderColor:kBorderColor.CGColor];
    
//    sideMenuVC = [[GLogSideViewController alloc]initWithNibName:@"GLogSideViewController" bundle:nil];
//    
//     frame = sideMenuVC.view.frame;
//    frame.origin.x = -frame.size.width;
//    sideMenuVC.view.frame = frame;
//    [self.view addSubview:sideMenuVC.view];
    
   // UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPanDrag:)];
    //panGesture.delegate = self;
    //[self.view addGestureRecognizer:panGesture];

    
    // self.navigationBarHidden = YES;
   // [GLogUtility insertTestData];

    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"login_back_button"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    backButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    menuButton.frame = CGRectMake(0, 0, 30, 30);
    
    [menuButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    menuButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuButton];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark back button pressed
-(void)backButtonPressed:(UIButton*)sender {

  [self popViewControllerAnimated:YES];
}

#pragma mark menu button pressed 
-(void)menuButtonPressed:(UIButton*)sender {
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];

}

- (void)navigationController:(UINavigationController *)navigationController  willShowViewController:(UIViewController *)viewController  animated:(BOOL)animated {
    
    if(navigationController.viewControllers.count!=1)
    {
        viewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backButtonItem,menuButtonItem, nil];
    }
    
    else {
[viewController.navigationItem setHidesBackButton:YES animated:NO];
    viewController.navigationItem.leftBarButtonItem = menuButtonItem;
    }
    
}

-(void)onPanDrag:(UIPanGestureRecognizer*)sender {
    
    
    CGPoint pt = [sender locationInView:self.view];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGRect frame = sideMenuVC.view.frame;
            // NSLog(@"%@",NSStringFromCGRect(frame));
            
            
            
            frame.origin.x += pt.x -lastPanPoint.x;
            
            NSLog(@"%f",frame.origin.x+frame.size.width);
            
            if(frame.origin.x>=0)
                break;
            [UIView animateWithDuration:0.25 animations:^{

            sideMenuVC.view.frame = frame;
            }];
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            CGRect frame = sideMenuVC.view.frame;

            if(frame.origin.x+frame.size.width>frame.size.width/2) {
                [kAppDelegate setIs_menu_open:YES];
                frame.origin.x = 0;
            }
            else { frame.origin.x = -frame.size.width;
                [kAppDelegate setIs_menu_open:NO];

            }
            [UIView animateWithDuration:0.25 animations:^{
                sideMenuVC.view.frame = frame;

 
            }];
            
        }
            break;
        default:
            break;
    }
    
    lastPanPoint = pt;

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint pt = [gestureRecognizer locationInView:self.view];

    
    if(pt.x>30 &&![kAppDelegate is_menu_open])
        return NO;
    
    return YES;

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]])
    {
        return NO;
    }
    
   
    return YES;
}

@end
