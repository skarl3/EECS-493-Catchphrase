//
//  Model.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "Model.h"

static Model* sharedClient = nil; // Singleton object

@interface Model()

// Private

@end

@implementation Model

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (id) init
{
    if (self = [super init]) {
        
    }
    return self;
}

// Singleton

+ (id) sharedManager
{
    if (!sharedClient) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedClient = [[self alloc] init];
        });
    }
    return sharedClient;
}

+ (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = [[Model sharedManager] managedObjectContext];
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        else {
            NSLog(@"Saved to disk.");
        }
    }
}

// Core Data

- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *) managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model"
                                              withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSManagedObject *)fetchObjectWithName:(NSString *)entityName
                                  andKey:(NSString*)key
                                  andVal:(NSString *)object_id
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", key, object_id]];
    [fetchRequest setFetchLimit:1];
    return [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                     error:nil] lastObject];
}

- (void) destroyObject:(NSManagedObject*)object
{
    [self.managedObjectContext deleteObject:object];
    [Model saveContext];
}

- (void) destroyAllObjects
{
    NSFetchRequest *fetchTeams = [[NSFetchRequest alloc] init];
    NSEntityDescription *team = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:_managedObjectContext];
    [fetchTeams setEntity:team];
    
    NSFetchRequest *fetchGames = [[NSFetchRequest alloc] init];
    NSEntityDescription *game = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:_managedObjectContext];
    [fetchGames setEntity:game];
    
    NSError *error;
    NSArray *teams = [_managedObjectContext executeFetchRequest:fetchTeams error:&error];
    
    for (NSManagedObject *managedObject in teams) {
        [_managedObjectContext deleteObject:managedObject];
        //NSLog(@"Team deleted.");
    }
    
    NSArray *games = [_managedObjectContext executeFetchRequest:fetchGames error:&error];
    
    for (NSManagedObject *managedObject in games) {
        [_managedObjectContext deleteObject:managedObject];
        //NSLog(@"Game deleted.");
    }
    
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Error saving: %@",error);
    }
    
    else {
        NSLog(@"Deleted everything and saved.");
    }
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

@end
