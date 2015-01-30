//
//  HistoryInfo.h
//  GymLog
//
//  Created by Amendeep Singh on 02/11/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExerciseInfo;

@interface HistoryInfo : NSManagedObject
@property (nonatomic, retain) NSDate * workout_start_time;
@property (nonatomic, retain) NSDate * workout_end_time;

@property (nonatomic, retain) NSString * workout_name;
@property (nonatomic, retain) NSDate * workout_date;
@property (nonatomic, retain) NSNumber * workout_duration;

@property (nonatomic, retain) NSOrderedSet *exercise_r;
@end

@interface HistoryInfo (CoreDataGeneratedAccessors)

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
