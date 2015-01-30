//
//  GLWorkoutInfo.h
//  GymLog
//
//  Created by Sunny on 30/01/14.
//  Copyright (c) 2014 Apptree Studio LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GLDayInfo;

@interface GLWorkoutInfo : NSManagedObject

@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSString * workout_description;
@property (nonatomic, retain) NSString * workout_id;
@property (nonatomic, retain) NSString * workout_name;
@property (nonatomic, retain) NSOrderedSet *day_r;
@property(nonatomic,retain) NSString*owner_id;
@end

@interface GLWorkoutInfo (CoreDataGeneratedAccessors)

- (void)insertObject:(GLDayInfo *)value inDay_rAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDay_rAtIndex:(NSUInteger)idx;
- (void)insertDay_r:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDay_rAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDay_rAtIndex:(NSUInteger)idx withObject:(GLDayInfo *)value;
- (void)replaceDay_rAtIndexes:(NSIndexSet *)indexes withDay_r:(NSArray *)values;
- (void)addDay_rObject:(GLDayInfo *)value;
- (void)removeDay_rObject:(GLDayInfo *)value;
- (void)addDay_r:(NSOrderedSet *)values;
- (void)removeDay_r:(NSOrderedSet *)values;
@end
