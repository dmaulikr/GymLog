//
//  GLogAppDelegate.h
//  GymLog
//
//  Created by Amendeep Singh on 23/10/13.
//

#import <UIKit/UIKit.h>
#import "TWTSideMenuViewController.h"
@interface GLogAppDelegate : UIResponder <UIApplicationDelegate>
-(void)initializeSideMenuController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL is_menu_open;
@property(nonatomic,strong) TWTSideMenuViewController *sideMenuController;
@end
