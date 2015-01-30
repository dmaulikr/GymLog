//
//  WorkoutInfo.h
//  GymLog
//
//  Created by Amendeep Singh on 10/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TagInfo;

@interface WorkoutInfo : NSManagedObject
@property (nonatomic, retain) NSDate * create_date;

@property (nonatomic, retain) NSString * workout_description;
@property (nonatomic, retain) NSString * workout_id;
@property (nonatomic, retain) NSString * workout_name;
@property (nonatomic, retain) NSOrderedSet *tag_r;
@property (nonatomic, retain) NSOrderedSet *day_r;
@end

@interface WorkoutInfo (CoreDataGeneratedAccessors)

- (void)addTag_rObject:(TagInfo *)value;
- (void)removeTag_rObject:(TagInfo *)value;
- (void)addTag_r:(NSSet *)values;
- (void)removeTag_r:(NSSet *)values;

- (void)addDay_rObject:(NSManagedObject *)value;
- (void)removeDay_rObject:(NSManagedObject *)value;
- (void)addDay_r:(NSSet *)values;
- (void)removeDay_r:(NSSet *)values;

@end
