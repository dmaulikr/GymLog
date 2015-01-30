//
//  GLogWeightBaseView.m
//  GymLog
//
//  Created by Amendeep Singh on 03/12/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogWeightBaseView.h"

@implementation GLogWeightBaseView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)updateCurrentWeightValue:(CGFloat)weightValue  {

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
