//
//  WorkoutPickerCell.m
//  GymLog
//
//  Created by Amendeep Singh on 29/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "WorkoutPickerCell.h"

typedef NS_ENUM(NSUInteger, SwipeTableViewCellDirection){
    SwipeTableViewCellDirectionLeft = 0,
    SwipeTableViewCellDirectionCenter,
    SwipeTableViewCellDirectionRight
};

static CGFloat const kMCStop1 = 0.40; // Percentage limit to trigger the first action
static CGFloat const kMCStop2 = 0.40; // Percentage limit to trigger the second action
static CGFloat const kMCBounceAmplitude = 20.0; // Maximum bounce amplitude when using the MCSwipeTableViewCellModeSwitch mode
static NSTimeInterval const kMCBounceDuration1 = 0.2; // Duration of the first part of the bounce animation
static NSTimeInterval const kMCBounceDuration2 = 0.1; // Duration of the second part of the bounce animation
static NSTimeInterval const kMCDurationLowLimit = 0.25; // Lowest duration when swipping the cell because we try to simulate velocity
static NSTimeInterval const kMCDurationHightLimit = 0.1; // Highest dur

@interface WorkoutPickerCell()<UIGestureRecognizerDelegate> {

    BOOL dragging;
    float first_x;
    float first_y;
    
}
- (IBAction)startBtnPressed:(id)sender;
- (IBAction)modyBtnPressed:(id)sender;
@property(nonatomic, assign) CGFloat currentPercentage;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property(nonatomic, assign) SwipeTableViewCellDirection direction;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;


@end

@implementation WorkoutPickerCell
@synthesize delegate;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    if([kAppDelegate is_menu_open] || [otherGestureRecognizer.view isKindOfClass:[UITableView class]])
        return NO;
    
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    //NSLog(@"OPEN :%d",[kAppDelegate is_menu_open]);
    if([kAppDelegate is_menu_open])
        return NO;
    
    if ([gestureRecognizer class] == [UIPanGestureRecognizer class]) {
        UIPanGestureRecognizer *g = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [g velocityInView:self];
        if (fabsf(point.x) > fabsf(point.y) ) {
            return YES;
        }
    }
    return NO;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        //CALayer *rightBorder = [CALayer layer];
        //rightBorder.borderColor = kBorderColor.CGColor;
        //rightBorder.borderWidth = 1;
       // rightBorder.frame = CGRectMake(0, -1, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)+1);
     //   [self.contentView.layer addSublayer:rightBorder];
    }
    return self;
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
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDetected:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    panRecognizer.delegate = self;
    
    [self.contentView addGestureRecognizer:panRecognizer];


    // Configure the view for the selected state
}

- (CGFloat)percentageWithOffset:(CGFloat)offset relativeToWidth:(CGFloat)width {
    CGFloat percentage = offset / width;
    
    if (percentage < -1.0) percentage = -1.0;
    else if (percentage > 1.0) percentage = 1.0;
    
    return percentage;
}
- (SwipeTableViewCellDirection)directionWithPercentage:(CGFloat)percentage {
    if (percentage < -kMCStop1)
        return SwipeTableViewCellDirectionLeft;
    else if (percentage > kMCStop1)
        return SwipeTableViewCellDirectionRight;
    else
        return SwipeTableViewCellDirectionCenter;
}


- (NSTimeInterval)animationDurationWithVelocity:(CGPoint)velocity {
    
    
    CGFloat width = CGRectGetWidth(self.descriptionView.bounds);
    NSTimeInterval animationDurationDiff = kMCDurationHightLimit - kMCDurationLowLimit;
    CGFloat horizontalVelocity = (velocity.x);
    
    if (horizontalVelocity < -width) horizontalVelocity = -width;
    else if (horizontalVelocity > width) horizontalVelocity = width;
    
    return (kMCDurationHightLimit + kMCDurationLowLimit) - fabs(((horizontalVelocity / width) * animationDurationDiff));
}

- (void)moveWithDuration:(NSTimeInterval)duration andDirection:(SwipeTableViewCellDirection)direction {
    CGFloat origin;
    
    if (direction == SwipeTableViewCellDirectionLeft)
        origin = -CGRectGetWidth(self.bounds);
    else
        origin = CGRectGetWidth(self.bounds);
    
 //   CGFloat percentage = [self percentageWithOffset:origin relativeToWidth:CGRectGetWidth(self.bounds)];
    CGRect rect = self.descriptionView.frame;
    rect.origin.x = origin;
    
    
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [self.descriptionView setFrame:rect];
                         
                     }
                     completion:^(BOOL finished) {
                     }];
}


- (void)panDetected:(UIPanGestureRecognizer*)sender
{
    //NSLog(@"PAN");
    
    
    //    CGPoint location = [sender locationInView:self];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self];
    CGFloat percentage = [self percentageWithOffset:CGRectGetMinX(self.descriptionView.frame) relativeToWidth:CGRectGetWidth(self.descriptionView.bounds)];
    _direction = [self directionWithPercentage:percentage];
    
  //  NSLog(@"%f",percentage);
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan)
    {
        first_x = [self.descriptionView center].x;
        first_y = [self.descriptionView center].y;
    }
    
    else if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
    //    CGRect frame = self.descriptionView.frame;
        _currentPercentage = percentage;
        
        //    NSLog(@"ENDED X: %f",frame.origin.x);
        //[self bounceToOrigin];
            //  CGPoint velocity =[(UIPanGestureRecognizer*)sender velocityInView:self.descriptionView];
    //
      //  NSTimeInterval animationDuration = [self animationDurationWithVelocity:velocity];
        
       }
    
    
    else {
        translatedPoint = CGPointMake(first_x+((translatedPoint.x)), self.descriptionView.frame.size.height/2);
        
        
     //   NSLog(@"%f ",self.descriptionView.center.x);
        if(abs(translatedPoint.x)>160)
            translatedPoint.x = 160;
        else if(translatedPoint.x<95   )
            translatedPoint.x = 95;
        
        
        
        
        CGPoint velocity =[(UIPanGestureRecognizer*)sender velocityInView:self.descriptionView];
        //[sender velocityInView:self];
        
        
        
        NSTimeInterval animationDuration = [self animationDurationWithVelocity:velocity];
        
        
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             [self.descriptionView setCenter:translatedPoint];
                             
                         }
                         completion:^(BOOL finished) {
                             //  [self notifyDelegate];
                         }];
        
    }
    
}

//- (void)bounceToOrigin {
//    [UIView animateWithDuration:kMCBounceDuration2
//                          delay:0
//                        options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         CGRect frame = self.descriptionView.frame;
//                                                frame.origin.x = -65;
//                         [self.descriptionView setFrame:frame];
//                     }
//                     completion:^(BOOL finished2) {
//                         CGRect frame = self.descriptionView.frame;
//                         if(frame.origin.x==_agreeImageView.frame.size.width) {
//                             if([self.delegate respondsToSelector:@selector(didSwipeCellForUpVote:)]) {
//                                 
//                                 [self.delegate didSwipeCellForUpVote:self];
//                                 frame.origin.x = 0;
//                                 
//                             }
//                             
//                         }
//                         
//                         
//                         else if(frame.origin.x==-_disagreeImageView.frame.size.width) {
//                             if([self.delegate respondsToSelector:@selector(didSwipeCellForDownVote:)]) {
//                                 
//                                 [self.delegate didSwipeCellForDownVote:self];
//                             }
//                             
//                         }
//                         
//                     }];
//}

- (IBAction)startBtnPressed:(id)sender {

    if(self.delegate &&[self.delegate respondsToSelector:@selector(didSelectStartButtonForCell:)])
        [self.delegate didSelectStartButtonForCell:self];

}

- (IBAction)modyBtnPressed:(id)sender {
    if(self.delegate &&[self.delegate respondsToSelector:@selector(didSelectModifyButtonForCell:)])
        [self.delegate didSelectModifyButtonForCell:self];
    
}
@end
