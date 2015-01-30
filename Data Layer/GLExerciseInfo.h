//
//  GLExerciseInfo.h
//  GymLog
//
//  Created by Sunny on 04/02/14.
//  Copyright (c) 2014 Apptree Studio LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BodyPartInfo, ExIconInfo, GLDayInfo, SetInfo;

@interface GLExerciseInfo : NSManagedObject
@property (nonatomic, retain) NSNumber *relation_count;
@property (nonatomic, retain) NSDate * date_added;
@property (nonatomic, retain) NSNumber * equipment_type;
@property (nonatomic, retain) NSString * exercise_name;
@property (nonatomic, retain) NSNumber * number_of_reps;
@property (nonatomic, retain) NSNumber * number_of_sets;
@property (nonatomic, retain) NSString * object_id;
@property (nonatomic, retain) BodyPartInfo *body_part_r;
@property (nonatomic, retain) GLDayInfo *day_r;
@property (nonatomic, retain) NSOrderedSet *icon_r;
@property (nonatomic, retain) NSOrderedSet *set_r;
@end

@interface GLExerciseInfo (CoreDataGeneratedAccessors)

- (void)insertObject:(ExIconInfo *)value inIcon_rAtIndex:(NSUInteger)idx;
- (void)removeObjectFromIcon_rAtIndex:(NSUInteger)idx;
- (void)insertIcon_r:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeIcon_rAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInIcon_rAtIndex:(NSUInteger)idx withObject:(ExIconInfo *)value;
- (void)replaceIcon_rAtIndexes:(NSIndexSet *)indexes withIcon_r:(NSArray *)values;
- (void)addIcon_rObject:(ExIconInfo *)value;
- (void)removeIcon_rObject:(ExIconInfo *)value;
- (void)addIcon_r:(NSOrderedSet *)values;
- (void)removeIcon_r:(NSOrderedSet *)values;
- (void)insertObject:(SetInfo *)value inSet_rAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSet_rAtIndex:(NSUInteger)idx;
- (void)insertSet_r:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSet_rAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSet_rAtIndex:(NSUInteger)idx withObject:(SetInfo *)value;
- (void)replaceSet_rAtIndexes:(NSIndexSet *)indexes withSet_r:(NSArray *)values;
- (void)addSet_rObject:(SetInfo *)value;
- (void)removeSet_rObject:(SetInfo *)value;
- (void)addSet_r:(NSOrderedSet *)values;
- (void)removeSet_r:(NSOrderedSet *)values;
@end
