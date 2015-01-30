//
//  GLogPickerCollectionLayout.m
//  GymLog
//
//  Created by Amendeep Singh on 24/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogPickerCollectionLayout.h"

const NSInteger kMaxCellSpacing = 9;

@implementation GLogPickerCollectionLayout
-(id)init {

    self = [super init];
    
    if(self) {
    
      //  cell_offset.x = 108;
    }
    
    return self;
}
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* arr = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* atts in arr) {
        if (nil == atts.representedElementKind) {
            NSIndexPath* ip = atts.indexPath;
            atts.frame = [self layoutAttributesForItemAtIndexPath:ip].frame;
        }
    }
    return arr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* atts =
    [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame =    atts.frame;
    
    NSArray *selectedItems = [self.collectionView indexPathsForSelectedItems];
    NSLog(@"%@",selectedItems);
    
    if(selectedItems.count) {
        NSIndexPath *selectedIP  = [selectedItems lastObject];
        
        NSInteger index = selectedIP.row;
        
        cell_offset.x = 0;
        index = index+1;
        
        switch (index%3) {
            case 0:
            {
                cell_offset.x -= (frame.size.width+1);
                
              //  if(cell_offset.x<0)
                //    cell_offset.x = 0;
            }
                break;
            case 1: {
                cell_offset.x = frame.size.width+1;
                if(frame.origin.x+frame.size.width >=self.collectionView.frame.size.width){
                    cell_offset.x = 0;
                    frame.origin.x = 0;
                    frame.origin.y +=frame.size.height+1;
                    //due to
                }

            }
            default: {
              //  cell_offset.x = 0;

            }
                break;
        }
    }
    
    //
   
    
  //  else
        frame.origin.x +=cell_offset.x;
    if(frame.origin.x<0)
        frame.origin.x = 0;
  
    
    previousFrame = frame;
    
    
    NSIndexPath* ipPrev =
    [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];

    if(ipPrev.row+1%3!=0)
        frame.origin.y = previousFrame.origin.y;
    atts.frame = frame;
        return atts;
   // }
    
    
    
    CGRect fPrev = [self layoutAttributesForItemAtIndexPath:ipPrev].frame;

   
    CGFloat rightPrev = fPrev.origin.x + fPrev.size.width + 10;
    if (atts.frame.origin.x <= rightPrev) // degenerate case 2, first item of line
        return atts;
    
    CGRect f = atts.frame;
    f.origin.x = rightPrev;
    atts.frame = f;
    return atts;
}

@end