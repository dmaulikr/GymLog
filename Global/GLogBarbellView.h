//
//  GLogBarbellView.h
//  GymLog
//
//  Created by Amendeep Singh on 02/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLogWeightBaseView.h"



@interface GLogBarbellView : GLogWeightBaseView
{
    @protected
    NSMutableArray *weightsArray;

}

-(void)generateBarbellWeightsInScroll;
@property (weak, nonatomic) IBOutlet UIScrollView *weightScrollView;

@property (weak, nonatomic) IBOutlet UILabel *distributedLabel;

@end
