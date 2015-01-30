//
//  GLogLoginViewController.m
//  GymLog
//
//  Created by Sunny on 15/01/14.
//  Copyright (c) 2014 Apptree Studio LLC. All rights reserved.
//

#import "GLogLoginViewController.h"
#import "FXBlurView.h"

@interface GLogLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
- (IBAction)loginBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLogoLabel;
@property (weak, nonatomic) IBOutlet FXBlurView *blurView;
- (IBAction)backButtonPressed:(id)sender;

@end

@implementation GLogLoginViewController

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
 //   self.blurView.tintColor = [UIColor colorWithRed:(float)30/255 green:(float)30/255 blue:(float)30/255 alpha:1];
   // self.blurView.blurRadius = 10.0f;
    [GLogUtility addPaddingToTextField:_usernameTextField];
    [GLogUtility addPaddingToTextField:_passwordTextField];

    self.navigationController.navigationBarHidden = YES;
    self.titleLogoLabel.font = kBellotaFont(32);
    self.title = @"Existing User";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark textfield delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)loginBtnPressed:(id)sender {
    if(!_usernameTextField.text.length) {
        [GLogUtility showAlertWithString:kEnterUserNameAlert];
        return;
        
    }
    
    if(!_passwordTextField.text.length) {
        [GLogUtility showAlertWithString:kEnterPasswordAlert];
        return;
        
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    

    
    [PFUser logInWithUsernameInBackground:_usernameTextField.text password:_passwordTextField.text block:^(PFUser *user, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if(!error) {
            [kAppDelegate initializeSideMenuController];
           // [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
        
        else {
            NSString *errorString = [error userInfo][@"error"];
            [GLogUtility showAlertWithString:errorString];

        }
    }];
    
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
