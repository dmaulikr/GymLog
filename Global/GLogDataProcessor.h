//
//  GLogDataProcessor.h
//  GymLog
//
//  Created by Amendeep Singh on 23/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BodyPartInfo.h"
#import "ExerciseInfo.h"
#import "WorkoutInfo.h"
#import "TagInfo.h"
#import "HistoryInfo.h"
#import "SetInfo.h"
#import "DayInfo.h"
#import "ExIconInfo.h"
#import "GLWorkoutInfo.h"
#import "GLExerciseInfo.h"
#import "GLDayInfo.h"
@interface GLogDataProcessor : NSObject
+ (id)sharedProcessor;
-(DayInfo*)addNewDayForWorkout:(WorkoutInfo*)workout name:(NSString*)day_name;
-(HistoryInfo*)createWorkoutHistory:(NSMutableDictionary*)historyDict exerciseList:(NSOrderedSet*)exerciseArray;
-(WorkoutInfo*)addWorkoutWithName:(NSString*)workoutName description:(NSString*)desc;
-(void)addBodyPartWithName:(NSString*)partName ;
-(void)addExercise:(ExerciseInfo*)exercise workoutDay:(DayInfo*)day;
-(SetInfo*)addNewSetForExercise:(ExerciseInfo*)exercise ;
-(void)addExercise:(NSDictionary*)exerciseDict bodyPart:(BodyPartInfo*)bodyPart;
-(void)addTagWithName:(NSString*)tag_name workout:(WorkoutInfo*)workout;
- (void)deleteAllObjects:(NSString *)entityDescription;
- (NSArray *)fetchMultipleEntitiesByName:(NSString *)entityName withPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext*)context;
- (NSManagedObject *)fetchEntityByName:(NSString *)entityName forAttribute:(NSString *)attribute Value:(NSString *)value;

- (NSArray *)fetchMultipleEntitiesByName:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (NSArray *)fetchMultipleEntitiesByName:(NSString *)entityName;
- (NSArray *)fetchMultipleEntitiesByName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDesc:(NSSortDescriptor*)sortDescriptor;
#pragma mark parse methods
-(void)addParseBodyPart:(PFObject*)bodyPartObject ;
-(GLWorkoutInfo*)addAppWorkOutWithExercises:(PFObject*)pf_workout;
-(WorkoutInfo*)addParseUserWorkout:(PFObject*)workoutObject;
-(void)addExerciseForBodyPart:(PFObject*)exerciseObject bodyPartID:(NSString*)bodyPartID;
-(ExerciseInfo*)addUserExerciseEntry:(GLExerciseInfo*)gl_exercise workoutDay:(DayInfo*)day;
-(void)addUserExercisesForDay:(DayInfo*)day exercise:(PFObject*)exerciseObject;
@end
