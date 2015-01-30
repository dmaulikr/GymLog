//
//  GLogSignupViewController.m
//  GymLog
//
//  Created by Sunny on 15/01/14.
//  Copyright (c) 2014 Apptree Studio LLC. All rights reserved.
//

#import "GLogSignupViewController.h"
#import "SignupProfileCell.h"
#import "SignupUnitCell.h"
#import "FXBlurView.h"
#import "DoImagePickerController.h"
#import "UIView+Toast.h"
#import "AssetHelper.h"
@interface GLogSignupViewController ()<UITableViewDataSource,UITableViewDelegate,SignupProfileDelegate,UITextFieldDelegate> {

    NSString *userName ;
    NSString *fullName ;
    NSString *emailString;
    NSString *confirmPasswordString;
    __weak IBOutlet FXBlurView *blurBoxView;
    NSNumber *weightValue;
    NSNumber *bodyFatValue;
    NSString *unitString;
    NSString *passwordString;
    UIImage *avatarImage;
    PFQuery *textFieldQuery;
    __weak IBOutlet UIImageView *confirmCheckImgView;
    __weak IBOutlet UIImageView *emailCheckImgView;
    __weak IBOutlet UIImageView *userNameCheckView;
    __weak IBOutlet UITextField *confirmPasswordTextField;
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UITextField *usernameTextField;
    __weak IBOutlet UIButton *placeholderBtn;
    __weak IBOutlet UILabel *titleLabel;
    
}
- (IBAction)placeholderBtnPressed:(UIButton *)sender;
- (IBAction)backButtonPressed:(id)sender ;
@property (weak, nonatomic) IBOutlet UITableView *signupTableView;
- (IBAction)signupBtnPressed:(id)sender;

@end

@implementation GLogSignupViewController

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
    blurBoxView.tintColor = [UIColor darkGrayColor];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTapped:)];
    [self.view addGestureRecognizer:tapRecognizer];
    titleLabel.font = kBellotaFont(32);
    [GLogUtility addPaddingToTextField:usernameTextField];
    [GLogUtility addPaddingToTextField:emailTextField];
    [GLogUtility addPaddingToTextField:passwordTextField];
    [GLogUtility addPaddingToTextField:confirmPasswordTextField];
   // self.navigationController.navigationBarHidden = NO;
    userName = @"";
    fullName = @"";
    passwordString = @"";
    unitString = @"";
    self.title = @"New Profile";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 2;

            break;
        case 2:
            return 2;

            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"USER PROFILE";

            break;
            
        case 1:
            return @"PREFERRED SETTINGS";
            
            break;

        case 2:
            return @"DEFAULT INPUT METHOD";
            
            break;

            
        default:
            return @"";
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            SignupProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignupProfileCell"];
            cell.cellTextField.secureTextEntry = NO;
            cell.delegate = self;
            switch (indexPath.row) {
                case 0:
                    cell.nameLabel.text = @"Name";
                    break;
                    
                case 1:
                    cell.nameLabel.text = @"Username";
                    break;

                    case 2:
                    cell.nameLabel.text = @"Password";
                    cell.cellTextField.secureTextEntry = YES;
                    break;

                    case 3:
                    cell.nameLabel.text = @"Weight";
                    break;
                    
                default:
                    cell.nameLabel.text = @"Body Fat (%)";

                    break;
            }
            return cell;
        }
            break;
            
        case 1:
        {
            SignupUnitCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SignupUnitCell"];
            return cell;
        }
            break;
            
        default: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckMarkCell"];
            UILabel *label =(UILabel*)[cell.contentView viewWithTag:100];
            switch (indexPath.row) {
                case 0:
                    label.text = @"Barbell";
                    break;
                    
                default:
                    label.text = @"Plate Stack";
                    break;
            }
            return cell;

        }
            break;
            
    }

}

- (IBAction)signupBtnPressed:(id)sender {
    
    
    
    
//        if(!fullName.length)
//    {
//        [GLogUtility showAlertWithString:kEnterNameAlert];
//        return;
//    }

       if(!userName.length)
    {
        [GLogUtility showNZAlertWithString:kEnterUserNameAlert andType:NZAlertStyleError];

   //     [self.view makeToast:kEnterUserNameAlert duration:2.0 position:@"top" title:nil];
       // [GLogUtility showAlertWithString:kEnterUserNameAlert];
        return;
    }
    
    if(userName.length<kMinimumUsernameLength) {
        [GLogUtility showNZAlertWithString:@"Username should be atleast 6 characters" andType:NZAlertStyleError];
        return;
    }
    
    
    
    
    if(!passwordString.length)
    {
        [GLogUtility showAlertWithString:kEnterPasswordAlert];
        return;
    }

    if(![passwordTextField.text isEqualToString:confirmPasswordTextField.text]) {
    
        [GLogUtility showAlertWithString:kConfirmPasswordAlert];
        return;

        
    }
    
    if(![GLogUtility NSStringIsValidEmail:emailTextField.text]) {
        [GLogUtility showAlertWithString:kEnterEmailAlert];
        return;
    }
//    
//    if([weightValue floatValue]<=0)
//    {
//        [GLogUtility showAlertWithString:kEnterWeightAlert];
//        return;
//    }
//    
    
//    SignupUnitCell *unitCell =(SignupUnitCell*)[_signupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//    
//    if(unitCell.unitSwitch.isOn)
//        unitString = @"kg";
//    
//    else unitString = @"lbs";
    
    PFUser *user = [PFUser user];
    user.username = userName;
    user.password = passwordString;
    user.email = emailString;
  //  user.email = @"email@example.com";
//    user[@"bodyWeight"] = weightValue;
//    user[@"bodyFat"] = bodyFatValue;
//    user[@"measureUnit"] = unitString;

    // other fields can be set if you want to save more information
   // user[@"phone"] = @"650-555-0000";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
   
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (!error) {
            
            if(avatarImage) {
            PFFile *imageFile = [PFFile fileWithData:UIImagePNGRepresentation(avatarImage)];
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded) {
                    [PFUser logInWithUsernameInBackground:user.username password:user.password block:^(PFUser *user, NSError *error) {
                        if(!error) {
                            [[PFUser currentUser]setObject:imageFile forKey:@"avatar_image"];
                            [[PFUser currentUser]saveInBackground];
                            
                            [kAppDelegate initializeSideMenuController];
                            //   [self performSegueWithIdentifier:@"signinSegue" sender:self];
                        }
                        
                        else {
                            NSString *errorString = [error userInfo][@"error"];
                            [GLogUtility showAlertWithString:errorString];
                        }
                    }];

                    
                }
                
            }];
            }
            
            else {
            
                [PFUser logInWithUsernameInBackground:user.username password:user.password block:^(PFUser *user, NSError *error) {
                    if(!error) {
                        [kAppDelegate initializeSideMenuController];
                     //   [self performSegueWithIdentifier:@"signinSegue" sender:self];
                    }
                    
                    else {
                        NSString *errorString = [error userInfo][@"error"];
                        [GLogUtility showAlertWithString:errorString];
                    }
                }];
            }
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            [GLogUtility showAlertWithString:errorString];
        }
    }];
    
}
-(void)didEnterTextForCell:(SignupProfileCell*)cell {

    NSIndexPath *indexPath = [_signupTableView indexPathForCell:cell];
    
    switch (indexPath.row) {
        case 0:
        {
            fullName = cell.cellTextField.text;
        }
            break;
            
        case 1:
        {
            userName = cell.cellTextField.text;

        }
            break;

        case 2:
        {
            passwordString = cell.cellTextField.text;

        }
            break;
        case 3:
        {
            weightValue = [NSNumber numberWithFloat:[cell.cellTextField.text floatValue]];

        }
            break;
            

        default: {
            bodyFatValue =[NSNumber numberWithFloat:[cell.cellTextField.text floatValue]];

        }
            break;
    }
    
}

- (IBAction)placeholderBtnPressed:(UIButton *)sender {
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nMaxCount = 1;
    cont.nResultType = DO_PICKER_RESULT_ASSET;
    cont.nColumnCount = 2;

    [self presentViewController:cont animated:YES completion:nil];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark doimage delegates
-(void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.nResultType == DO_PICKER_RESULT_ASSET)
    {
        UIImage *result = [ASSETHELPER getImageFromAsset:[aSelected lastObject] type:ASSET_PHOTO_SCREEN_SIZE];
        
        UIImage *circularImage = [GLogUtility getRoundedRectImageFromImage:result onReferenceView:placeholderBtn withCornerRadius:placeholderBtn.frame.size.width/2];
        avatarImage= result;
        [placeholderBtn setBackgroundImage:circularImage forState:UIControlStateNormal];
    }
}

#pragma mark textfield delegates
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    
//    if(textField==passwordTextField) {
//    
//        CGRect frame = blurBoxView.frame;
//        frame.origin.y -=50;
//        [UIView animateWithDuration:0.25 animations:^{
//            blurBoxView.frame = frame;
//        }];
//    }
//    
//    else if(textField==confirmPasswordTextField) {
//        CGRect frame = blurBoxView.frame;
//        frame.origin.y -=80;
//        [UIView animateWithDuration:0.25 animations:^{
//            blurBoxView.frame = frame;
//        }];
//
//    }
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if(textField==passwordTextField) {
//        
//        CGRect frame = blurBoxView.frame;
//        frame.origin.y +=50;
//        [UIView animateWithDuration:0.25 animations:^{
//            blurBoxView.frame = frame;
//        }];
//    }
//    else if(textField==confirmPasswordTextField) {
//        CGRect frame = blurBoxView.frame;
//        frame.origin.y +=80;
//        [UIView animateWithDuration:0.25 animations:^{
//            blurBoxView.frame = frame;
//        }];
//        
//    }
//
//}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField==usernameTextField)
        userName = usernameTextField.text;
    
    else if(textField==emailTextField)
        emailString = emailTextField.text;
    
    else if(textField==passwordTextField)
        passwordString = passwordTextField.text;
    
    else if(textField==confirmPasswordTextField) {
        confirmPasswordString = confirmPasswordTextField.text;
          }
  //    if(textField==usernameTextField &&textField.text.length<kMinimumUsernameLength){
//    [self.view makeToast:@"Username needs to atleast more than 6 characters"
//                duration:2.0
//                position:@"top"
//                   title:nil];
//    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(textField==usernameTextField) {
        if(currentString.length>=kMinimumUsernameLength) {
         textFieldQuery = [PFQuery queryWithClassName:@"_User"];
        [textFieldQuery whereKey:@"username" equalTo:currentString];
        [textFieldQuery cancel];
        [textFieldQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            userNameCheckView.hidden = NO;
            if(objects.count) {
                userNameCheckView.image = [UIImage imageNamed:@"signup_cross_button"];
            }
            else userNameCheckView.image = [UIImage imageNamed:@"signup_check_button"];

        }];
            
            
        }
        else userNameCheckView.hidden = YES;
    }
    
    else if(textField==confirmPasswordTextField){
        confirmCheckImgView.hidden = NO;
        if(![currentString isEqualToString:passwordTextField.text])
            confirmCheckImgView.image = [UIImage imageNamed:@"signup_cross_button"];
        
        else confirmCheckImgView.image = [UIImage imageNamed:@"signup_check_button"];

    }
    
   

    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


-(void)screenTapped:(UITapGestureRecognizer*)sender {
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [confirmPasswordTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
}
@end
