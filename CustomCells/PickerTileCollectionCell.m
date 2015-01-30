//
//  PickerTileCollectionCell.m
//  GymLog
//
//  Created by Amendeep Singh on 24/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "PickerTileCollectionCell.h"
static CGSize _extraMargins = {0,0};

@implementation PickerTileCollectionCell

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


- (CGSize)intrinsicContentSize
{
    CGSize size = [self.title_label intrinsicContentSize];
    
    if (CGSizeEqualToSize(_extraMargins, CGSizeZero))
    {
        // quick and dirty: get extra margins from constraints
        for (NSLayoutConstraint *constraint in self.constraints)
        {
            if (constraint.firstAttribute == NSLayoutAttributeBottom || constraint.firstAttribute == NSLayoutAttributeTop)
            {
                // vertical spacer
                _extraMargins.height += [constraint constant];
            }
            else if (constraint.firstAttribute == NSLayoutAttributeLeading || constraint.firstAttribute == NSLayoutAttributeTrailing)
            {
                // horizontal spacer
                _extraMargins.width += [constraint constant];
            }
        }
    }
    
    // add to intrinsic content size of label
    size.width += _extraMargins.width;
    size.height += _extraMargins.height;
    size.height = 33;
    return size;
}


@end
