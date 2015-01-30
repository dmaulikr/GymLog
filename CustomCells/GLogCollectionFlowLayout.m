//
//  GLogCollectionFlowLayout.m
//  GymLog
//
//  Created by Sunny on 10/12/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogCollectionFlowLayout.h"

@implementation GLogCollectionFlowLayout

- (CGSize)collectionViewContentSize
{
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    int rowCount = itemCount/3;
    
    rowCount+=itemCount%3;
    
    rowCount +=2;
    
    
    return CGSizeMake(self.collectionView.frame.size.width, rowCount*80);
}

@end
