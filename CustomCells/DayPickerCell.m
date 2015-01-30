//
//  DayPickerCell.m
//  GymLog
//
//  Created by Amendeep Singh on 10/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "DayPickerCell.h"

@implementation DayPickerCell
@synthesize delegate;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    if([self.delegate respondsToSelector:@selector(didRenameDayForCell:)])
        [self.delegate didRenameDayForCell:self];
    return YES;
}

@end
