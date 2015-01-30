//
//  GLDayInfo.h
//  GymLog
//
//  Created by Sunny on 30/01/14.
//  Copyright (c) 2014 Apptree Studio LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GLWorkoutInfo;

@interface GLDayInfo : NSManagedObject

@property (nonatomic, retain) NSString * day_name;
@property (nonatomic, retain) NSString * object_id;
@property (nonatomic, retain) NSString * day_description;
@property (nonatomic, retain) NSDate * created_date;
@property (nonatomic, retain) GLWorkoutInfo *workout_r;

@end
