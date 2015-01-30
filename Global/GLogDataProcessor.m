//
//  GLogDataProcessor.m
//  GymLog
//
//  Created by Amendeep Singh on 23/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogDataProcessor.h"
#import "WorkoutInfo.h"
@implementation GLogDataProcessor
static GLogDataProcessor *_sharedProcessor = nil;
+ (id)sharedProcessor
{
    @synchronized(self)
    {
        if (_sharedProcessor == nil)
            _sharedProcessor = [[self alloc] init];
    }
    return _sharedProcessor;
}


#pragma mark App Specific Methods
-(SetInfo*)addNewSetForExercise:(ExerciseInfo*)exercise {

    SetInfo *set = [NSEntityDescription insertNewObjectForEntityForName:@"SetInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
    
    
    set.exercise_r = exercise;
    
    set.set_weight = [NSNumber numberWithInt:kDefaultWeight];
    set.set_repetitions = [NSNumber numberWithInt:kDefaultRepetitions];
    NSError *error = nil;
    
    
    [set.managedObjectContext save:&error];
    
    
    if(error)
        NSLog(@"%@",error.localizedDescription);
    return set;
    

}

-(void)addExercise:(NSDictionary*)exerciseDict bodyPart:(BodyPartInfo*)bodyPart {
    ExerciseInfo *exercise = (ExerciseInfo*)[self fetchEntityByName:@"ExerciseInfo" forAttribute:@"exercise_name" Value:[exerciseDict valueForKey:@"exercise_name"] inContext:[kAppDelegate managedObjectContext]];

    if(!exercise) {
        
        exercise = [NSEntityDescription insertNewObjectForEntityForName:@"ExerciseInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
        
        exercise.exercise_name = [exerciseDict valueForKey:@"exercise_name"];
        if([[exerciseDict valueForKey:@"equipment_type"] intValue]==0) {
        
            NSLog(@"");
        }
        
        
        
        exercise.equipment_type = [NSNumber numberWithInt:[[exerciseDict valueForKey:@"equipment_type"] intValue]];

        
        NSArray *iconArray = [exerciseDict objectForKey:@"icon_list"];
        
        if(iconArray) {
        
            for (NSString *iconName in iconArray) {
                ExIconInfo *icon = (ExIconInfo*)[self fetchEntityByName:@"ExIconInfo" forAttribute:@"icon_name" Value:iconName inContext:[kAppDelegate managedObjectContext]];
                
              //  if(!icon)
                    icon = [NSEntityDescription insertNewObjectForEntityForName:@"ExIconInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
                
                icon.icon_name = iconName;
                
                icon.exercise_r = exercise;
                
                
            }
        }
        
        exercise.body_part_r = bodyPart;
        NSError *error = nil;
        
        
        [exercise.managedObjectContext save:&error];
        
        
        if(error)
            NSLog(@"%@",error.localizedDescription);
        
    }

}
-(void)addTagWithName:(NSString*)tag_name workout:(WorkoutInfo*)workout{
    TagInfo *tag = (TagInfo*)[self fetchEntityByName:@"TagInfo" forAttribute:@"tag_name" Value:tag_name];

    if(!tag)
        
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"TagInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
    
    tag.tag_name = tag_name;
    
 //   WorkoutInfo *workout = (WorkoutInfo*)[self fetchEntityByName:@"WorkoutInfo" forAttribute:@"workout_name" Value:workout_name];

    if(workout)
        tag.workout_r = workout;
    
    NSError *error = nil;
    [tag.managedObjectContext save:&error];

    if(error)
        NSLog(@"%@",error.localizedDescription);
    
    
   

}

-(void)addExercise:(ExerciseInfo*)exercise workoutDay:(DayInfo*)day {

    
    ExerciseInfo *newExercise =[NSEntityDescription insertNewObjectForEntityForName:@"ExerciseInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
    
    newExercise.exercise_name = exercise.exercise_name;
    newExercise.equipment_type = exercise.equipment_type;
    newExercise.icon_r = exercise.icon_r;
    
    newExercise.body_part_r = exercise.body_part_r;
   // newExercise.number_of_sets = [exerciseDict objectForKey:@"set_count"];
 //   newExercise.number_of_reps = [exerciseDict objectForKey:@"rep_count"];
    newExercise.date_added = [NSDate date];
  newExercise.day_r = day;
    
    NSError *error = nil;

    [newExercise.managedObjectContext save:&error];
    
    
    if(error)
        NSLog(@"%@",error.localizedDescription);

}



-(HistoryInfo*)createWorkoutHistory:(NSMutableDictionary*)historyDict exerciseList:(NSOrderedSet*)exerciseArray {

    HistoryInfo *workout = (HistoryInfo*)[NSEntityDescription insertNewObjectForEntityForName:@"HistoryInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];

    
    workout.workout_name = [historyDict objectForKey:@"workout_name"];
    
    for (ExerciseInfo *exercise in exerciseArray) {
        
        exercise.workout_r = workout;
        
    }
    
    workout.workout_date = [NSDate date];
    workout.workout_start_time = [NSDate date];

    NSError *error = nil;
    
    [workout.managedObjectContext save:&error];
    
    
    if(error)
        NSLog(@"%@",error.localizedDescription);

    
    return workout;
}
#pragma mark ==============================================================================================================

#pragma mark Parse methods
-(ExerciseInfo*)addUserExerciseEntry:(GLExerciseInfo*)gl_exercise workoutDay:(DayInfo*)day {
    
    ExerciseInfo *newExercise =[NSEntityDescription insertNewObjectForEntityForName:@"ExerciseInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
    
    newExercise.exercise_name = gl_exercise.exercise_name;
    newExercise.equipment_type = gl_exercise.equipment_type;
    newExercise.icon_r = gl_exercise.icon_r;
    newExercise.day_r = day;
    
    newExercise.body_part_r = gl_exercise.body_part_r;
    // newExercise.number_of_sets = [exerciseDict objectForKey:@"set_count"];
    //   newExercise.number_of_reps = [exerciseDict objectForKey:@"rep_count"];
    newExercise.date_added = [NSDate date];
    newExercise.gl_exercise_r = gl_exercise;
    
    NSError *error = nil;
    
    [newExercise.managedObjectContext save:&error];
    
    
    if(error)
        NSLog(@"%@",error.localizedDescription);

    return newExercise;
}
-(void)addUserExercisesForDay:(DayInfo*)day exercise:(PFObject*)exerciseObject {
    
    
    NSLog(@"%@",exerciseObject[@"exercise_name"]);
    ExerciseInfo *newExercise = (ExerciseInfo*)[self fetchEntityByName:@"ExerciseInfo" forAttribute:@"exercise_id" Value:exerciseObject.objectId inContext:[kAppDelegate managedObjectContext]];
    if(!newExercise)
    newExercise=[NSEntityDescription insertNewObjectForEntityForName:@"ExerciseInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
    newExercise.exercise_id = exerciseObject.objectId;
    
    PFObject *glExercise  = [exerciseObject objectForKey:@"gl_exercise_p"];
    
    GLExerciseInfo *exerciseInfo = (GLExerciseInfo*)[self fetchEntityByName:@"GLExerciseInfo" forAttribute:@"object_id" Value:glExercise.objectId inContext:[kAppDelegate managedObjectContext]];
    
    newExercise.gl_exercise_r = exerciseInfo;
    newExercise.exercise_name= exerciseInfo.exercise_name;
    newExercise.day_r = day;
    newExercise.equipment_type = exerciseInfo.equipment_type;
    
//    newExercise.exercise_name = exercise.exercise_name;
//    newExercise.equipment_type = exercise.equipment_type;
//    newExercise.icon_r = exercise.icon_r;
//    
//    newExercise.body_part_r = exercise.body_part_r
    newExercise.date_added = [NSDate date];
//    newExercise.day_r = day;
//    
    NSError *error = nil;
//    
    [newExercise.managedObjectContext save:&error];
//    
//    
//    if(error)
//        NSLog(@"%@",error.localizedDescription);

}

-(void)addExercisesForWorkout:(GLDayInfo*)dayInfo array:(NSArray*)exerciseArray{

    for (PFObject *exercise in exerciseArray) {
        GLExerciseInfo *exercise_object = (GLExerciseInfo*)[self fetchEntityByName:@"GLExerciseInfo" forAttribute:@"object_id" Value:exercise.objectId inContext:[kAppDelegate managedObjectContext]];
        if(!exercise_object)         exercise_object = [NSEntityDescription insertNewObjectForEntityForName:@"GLExerciseInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];

            
            exercise_object.object_id = exercise.objectId;
            exercise_object.exercise_name = [exercise objectForKey:@"exercise_name"];
            exercise_object.equipment_type = [exercise objectForKey:@"equipment_type"];
            exercise_object.day_r = dayInfo;
        
        
        NSError *error = nil;
        
        [exercise_object.managedObjectContext save:&error];
        
        
        if(error)
            NSLog(@"%@",error.localizedDescription);
    }
    
    
}

-(GLWorkoutInfo*)addAppWorkOutWithExercises:(PFObject*)pf_workout {

    GLWorkoutInfo *workout = (GLWorkoutInfo*)[self fetchEntityByName:@"GLWorkoutInfo" forAttribute:@"workout_id" Value:pf_workout.objectId];
    if(!workout) {
        
        workout = [NSEntityDescription insertNewObjectForEntityForName:@"GLWorkoutInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
    
    }
    
    workout.workout_id = pf_workout.objectId;
    workout.workout_name = [pf_workout objectForKey:@"workout_name"];
    workout.workout_description = [pf_workout objectForKey:@"workout_description"];
    workout.create_date = pf_workout.createdAt;
    
    NSArray *dayArray = [pf_workout objectForKey:@"day_ar"];
    if(![dayArray isEqual:[NSNull null]])
    {
    for (PFObject *dayObject in dayArray) {
        GLDayInfo *dayInfo = (GLDayInfo*)[self fetchEntityByName:@"GLDayInfo" forAttribute:@"object_id" Value:dayObject.objectId];

        if(!dayInfo)
            dayInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GLDayInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
      
        dayInfo.workout_r = workout;
        dayInfo.object_id = dayObject.objectId;
        dayInfo.day_name = [dayObject objectForKey:@"day_name"];

        NSArray *exerciseArray = [dayObject objectForKey:@"exercise_ar"];
        if(![exerciseArray isEqual:[NSNull null]])
        [self addExercisesForWorkout:dayInfo array:exerciseArray];

        
    }
    }
    
    NSError *error = nil;

    [workout.managedObjectContext save:&error];
    
    
    if(error)
        NSLog(@"%@",error.localizedDescription);

    return workout;

}




-(WorkoutInfo*)addParseUserWorkout:(PFObject*)workoutObject{
    
    WorkoutInfo *workout = (WorkoutInfo*)[self fetchEntityByName:@"WorkoutInfo" forAttribute:@"workout_id" Value:workoutObject.objectId];
    if(!workout) {
        
        workout = [NSEntityDescription insertNewObjectForEntityForName:@"WorkoutInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
        workout.workout_id = workoutObject.objectId;
        workout.create_date = workoutObject.createdAt;
        workout.workout_name = [workoutObject objectForKey:@"workout_name"];
        workout.workout_description =[workoutObject objectForKey:@"workout_description"];
        
        
        NSError *error = nil;
    
        NSArray *dayArray = [workoutObject objectForKey:@"day_info_ar"];
        if(![dayArray isEqual:[NSNull null]])
        {
        for (PFObject *dayObject in dayArray) {
            
        
            
            DayInfo *day =[NSEntityDescription insertNewObjectForEntityForName:@"DayInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
            day.day_date = dayObject.createdAt;
            day.day_name = [dayObject objectForKey:@"day_name"];
            day.workout_r = workout;
            day.object_id = dayObject.objectId;
            NSArray *exerciseArray = [dayObject objectForKey:@"exercise_ar"];
            NSLog(@"%@",exerciseArray);
            if(![exerciseArray isEqual:[NSNull null]])
            {
            for (PFObject *exerciseObject in exerciseArray) {
                if(![exerciseObject isEqual:[NSNull null]])
                [self addUserExercisesForDay:day exercise:exerciseObject];
            }
            }
            
        }
        }
        [workout.managedObjectContext save:&error];
        
        
        if(error)
            NSLog(@"%@",error.localizedDescription);
        
    }
    return workout;
    
    
}
-(void)addExerciseForBodyPart:(PFObject*)exerciseObject bodyPartID:(NSString*)bodyPartID{
    GLExerciseInfo *exercise = (GLExerciseInfo*)[self fetchEntityByName:@"GLExerciseInfo" forAttribute:@"object_id" Value:exerciseObject.objectId inContext:[kAppDelegate managedObjectContext]];
    
    
    if(!exercise)
        exercise = [NSEntityDescription insertNewObjectForEntityForName:@"GLExerciseInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
        
        exercise.exercise_name = [exerciseObject valueForKey:@"exercise_name"];
        
         exercise.object_id = exerciseObject.objectId;
    
    PFRelation *relation = [exerciseObject relationForKey:@"user_exercise_r"];
  [[relation query]countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
      exercise.relation_count = [NSNumber numberWithInteger:number];
      [exercise.managedObjectContext save:&error];

  }];
    
        exercise.equipment_type = [NSNumber numberWithInt:[[exerciseObject valueForKey:@"equipment_type"] intValue]];
        
        BodyPartInfo *bodyPart = (BodyPartInfo*)[self fetchEntityByName:@"BodyPartInfo" forAttribute:@"object_id" Value:bodyPartID inContext:[kAppDelegate managedObjectContext]];
        
        exercise.body_part_r = bodyPart;
    
    ExIconInfo * icon;
   if(exercise.icon_r.count)
       icon = [exercise.icon_r objectAtIndex:0];
    
   else icon = [NSEntityDescription insertNewObjectForEntityForName:@"ExIconInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
    switch ([exercise.equipment_type intValue]) {
        case 1:
            icon.icon_name = @"barbell_icon";
            break;
        case 2:
            icon.icon_name = @"barbell_icon";

            break;
        case 3:
            icon.icon_name = @"plate_icon";

            break;
        case 4:
            icon.icon_name = @"plate_icon";

            break;
        case 5:
            icon.icon_name = @"dumbbell_icon";

            break;
            
        default:
            icon.icon_name = @"bw_icon";

            break;
    }
    
    icon.gl_exercise_r = exercise;

    
        NSError *error = nil;
    
    
        [exercise.managedObjectContext save:&error];
        
        
        if(error)
            NSLog(@"%@",error.localizedDescription);

}

-(void)addParseBodyPart:(PFObject*)bodyPartObject {
    
    BodyPartInfo *bodyPart = (BodyPartInfo*)[self fetchEntityByName:@"BodyPartInfo" forAttribute:@"object_id" Value:bodyPartObject.objectId inContext:[kAppDelegate managedObjectContext]];
    
    if(!bodyPart)
        
        bodyPart = [NSEntityDescription insertNewObjectForEntityForName:@"BodyPartInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
        
        bodyPart.body_part_name = bodyPartObject[@"body_part_name"];
        bodyPart.object_id = bodyPartObject.objectId;
        NSError *error = nil;
        
        
        [bodyPart.managedObjectContext save:&error];
        
        
        if(error)
            NSLog(@"%@",error.localizedDescription);
        
    
    
}


#pragma mark ==============================================================================================================

-(WorkoutInfo*)addUserWorkoutWithName:(NSString*)workoutName description:(NSString*)desc{

    WorkoutInfo *workout = (WorkoutInfo*)[self fetchEntityByName:@"WorkoutInfo" forAttribute:@"workout_name" Value:workoutName];
    if(!workout) {
        
        workout = [NSEntityDescription insertNewObjectForEntityForName:@"WorkoutInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
        
        workout.workout_name = workoutName;
        workout.workout_description =desc;
        NSError *error = nil;
        
        for (int count=1; count<4; count++) {
            
            DayInfo *day =[NSEntityDescription insertNewObjectForEntityForName:@"DayInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
            day.day_date = [NSDate date];
            day.day_name = [NSString stringWithFormat:@"Day %d",count];
            day.workout_r = workout;
            
        }
        
        [workout.managedObjectContext save:&error];
        
        
        if(error)
            NSLog(@"%@",error.localizedDescription);
        
    }
    return workout;

    
}

-(DayInfo*)addNewDayForWorkout:(WorkoutInfo*)workout name:(NSString*)day_name {

    DayInfo *day =[NSEntityDescription insertNewObjectForEntityForName:@"DayInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
    
    day.day_name = day_name;
    day.day_date = [NSDate date];
    day.workout_r = workout;
    
    
    NSError *error = nil;
    
    
    [day.managedObjectContext save:&error];
    
    
    if(error)
        NSLog(@"%@",error.localizedDescription);
    return day;

}


-(void)addBodyPartWithName:(NSString*)partName {

    BodyPartInfo *bodyPart = (BodyPartInfo*)[self fetchEntityByName:@"BodyPartInfo" forAttribute:@"body_part_name" Value:partName inContext:[kAppDelegate managedObjectContext]];

    if(!bodyPart) {
    
        bodyPart = [NSEntityDescription insertNewObjectForEntityForName:@"BodyPartInfo" inManagedObjectContext:[kAppDelegate managedObjectContext]];
        
        bodyPart.body_part_name = partName;
        
        NSError *error = nil;
        
        
        [bodyPart.managedObjectContext save:&error];
        
        
        if(error)
            NSLog(@"%@",error.localizedDescription);
        
    }
    
}

#pragma  mark Database Helper Methods

- (void)deleteAllObjects:(NSString *)entityDescription
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:[kAppDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError * error;
    NSArray * items = [[kAppDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *managedObject in items)
    {
        [[kAppDelegate managedObjectContext] deleteObject:managedObject];
    }
    
    if (![[kAppDelegate managedObjectContext] save:&error])
    {
        NSLog(@"Error deleting %@ - error:%@", entityDescription, error);
    }
    
}


- (NSArray *)fetchMultipleEntitiesByName:(NSString *)entityName withPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext*)context {
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    
    if (predicate)
        [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
    return [context executeFetchRequest:fetchRequest error:&error];
    
}

- (NSArray *)fetchMultipleEntitiesByName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDesc:(NSSortDescriptor*)sortDescriptor
{
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:[kAppDelegate managedObjectContext]]];
    
    if (predicate)
        [fetchRequest setPredicate:predicate];
    
    if(sortDescriptor)
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error=nil;
    return [[kAppDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    
}

- (NSArray *)fetchMultipleEntitiesByName:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    
    return [self fetchMultipleEntitiesByName:entityName withPredicate:predicate context:[kAppDelegate managedObjectContext]];
    
}

- (NSArray *)fetchMultipleEntitiesByName:(NSString *)entityName
{
    return [self fetchMultipleEntitiesByName:entityName withPredicate:nil];
}

- (NSManagedObject *)fetchEntityByName:(NSString *)entityName forAttribute:(NSString *)attributeName Value:(NSString *)value inContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    
    NSPredicate *predicate = nil;
    
    predicate=[NSPredicate predicateWithFormat:@"%K==%@",attributeName,value];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error] ;
    NSManagedObject *resultObject = [results lastObject];
    fetchRequest = nil;
    results = nil;
    
    return  resultObject;
}


-(NSManagedObject *) fetchEntityByName:(NSString *)entityName forAttribute:(NSString *)attributeName Value:(NSString *)value
{
    
    
    return [self fetchEntityByName:entityName forAttribute:attributeName Value:value inContext:[kAppDelegate managedObjectContext]];
}


@end
