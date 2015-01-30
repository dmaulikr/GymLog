//
//  GLogNetworkEngine.h
//  GymLog
//
//  Created by Amendeep Singh on 23/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^completeBlock_t)(id object);
typedef void (^error_block)(NSError *error);

@interface GLogNetworkEngine : NSObject
+ (id)sharedEngine;
-(void)syncAdminWorkoutsWithApp:(completeBlock_t)completionBlock;

-(void)getUserWorkouts:(completeBlock_t)completionBlock;
-(void)addNewWorkoutForParseUser:(NSDictionary*)dict completionBlock:(completeBlock_t)completionBlock errorBlock:(error_block)errorBlock;
-(void)addNewDayForUserWorkout:(PFObject*)workoutObject params:(NSMutableDictionary*)dict completionBlock:(completeBlock_t)completionBlock  errorBlock:(error_block)errorBlock;
-(void)syncBodyPartsAndExercisesFromParse:(completeBlock_t)completionBlock errorBlock:(error_block)errorBlock;
-(void)addNewExercisesForDay:(PFObject*)dayObject   exerciseList:(NSMutableArray*)exerciseArray completionBlock:(completeBlock_t)completionBlock    errorBlock:(error_block)errorBlock;
-(void)insertSetsForAllExercises:(NSOrderedSet*)exerciseArray completion:(completeBlock_t)completionBlock errorBlock:(error_block)errorBlock;
-(void)addWorkoutHistory:(HistoryInfo*)workout completion:(completeBlock_t)completionBlock errorBlock:(error_block)errorBlock ;
@end
