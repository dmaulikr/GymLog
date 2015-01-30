//
//  SignupProfileCell.h
//  GymLog
//
//  Created by Sunny on 15/01/14.
//  Copyright (c) 2014 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SignupProfileCell;
@protocol SignupProfileDelegate<NSObject>
-(void)didEnterTextForCell:(SignupProfileCell*)cell;
@end
@interface SignupProfileCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *cellTextField;


@property(unsafe_unretained) id<SignupProfileDelegate> delegate;
@end
