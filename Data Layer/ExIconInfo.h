//
//  ExIconInfo.h
//  GymLog
//
//  Created by Sunny on 04/02/14.
//  Copyright (c) 2014 Apptree Studio LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExerciseInfo, GLExerciseInfo;

@interface ExIconInfo : NSManagedObject

@property (nonatomic, retain) NSString * icon_name;
@property (nonatomic, retain) NSString * icon_path;
@property (nonatomic, retain) ExerciseInfo *exercise_r;
@property (nonatomic, retain) GLExerciseInfo *gl_exercise_r;

@end
