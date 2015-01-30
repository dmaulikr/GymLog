//
//  GLogIntroViewController.m
//  GymLog
//
//  Created by Sunny on 15/01/14.
//  Copyright (c) 2014 Apptree Studio LLC. All rights reserved.
//

#import "GLogIntroViewController.h"

@interface GLogIntroViewController ()
- (IBAction)loginBtnPressed:(id)sender;
- (IBAction)signupBtnPressed:(id)sender;

@end

@implementation GLogIntroViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

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

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnPressed:(id)sender {


}

- (IBAction)signupBtnPressed:(id)sender {
}
@end
