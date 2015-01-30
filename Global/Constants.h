//
//  Constants.h
//  GymLog
//
//  Created by Amendeep Singh on 23/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#ifndef GymLog_Constants_h
#define GymLog_Constants_h
#define kUserWorkoutInfo @"UserWorkoutInfo"
#define kUserDayInfo @"UserDayInfo"
#define kUserExerciseInfo @"UserExerciseInfo"
#define kUserHistoryInfo @"UserHistoryInfo"

#define kGLSetInfo @"GLSetInfo"
#define kGLWorkoutInfo @"GLWorkoutInfo"
#define kGLExerciseInfo @"GLExerciseInfo"
#define kGLBodyPartInfo @"GLBodyPartInfo"
#define kGLDayInfo @"GLDayInfo"
#import <NZAlertView/NZAlertView.h>
#import "GLogAlertView.h"
#import "UIView+Animation.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "GLogAppDelegate.h"
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "GLogDataProcessor.h"
#import "GLogNetworkEngine.h"
#import "GLogUtility.h"
#define kBarbellIcon @"barbell_icon"
#define kPlateIcon @"plate_icon"
#define kPlateSelectedColor [UIColor colorWithRed:(float)95/255 green:(float)90/255 blue:(float)97/255 alpha:1.0]

#define kPlateColor [UIColor colorWithRed:(float)55/255 green:(float)55/255 blue:(float)55/255 alpha:1.0]
#define kAppDelegate (GLogAppDelegate *) [[UIApplication sharedApplication] delegate]
#define kDefaultWeight 100
#define kDefaultWeightMetric @"lbs"
#define kBorderColor   [UIColor colorWithRed:(float)20/255 green:(float)204/255 blue:(float)147/255 alpha:1.0]
#define kTitleColor   [UIColor colorWithRed:(float)255/255 green:(float)153/255 blue:(float)49/255 alpha:1.0]
#define kStoryboard_iPhone [UIStoryboard storyboardWithName:@"Main" bundle:nil]

#define kBellotaFont(x) [UIFont fontWithName:@"Bellota-Regular" size:x]
#define kAdminUserID @"YCGxkfHBEB"
#define kDefaultRepetitions 8

#define kNavBarColor [UIColor colorWithRed:(float)52/255 green:(float)73/255 blue:(float)94/255 alpha:1]
//Alert messages
#define kEnterUserNameAlert @"Please enter a valid username"

#define kEnterUserNameAlert @"Please enter a valid username"
#define kEnterPasswordAlert @"Please enter a valid password"
#define kConfirmPasswordAlert @"Please make sure that the password is confirmed correctly."
#define kEnterEmailAlert @"Please enter a valid email address."

#define kEnterWeightAlert @"Please enter a valid weight value"
//#define kEnterNameAlert @"Please enter a valid name"

#define kExerciseCreatedTimeStampKey @"ExerciseCreatedTimeStampKey"

//color codes for exercise icons
#define kBarbellIconColor [UIColor colorWithRed:(float)208/255 green:(float)2/255 blue:(float)27/255 alpha:1]
#define kBodyWeightIconColor [UIColor colorWithRed:(float)74/255 green:(float)144/255 blue:(float)226/255 alpha:1]
#define kDumbbellWeightIconColor [UIColor colorWithRed:(float)44/255 green:(float)167/255 blue:(float)106/255 alpha:1]
#define kPlateStackIconColor [UIColor colorWithRed:(float)62/255 green:(float)62/255 blue:(float)62/255 alpha:1]




#define kSummarySetColorOne [UIColor colorWithRed:(float)72/255 green:(float)176/255 blue:(float)179/255 alpha:0.75]
#define kSummarySetColorTwo [UIColor colorWithRed:(float)74/255 green:(float)74/255 blue:(float)74/255 alpha:0.74]
#define kSummarySetColorThree [UIColor colorWithRed:(float)102/255 green:(float)56/255 blue:(float)143/255 alpha:0.38]


#define kSummaryBarbellSectionColor [UIColor colorWithRed:(float)208/255 green:(float)2/255 blue:(float)27/255 alpha:0.29]

#define kSummaryDumbbellSectionColor [UIColor colorWithRed:(float)64/255 green:(float)223/255 blue:(float)144/255 alpha:0.59]
#define kSummaryPlateSectionColor [UIColor colorWithRed:(float)246/255 green:(float)163/255 blue:(float)56/255 alpha:0.67]

#define kSummaryBodyWeightSectionColor [UIColor colorWithRed:(float)74/255 green:(float)144/255 blue:(float)226/255 alpha:0.48]


#define kMinimumUsernameLength 6
#endif
