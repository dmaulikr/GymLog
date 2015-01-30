//
//  BodyPartInfo.h
//  GymLog
//
//  Created by Sunny on 03/02/14.
//  Copyright (c) 2014 Apptree Studio LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExerciseInfo, GLExerciseInfo;

@interface BodyPartInfo : NSManagedObject

@property (nonatomic, retain) NSString * body_part_name;
@property (nonatomic, retain) NSString * object_id;
@property (nonatomic, retain) NSSet *exercise_r;
@property (nonatomic, retain) NSSet *gl_exercise_r;
@end

@interface BodyPartInfo (CoreDataGeneratedAccessors)

- (void)addExercise_rObject:(ExerciseInfo *)value;
- (void)removeExercise_rObject:(ExerciseInfo *)value;
- (void)addExercise_r:(NSSet *)values;
- (void)removeExercise_r:(NSSet *)values;

- (void)addGl_exercise_rObject:(GLExerciseInfo *)value;
- (void)removeGl_exercise_rObject:(GLExerciseInfo *)value;
- (void)addGl_exercise_r:(NSSet *)values;
- (void)removeGl_exercise_r:(NSSet *)values;

@end
