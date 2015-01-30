//
//  GLogAppDelegate.m
//  GymLog
//
//  Created by Amendeep Singh on 23/10/13.
//  Copyright (c) 2013 Apptree Studio LLC. All rights reserved.
//

#import "GLogAppDelegate.h"
#import "GLogNavigationController.h"
#import "GLogSelectWorkoutVC.h"
#import "GLogIntroViewController.h"
#import "GLogSideViewController.h"
#import <Reachability/Reachability.h>
@implementation GLogAppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize is_menu_open;
@synthesize sideMenuController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];

    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
    // Override point for customization after application launch.
   // [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [Parse setApplicationId:@"AGGTfJgAlb5Bbyk1eYB0XBGVbCHzm27Ho0s4l1fO"
                  clientKey:@"NDC2m8QUXd8xfjZaN7rOzALX0U63JqGGEWONIlI2"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [[GLogNetworkEngine sharedEngine]syncBodyPartsAndExercisesFromParse:^(id object) {
               
    } errorBlock:^(NSError *error) {
        
    }];
    UINavigationController *navController = (UINavigationController*)self.window.rootViewController;
    navController.navigationBarHidden = YES;
    if([PFUser currentUser]) {
        NSLog(@"%@",[PFUser currentUser].username);
        
        [self initializeSideMenuController];
    }
    
    else {
        
        
    
        AOTutorialViewController *introVC = [kStoryboard_iPhone instantiateViewControllerWithIdentifier:@"AOTutorialViewController"];
        [navController setViewControllers:[NSArray arrayWithObjects:introVC, nil] animated:YES];

    }
    
    
  
    
    [self startReachabilityNotifier];
    /*
    PFQuery *postQuery = [PFQuery queryWithClassName:kGLBodyPartInfo];
    [postQuery whereKey:@"body_part_name" equalTo:@"Chest"];
    
    PFQuery *secondQuery =[PFQuery queryWithClassName:kGLBodyPartInfo];
    [secondQuery whereKey:@"body_part_name" equalTo:@"Back"];

    PFQuery *finalQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:postQuery,secondQuery, nil]];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if(!error) {
        
            NSLog(@"%@",objects);
            
            if(objects.count){
            PFObject *bodyPart = [objects lastObject];
                
                PFQuery *query = [PFQuery queryWithClassName:kGLExerciseInfo];
                [query whereKey:@"bodypart_p" matchesQuery:postQuery];

                [query findObjectsInBackgroundWithBlock:^(NSArray *object_array, NSError *error) {
                   
                    if(!error) {
                    
                        
                        NSLog(@"%@",object_array);
                        
                        PFQuery *query = [PFQuery queryWithClassName:kGLDayInfo];
                        
                        [query findObjectsInBackgroundWithBlock:^(NSArray *object_ar, NSError *error) {
                            if(!error) {
                            
                                
                                for (PFObject *dayObject in object_ar) {
                                    [dayObject addObjectsFromArray:object_array forKey:@"exercise_ar"];
                                    [dayObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        if(!error) {
                                          

                                            
                                        }
                                    }];
                                }
                                
                                
                                PFQuery*  query = [PFQuery queryWithClassName:kGLWorkoutInfo];
                                [query whereKey:@"workout_name" equalTo:@"MuscleTech Chest Workout workout"];
                                
                                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    if(!error) {
                                        
                                        if(objects.count) {
                                            PFObject *workoutObject = [objects lastObject];
                                            
                                            
                                            
                                            [workoutObject addObjectsFromArray:object_ar forKey:@"day_ar"];
                                            
                                            
                                            [workoutObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                
                                            }];
                                        }
                                    }
                                }];
                                
                            }
                        }];
                        
                        
                        
                    }
                    
                }];
                
            }
        }
        
    }];
    */
    /*
    PFQuery*  query = [PFQuery queryWithClassName:kGLDayInfo];
   // [query whereKey:@"workout_name" equalTo:@"MuscleTech Chest Workout workout"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            
            if(objects.count) {
                for (PFObject *workoutObject in objects) {
                    
                
                
                
                    if(![[workoutObject objectForKey:@"exercise_ar"] isEqual:[NSNull null]]){
                [workoutObject setObject:[NSNull null] forKey:@"exercise_ar"];
                
                
                [workoutObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    
                }];
                    }
                }
            }
        }
    }];
    */
    return YES;
}

-(void)initializeSideMenuController {

    GLogSideViewController *sideMenuVC = [[GLogSideViewController alloc]initWithNibName:@"GLogSideViewController" bundle:nil];
    
    GLogSelectWorkoutVC *workoutVC = [kStoryboard_iPhone instantiateViewControllerWithIdentifier:@"GLogSelectWorkoutVC"];
    
    self.sideMenuController = [[TWTSideMenuViewController alloc] initWithMenuViewController:sideMenuVC mainViewController:[[GLogNavigationController alloc]initWithRootViewController:workoutVC]];
    self.sideMenuController.shadowColor = [UIColor blackColor];
    self.sideMenuController.edgeOffset = (UIOffset) { .horizontal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 18.0f : 0.0f };
    self.sideMenuController.zoomScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 0.5634f : 0.85f;
    [UIView transitionFromView:self.window.rootViewController.view
                        toView:self.sideMenuController.view
                      duration:0.65f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished){
                        self.window.rootViewController = self.sideMenuController;
                    }];
  //  self.window.rootViewController = self.sideMenuController;


}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        [_managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];

    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GLogDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GLog.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)startReachabilityNotifier {

    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
         
        });
         };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}



@end
