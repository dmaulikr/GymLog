//
//  GLogBlendView.m
//  GymLog
//
//  Created by Amendeep Singh on 28/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogBlendView.h"

@implementation GLogBlendView
-(id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    
    if(self) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.bounds];
        imgView.image =[UIImage imageNamed:@"blend_background"];
        [self addSubview:imgView];
        [self sendSubviewToBack:imgView];
        // Initialization code

    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.bounds];
        imgView.image =[UIImage imageNamed:@"blend_background"];
        [self addSubview:imgView];
        [self sendSubviewToBack:imgView];

           }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    [[UIColor colorWithRed:(float)225/256 green:(float)225/256 blue:(float)225/256 alpha:1.0] setFill];
//  //  UIRectFill( rect );
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    // Drawing code
//   UIImage* uiimage = [UIImage imageNamed:@"bg_blended"];
////    UIGraphicsBeginImageContext(rect.size);
//  //  CGContextSetBlendMode(context, kCGBlendModeColor);
//CGContextDrawImage(context, rect, uiimage.CGImage);
//  // [uiimage drawAtPoint:CGPointZero blendMode:kCGBlendModeColor alpha:1.0];
////    UIGraphicsEndImageContext();
//
//    
//    
//}


@end
