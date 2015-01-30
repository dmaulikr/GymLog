//
//  GLogBarbellView.m
//  GymLog
//
//  Created by Amendeep Singh on 02/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogBarbellView.h"
#define weightButtonSize CGSizeMake(62,62)
@interface GLogBarbellView()
{
    BOOL hasAddedRod;
}
@end
@implementation GLogBarbellView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

-(void)awakeFromNib {
    weightsArray = [[NSMutableArray alloc]initWithObjects:@"45",@"35",@"25",@"10",@"5",@"2.5", nil];

    [self generateBarbellWeightsInScroll];
    selectedWeightArray = [NSMutableArray new];

}

-(void)generateBarbellWeightsInScroll {

    CGFloat yOffset = 0;
    CGFloat xOffset =0;
    self.totalWeightValue =0;
    self.totalWeightLabel.text =[NSString stringWithFormat:@"%.2f %@",self.totalWeightValue,kDefaultWeightMetric];
    for (int count =0; count<weightsArray.count; count++) {
        
        NSString *weightValue = [weightsArray objectAtIndex:count];
        UIButton *weightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressButton:)];
        [weightButton addGestureRecognizer:longPress];
        [weightButton setBackgroundImage:[UIImage imageNamed:@"barbell_button"] forState:UIControlStateNormal];
        [weightButton setTag:count];
        [weightButton addTarget:self action:@selector(weightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [weightButton setTitle:weightValue forState:UIControlStateNormal];
        weightButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
        [weightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [weightButton setTitleEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
        if(count!=0) {
        switch ((count)%2) {
            case 0:
                xOffset = 0;
                yOffset +=weightButtonSize.height;
                break;
                
          case 1:
                xOffset = weightButtonSize.width;
                break;

        }
        }
        [weightButton setFrame:CGRectMake(xOffset,yOffset , weightButtonSize.width, weightButtonSize.height)];

        UILabel *metricLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, weightButtonSize.height-25, weightButtonSize.width, 20)];
        metricLabel.textAlignment = NSTextAlignmentCenter;
        metricLabel.backgroundColor = [UIColor clearColor];
        metricLabel.textColor = [UIColor whiteColor];
        metricLabel.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        metricLabel.text = kDefaultWeightMetric;
        [weightButton addSubview:metricLabel];
        
        [_weightScrollView addSubview:weightButton];
    }
    
    CGSize scrollSize = CGSizeMake(_weightScrollView.contentSize.width, yOffset+weightButtonSize.height);
    _weightScrollView.contentSize = scrollSize;
  }
-(void)updateCurrentWeightValue:(CGFloat)weightValue  {

    self.totalWeightValue =weightValue;
    self.totalWeightLabel.text = [NSString stringWithFormat:@"%.2f %@",self.totalWeightValue,kDefaultWeightMetric];
    [selectedWeightArray removeAllObjects];
    _distributedLabel.text = @"";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void)weightButtonPressed:(UIButton*)sender {

    NSString *value = [weightsArray objectAtIndex:sender.tag];
    if (!hasAddedRod) {
        self.totalWeightValue = 45 + 2*[value floatValue];
        hasAddedRod = YES;
        [selectedWeightArray addObject:@"45"];

        [selectedWeightArray addObject:value];
        [selectedWeightArray addObject:value];


    }
    
    else {
        
        self.totalWeightValue +=  2*[value floatValue];
        [selectedWeightArray addObject:value];
        [selectedWeightArray addObject:value];


    }
    self.totalWeightLabel.text = [NSString stringWithFormat:@"%.2f %@",self.totalWeightValue,kDefaultWeightMetric];
    
      NSMutableString *distributedString = [[selectedWeightArray componentsJoinedByString:@" + "]mutableCopy];
    
    [distributedString appendFormat:@" %@",kDefaultWeightMetric];
    if(self.totalWeightValue>0)
    _distributedLabel.text = distributedString;
    if(self.delegate &&[self.delegate respondsToSelector:@selector(didSelectWeightWithValue:)])
        [self.delegate didSelectWeightWithValue:self.totalWeightValue];
}

-(void)longPressButton:(UILongPressGestureRecognizer*)sender {

    if ( sender.state == UIGestureRecognizerStateEnded ) {
        NSLog(@"Long Press");
    
    UIButton *weightBtn = (UIButton*)sender.view;
    NSString *value = [weightsArray objectAtIndex:weightBtn.tag];
    [selectedWeightArray removeObject:value];
        if(self.totalWeightValue>0) {
    self.totalWeightValue -=2*[value floatValue];
            if(self.totalWeightValue<0)
                self.totalWeightValue = 0;
            
    self.totalWeightLabel.text = [NSString stringWithFormat:@"%.2f %@",self.totalWeightValue,kDefaultWeightMetric];
    
    NSMutableString *distributedString = [[selectedWeightArray componentsJoinedByString:@" + "]mutableCopy];
    
    [distributedString appendFormat:@" %@",kDefaultWeightMetric];
        if(self.totalWeightValue>0)
    _distributedLabel.text = distributedString;
        
        
    if(self.delegate &&[self.delegate respondsToSelector:@selector(didSelectWeightWithValue:)])
        [self.delegate didSelectWeightWithValue:self.totalWeightValue];
    }
    }
    
}
@end
