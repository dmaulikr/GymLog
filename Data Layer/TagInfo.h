//
//  TagInfo.h
//  GymLog
//
//  Created by Amendeep Singh on 02/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WorkoutInfo;

@interface TagInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * tag_id;
@property (nonatomic, retain) NSString * tag_name;
@property (nonatomic, retain) WorkoutInfo *workout_r;

@end
