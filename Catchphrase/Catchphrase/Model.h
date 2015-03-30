//
//  Model.h
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "Game.h"
#import "Word.h"
#import "Round.h"

@interface Model : NSObject

// Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Singleton methods
+ (id) sharedManager;
+ (void) saveContext;

// Core Data methods
- (NSManagedObject *) fetchObjectWithName:(NSString *)entityName andKey:(NSString*)key andVal:(NSString *)object_id;
- (void) destroyObject:(NSManagedObject*)object;
- (void) destroyAllObjects;
- (NSURL*) applicationDocumentsDirectory;

@end
