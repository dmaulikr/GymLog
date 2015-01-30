//
//  GLogWeightBaseView.h
//  GymLog
//
//  Created by Amendeep Singh on 03/12/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WeightViewDelegate<NSObject>
@optional
-(void)didSelectWeightWithValue:(CGFloat)weight_value;
@end
@interface GLogWeightBaseView : UIView {
    NSMutableArray *selectedWeightArray;

}
@property (assign)  CGFloat totalWeightValue;
-(void)updateCurrentWeightValue:(CGFloat)weightValue ;
@property (weak, nonatomic) IBOutlet UILabel *totalWeightLabel;
@property (unsafe_unretained)  id<WeightViewDelegate> delegate;
@end
