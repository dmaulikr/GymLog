//
//  GLogDialerView.m
//  GymLog
//
//  Created by Amendeep Singh on 27/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogDialerView.h"

@implementation GLogDialerView
-(void)awakeFromNib {

    _weightTextField.enabled = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    return YES;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)dialerBtnPressed:(UIButton *)sender {
    
    
    NSMutableString *textFieldString = [[_weightTextField text]mutableCopy];
    [textFieldString replaceOccurrencesOfString:[NSString stringWithFormat:@" %@",kDefaultWeightMetric]  withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [textFieldString length])];
    
    
    if([textFieldString integerValue]==0)
        textFieldString = [NSMutableString new];
    
    
    
    
    [textFieldString appendString:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
   self.totalWeightValue = [textFieldString floatValue];
    if(self.delegate &&[self.delegate respondsToSelector:@selector(didSelectWeightWithValue:)])
        [self.delegate didSelectWeightWithValue:self.totalWeightValue];
    [textFieldString appendString:[NSString stringWithFormat:@" %@",kDefaultWeightMetric]];

    _weightTextField.text = textFieldString;
}

- (IBAction)clearBtnPressed:(UIButton *)sender {
    NSMutableString *textFieldString = [[_weightTextField text]mutableCopy];
    [textFieldString replaceOccurrencesOfString:[NSString stringWithFormat:@" %@",kDefaultWeightMetric]  withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [textFieldString length])];
    
    
    [textFieldString replaceCharactersInRange:NSMakeRange([textFieldString length]-1, 1) withString:@""];
    if(!textFieldString.length)
      [textFieldString appendString:@"0"];
    
   self.totalWeightValue = [textFieldString floatValue];
    if(self.delegate &&[self.delegate respondsToSelector:@selector(didSelectWeightWithValue:)])
        [self.delegate didSelectWeightWithValue:self.totalWeightValue];

    [textFieldString appendString:[NSString stringWithFormat:@" %@",kDefaultWeightMetric]];
    _weightTextField.text = textFieldString;

}

-(void)updateCurrentWeightValue:(CGFloat)weightValue  {
    self.totalWeightValue =weightValue;
    self.weightTextField.text = [NSString stringWithFormat:@"%.0f %@",self.totalWeightValue,kDefaultWeightMetric];
    [selectedWeightArray removeAllObjects];
}

@end
