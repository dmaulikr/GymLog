//
//  GLogNetworkEngine.m
//  GymLog
//
//  Created by Amendeep Singh on 23/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogNetworkEngine.h"
static GLogNetworkEngine* _sharedEngine = nil;

@implementation GLogNetworkEngine

-(id)init {
    
    self = [super init];
    if(self) {
    }
    
    return self;
}


+ (id)sharedEngine {
    
    @synchronized(self)
    {
        if (_sharedEngine == nil)
            _sharedEngine = [[self alloc] init];
        
    }
    return _sharedEngine;
}

-(void)syncAdminWorkoutsWithApp:(completeBlock_t)completionBlock {

    PFQuery *query = [PFQuery queryWithClassName:kGLWorkoutInfo];
    [query includeKey:@"day_ar.exercise_ar"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *workoutObjects, NSError *error) {
        if(!error) {
        
            NSLog(@"%@",workoutObjects);
            
            for (PFObject *workout in workoutObjects) {
                [[GLogDataProcessor sharedProcessor]addAppWorkOutWithExercises:workout];
            //    NSArray *exerciseArray = [workout objectForKey:@"exercise_ar"];
                
              //  NSLog(@"%@",exerciseArray);
            }
            completionBlock(nil);
        }
        
        
    }];
    
}


-(void)getUserWorkouts:(completeBlock_t)completionBlock  {

    PFQuery *query = [PFQuery queryWithClassName:kUserWorkoutInfo];
    [query includeKey:@"day_info_ar"];
   [query includeKey:@"day_info_ar.exercise_ar"];
    [query whereKey:@"user_info_p" equalTo:[PFUser currentUser]];
   // [query whereKey:@"owner_info" equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:kAdminUserID]];
    
  //  PFQuery *secondQuery = [PFQuery queryWithClassName:kGLWorkoutInfo];
    //[secondQuery whereKey:@"owner_info" equalTo:[PFUser currentUser]];

    //PFQuery *finalQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:query,secondQuery, nil]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *workoutObjects, NSError *error) {
        if(!error) {
            
            NSLog(@"%@",workoutObjects);
            
            for (PFObject *workout in workoutObjects) {
                
                [[GLogDataProcessor sharedProcessor]addParseUserWorkout:workout];
                //    NSArray *exerciseArray = [workout objectForKey:@"exercise_ar"];
                
                //  NSLog(@"%@",exerciseArray);
            }
            completionBlock(nil);
        }
        
        
    }];

}

//-(void)addNewExerciseForDay:(PFObject*)dayObject   exerciseInfo:(NSMutableDictionary*)dict completionBlock:(completeBlock_t)completionBlock    errorBlock:(error_block)errorBlock {
//    PFObject *exerciseObject = [PFObject objectWithClassName:kUserExerciseInfo];
//    
//    
//    [exerciseObject setValue:[PFObject objectWithoutDataWithClassName:kGLExerciseInfo objectId:[dict valueForKey:@"gl_object_id"]] forKey:@"gl_exercise_p"];
//    
//  //  [exerciseObject saveInBackgroundWithBlock:<#^(BOOL succeeded, NSError *error)block#>]
//    
//}

-(void)addNewExercisesForDay:(PFObject*)dayObject   exerciseList:(NSMutableArray*)exerciseArray completionBlock:(completeBlock_t)completionBlock    errorBlock:(error_block)errorBlock {

    NSMutableArray *objectArray = [NSMutableArray new];
    NSMutableArray *exerciseObjectArray =[NSMutableArray new];
    for (ExerciseInfo *exercise in exerciseArray) {
        
        PFObject *exerciseObject = [PFObject objectWithClassName:kUserExerciseInfo];
        [exerciseObject setValue:exercise.gl_exercise_r.exercise_name forKey:@"exercise_name"];
        [exerciseObject setValue:[PFObject objectWithoutDataWithClassName:kGLExerciseInfo objectId:exercise.gl_exercise_r.object_id] forKey:@"gl_exercise_p"];
        [objectArray addObject:exerciseObject];
       

        [exerciseObjectArray addObject:exerciseObject];
        
    }
    //  dayObject[@"day_description"] =   dict[@"day_description"] ;
    [dayObject addObjectsFromArray:exerciseObjectArray forKey:@"exercise_ar"];
    [objectArray addObject:dayObject];

    [PFObject saveAllInBackground:objectArray block:^(BOOL succeeded, NSError *error) {
        
        if(!error) {
            NSMutableArray *relationArray = [NSMutableArray new];
            for (PFObject *exerciseObject in exerciseObjectArray) {
                PFObject *glObject = [exerciseObject objectForKey:@"gl_exercise_p"];
                PFRelation *relation = [glObject relationForKey:@"user_exercise_r"];
                [relation addObject:exerciseObject];
                [relationArray addObject:glObject];
            }
            [PFObject saveAllInBackground:relationArray];
           // NSLog(@"%@",objectArray);
            
            completionBlock(exerciseObjectArray);
            NSLog(@"SAVED ALL EXERCISES");
        }
        else errorBlock(error);
    }];
    

}

-(void)addNewDayForUserWorkout:(PFObject*)workoutObject params:(NSMutableDictionary*)dict completionBlock:(completeBlock_t)completionBlock    errorBlock:(error_block)errorBlock {

    PFObject *dayObject = [PFObject objectWithClassName:kUserDayInfo];
    dayObject[@"day_name"] =   dict[@"day_name"] ;
  //  dayObject[@"day_description"] =   dict[@"day_description"] ;
    [workoutObject addObject:dayObject forKey:@"day_info_ar"];
    
    [PFObject saveAllInBackground:[NSArray arrayWithObjects:workoutObject,dayObject, nil] block:^(BOOL succeeded, NSError *error) {
        if(!error) {
        
            completionBlock(dayObject);
        }
        else errorBlock(error);
    }];

}

-(void)addNewWorkoutForParseUser:(NSDictionary*)dict completionBlock:(completeBlock_t)completionBlock errorBlock:(error_block)errorBlock{

    PFObject *workout = [PFObject objectWithClassName:kUserWorkoutInfo];
    workout[@"workout_name"] = dict[@"workout_name"];
    workout[@"workout_description"] = dict[@"workout_description"];
    workout[@"user_info_p"] = [PFUser currentUser];
    
            NSMutableArray *dayArray = [[NSMutableArray alloc]init];
            for (NSDictionary *day in [dict objectForKey:@"day_info_ar"]) {
                PFObject *dayObject = [PFObject objectWithClassName:kUserDayInfo];
                dayObject[@"day_name"] = day[@"day_name"];
                dayObject[@"day_date"] = day[@"day_date"];
                [dayArray addObject:dayObject];
                
            }
            [PFObject saveAllInBackground:dayArray block:^(BOOL succeeded, NSError *error) {
                if(!error) {
                    [workout addObjectsFromArray:dayArray forKey:@"day_info_ar"];
                    [workout saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(!error) {
                            completionBlock(workout);
                        }
                        else errorBlock(error);

                    
                    }];
                
                }
                else errorBlock(error);
            
            }
             ];
            
            

            
 
    
}
-(void)insertSetsForAllExercises:(NSOrderedSet*)exerciseArray completion:(completeBlock_t)completionBlock errorBlock:(error_block)errorBlock{
    NSMutableArray *exerciseList = [NSMutableArray new];
    for (ExerciseInfo *exercise in exerciseArray) {
        PFObject *exerciseObject = [PFObject objectWithoutDataWithClassName:kUserExerciseInfo objectId:exercise.exercise_id];
        NSMutableArray *setArray = [[NSMutableArray alloc]init];
        for (SetInfo *set in exercise.set_r) {
            PFObject *setObject = [PFObject objectWithClassName:kGLSetInfo];
            [setObject setObject:set.set_repetitions forKey:@"set_repetitions"];
            [setObject setObject:set.set_weight forKey:@"set_weight"];
            [setArray addObject:setObject];
            
        }
        [exerciseObject addObjectsFromArray:setArray forKey:@"set_ar"];
        [exerciseList addObject:exerciseObject];
        
    }
    
    [PFObject saveAllInBackground:exerciseList block:^(BOOL succeeded, NSError *error) {
        if(!error) completionBlock(nil);
        
        else errorBlock(error);
    }];

    
}

-(void)addWorkoutHistory:(HistoryInfo*)workout completion:(completeBlock_t)completionBlock errorBlock:(error_block)errorBlock  {

    PFObject *historyObject = [PFObject objectWithClassName:kUserHistoryInfo];
    [historyObject setObject:[PFUser currentUser] forKey:@"user_info_p"];
    
    [historyObject setObject:workout.workout_date forKey:@"workout_date"];
    [historyObject setObject:workout.workout_end_time forKey:@"workout_end_time"];
    [historyObject setObject:workout.workout_start_time forKey:@"workout_start_time"];
    [historyObject setObject:workout.workout_name forKey:@"workout_name"];
    [historyObject setObject:workout.workout_duration forKey:@"workout_duration"];
    
    NSMutableArray *exerciseArray = [NSMutableArray new];
    for (ExerciseInfo *exercise in workout.exercise_r) {
        [exerciseArray addObject:[PFObject objectWithoutDataWithClassName:kUserExerciseInfo objectId:exercise.exercise_id]];
    }
    [historyObject addObjectsFromArray:exerciseArray forKey:@"exercise_ar"];

    [historyObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error) completionBlock(nil);
        else errorBlock(error);
    }];

}

-(void)syncBodyPartsAndExercisesFromParse:(completeBlock_t)completionBlock errorBlock:(error_block)errorBlock {

/*
    PFQuery *query = [PFQuery queryWithClassName:kGLBodyPartInfo];
    
    [query whereKey:@"objectId" equalTo:@"BezBDCiQ6U"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count) {
        
            PFObject *bodyPart = [objects lastObject];
            
            PFRelation *relation = [bodyPart relationForKey:@"exercise_r"];
            
            PFQuery *query =[PFQuery queryWithClassName:kGLExerciseInfo];
            [query whereKey:@"objectId" equalTo:@"uup1d1zd5P"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(objects.count) {
                    
                    PFObject *exercise = [objects lastObject];
                
                    [relation addObject:exercise];
                    [bodyPart saveInBackground];
                }
                
            }];
        }
    }];
    */
    PFQuery *query = [PFQuery queryWithClassName:kGLBodyPartInfo];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
        
            for (PFObject *bodyObject in objects) {
                [[GLogDataProcessor sharedProcessor]addParseBodyPart:bodyObject];
            }
            
           PFQuery *query = [PFQuery queryWithClassName:kGLExerciseInfo];
            
            [query addDescendingOrder:@"createdAt"];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error) {
                
                    if(objects.count) {
                        PFObject *firstObject = [objects objectAtIndex:0];
                        
                        [[NSUserDefaults standardUserDefaults]setObject:firstObject.createdAt forKey:kExerciseCreatedTimeStampKey];
                        for (PFObject *exerciseObject in objects) {
                            NSLog(@"%@",[exerciseObject objectForKey:@"bodypart_p"]);
                            PFObject *bodyPart = [exerciseObject objectForKey:@"bodypart_p"];
                            [[GLogDataProcessor sharedProcessor]addExerciseForBodyPart:exerciseObject bodyPartID:bodyPart.objectId];
                        }
                    }
                    
                    completionBlock(nil);
                }
            }];
        }
        
    }
     ];
    
}

@end
