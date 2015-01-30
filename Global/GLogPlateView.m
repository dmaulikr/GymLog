//
//  GLogPlateView.m
//  GymLog
//
//  Created by Amendeep Singh on 04/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogPlateView.h"
#define weightButtonSize CGSizeMake(123,17)

@interface GLogPlateView()
{
    NSMutableArray *weightsArray;
    NSInteger totalStackHeight;
    __weak IBOutlet UILabel *distrubutedWeightLabel;
    UISlider *stackSlider;
}
@end
@implementation GLogPlateView
-(void)awakeFromNib {
    [self generatePlateWeightsInScroll];
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)generatePlateWeightsInScroll {
    
    totalStackHeight = 0;
        weightsArray = [[NSMutableArray alloc]initWithObjects:@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"55",@"75",@"85", nil];
    selectedWeightArray = [NSMutableArray new];
    for (int count =0; count<weightsArray.count; count++) {
        
        NSString *weightValue = [weightsArray objectAtIndex:count];
        UIButton *weightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[weightButton setBackgroundImage:[UIImage imageNamed:@"plate_button"] forState:UIControlStateNormal];
      
        [weightButton setBackgroundColor:kPlateColor];
        [weightButton setTag:count];
        [weightButton setTitle:weightValue forState:UIControlStateNormal];
        weightButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        [weightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if(count<5)
              [weightButton setFrame:CGRectMake(14,count*(weightButtonSize.height+1) , weightButtonSize.width, weightButtonSize.height)];
        
        else [weightButton setFrame:CGRectMake(0,count*(weightButtonSize.height+1) , 150, weightButtonSize.height)];
        totalStackHeight +=(weightButtonSize.height+1);
       
        
        [_weightScrollView addSubview:weightButton];
    }
    
    
    CGRect frame = _weightScrollView.frame;
    frame.size.height = totalStackHeight;
    _weightScrollView.frame = frame;
    _weightScrollView.clipsToBounds = YES;
    
    [self prepareStackSlider];
    
}

-(void)prepareStackSlider {

     stackSlider = [[UISlider alloc]initWithFrame:CGRectMake(-10,117, totalStackHeight, 30)];
    [stackSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [stackSlider addTarget:self action:@selector(sliderEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [stackSlider addTarget:self action:@selector(sliderEnded:) forControlEvents:UIControlEventTouchUpInside];
    [stackSlider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    UIImage *sliderLeftTrackImage = [[UIImage imageNamed: @"slider_base"] stretchableImageWithLeftCapWidth: 9 topCapHeight: 0];
    UIImage *sliderRightTrackImage = [[UIImage imageNamed: @"slider_base"] stretchableImageWithLeftCapWidth: 9 topCapHeight: 0];
    [stackSlider setMinimumTrackImage: sliderLeftTrackImage forState: UIControlStateNormal];
    [stackSlider setMaximumTrackImage: sliderRightTrackImage forState: UIControlStateNormal];
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 0.5);
    stackSlider.transform = trans;
   // CGAffineTransform sliderRotation = CGAffineTransformIdentity;
    //sliderRotation = CGAffineTransformRotate(stackSlider.transform, (M_PI / 2));
    [self addSubview:stackSlider];
 //   stackSlider.center = self.center;
}


-(void)updateCurrentWeightValue:(CGFloat)weightValue {

    for (UIView *subview in [_weightScrollView subviews]) {
        if([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subview;

            button.enabled = NO;
        }
    }
 //   self.totalWeightValue = weightValue;
    
    CGFloat sliderValue = 0;

        for (NSString *weightString in weightsArray) {
            
            
            if([weightString floatValue]<=weightValue){
                sliderValue +=(weightButtonSize.height+1);
            }
        
    }
    [selectedWeightArray removeAllObjects];

    NSLog(@"%f",(float)sliderValue/totalStackHeight);
    CGFloat value = (float)sliderValue/totalStackHeight;
    
    if(value>1)
        value = 1.0;
   // self.totalWeightLabel.text = [NSString stringWithFormat:@"%.1f %@",weightValue,kDefaultWeightMetric];
    [stackSlider setValue:value animated:YES];
    [self sliderValueChanged:stackSlider];
    [self sliderEnded:stackSlider];
    
    
}

-(void)sliderValueChanged:(UISlider*)sender {

    NSLog(@"%f",sender.value*totalStackHeight);
    float totalWeight = 0;
    float stackValue = sender.value*totalStackHeight;
    
    
    for (UIView *subview in [_weightScrollView subviews]) {
        if([subview isKindOfClass:[UIButton class]]) {
        
            UIButton *button = (UIButton*)subview;
            if(button.frame.origin.y+button.frame.size.height<stackValue){
               button.enabled = YES;
                [button setBackgroundColor:kPlateSelectedColor];
                NSString *weightString = [weightsArray objectAtIndex:button.tag];
                [selectedWeightArray addObject:weightString];
                totalWeight +=[weightString floatValue];
            }
            
            else {
                if(button.enabled) {
                    [button setBackgroundColor:kPlateColor];

                    NSString *weightString = [weightsArray objectAtIndex:button.tag];
                    [selectedWeightArray removeObject:weightString];

                    totalWeight -=[weightString floatValue];
                }

                button.enabled = NO;
                
            }
            
        }
    }
    if(totalWeight<0)
        totalWeight = 0;
    

    totalWeight = [[selectedWeightArray lastObject]floatValue];
    self.totalWeightValue = totalWeight;

    self.totalWeightLabel.text = [NSString stringWithFormat:@"%.1f %@",totalWeight,kDefaultWeightMetric];
    
  }

-(void)sliderEnded:(UISlider*)sender {
    
    
    [selectedWeightArray removeAllObjects];
    for (UIView *subview in [_weightScrollView subviews]) {
        if([subview isKindOfClass:[UIButton class]]) {
          
            UIButton *button = (UIButton*)subview;
            if(button.enabled) {
                NSString *weightString = [weightsArray objectAtIndex:button.tag];

                [selectedWeightArray addObject:weightString];
            }
        }}
    distrubutedWeightLabel.text = @"";
    
    float totalWeight = [self.totalWeightLabel.text floatValue];
    if(self.delegate &&[self.delegate respondsToSelector:@selector(didSelectWeightWithValue:)])
        [self.delegate didSelectWeightWithValue:totalWeight];

}

@end
