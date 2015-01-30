//
//  SignupProfileCell.m
//  GymLog
//
//  Created by Sunny on 15/01/14.
//  Copyright (c) 2014 Apptree Studio LLC. All rights reserved.
//

#import "SignupProfileCell.h"

@implementation SignupProfileCell
@synthesize delegate;
-(void)awakeFromNib {

    self.cellTextField.delegate = self;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark textfield delegates
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([self.delegate respondsToSelector:@selector(didEnterTextForCell:)])
        [self.delegate didEnterTextForCell:self];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
