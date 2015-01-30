//
//  DayInfo.h
//  GymLog
//
//  Created by Amendeep Singh on 10/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExerciseInfo, WorkoutInfo;

@interface DayInfo : NSManagedObject

@property (nonatomic, retain) NSString * day_name;
@property (nonatomic, retain) NSDate * day_date;
@property (nonatomic, retain) WorkoutInfo *workout_r;
@property (nonatomic, retain) NSOrderedSet *exercise_r;
@property(nonatomic,retain) NSString *object_id;
@end

@interface DayInfo (CoreDataGeneratedAccessors)

- (void)insertObject:(ExerciseInfo *)value inExercise_rAtIndex:(NSUInteger)idx;
- (void)removeObjectFromExercise_rAtIndex:(NSUInteger)idx;
- (void)insertExercise_r:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeExercise_rAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInExercise_rAtIndex:(NSUInteger)idx withObject:(ExerciseInfo *)value;
- (void)replaceExercise_rAtIndexes:(NSIndexSet *)indexes withExercise_r:(NSArray *)values;
- (void)addExercise_rObject:(ExerciseInfo *)value;
- (void)removeExercise_rObject:(ExerciseInfo *)value;
- (void)addExercise_r:(NSOrderedSet *)values;
- (void)removeExercise_r:(NSOrderedSet *)values;
@end
