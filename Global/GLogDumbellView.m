//
//  GLogDumbellView.m
//  GymLog
//
//  Created by Sunny on 13/12/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogDumbellView.h"

@implementation GLogDumbellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib {
    weightsArray = [NSMutableArray new];
    selectedWeightArray = [NSMutableArray new];
    for (int count =5; count<50; count+=5) {
        NSString *string = [NSString stringWithFormat:@"%d",count];
        [weightsArray addObject:string];
    }
    [self generateBarbellWeightsInScroll];
    
    for (UIButton *btn in self.weightScrollView.subviews) {
        if([btn isKindOfClass:[UIButton class]]) {
            [btn addTarget:self action:@selector(weightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}

-(void)weightButtonPressed:(UIButton*)sender {
    
    NSString *value = [weightsArray objectAtIndex:sender.tag];
    self.totalWeightValue =  [value floatValue];
    [selectedWeightArray addObject:value];
    [selectedWeightArray addObject:value];
    self.totalWeightLabel.text = [NSString stringWithFormat:@"%.2f %@",self.totalWeightValue,kDefaultWeightMetric];
    
    NSMutableString *distributedString = [[selectedWeightArray componentsJoinedByString:@" + "]mutableCopy];
    
    [distributedString appendFormat:@" %@",kDefaultWeightMetric];
    if(self.totalWeightValue>0)
        self.distributedLabel.text = distributedString;
    
    if(self.delegate &&[self.delegate respondsToSelector:@selector(didSelectWeightWithValue:)])
        [self.delegate didSelectWeightWithValue:self.totalWeightValue];

}

-(void)updateCurrentWeightValue:(CGFloat)weightValue  {
    
    self.totalWeightValue =weightValue;
    self.totalWeightLabel.text = [NSString stringWithFormat:@"%.2f %@",self.totalWeightValue,kDefaultWeightMetric];
    [selectedWeightArray removeAllObjects];
    self.distributedLabel.text = @"";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
