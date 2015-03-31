//
//  Team.h
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Round;

@interface Team : NSManagedObject

@property (nonatomic, retain) NSString * team_name;
@property (nonatomic, retain) NSString * team_desc;
@property (nonatomic, retain) NSString * team_id;
@property (nonatomic, retain) NSSet *wonGames;
@property (nonatomic, retain) NSSet *lostGames;
@property (nonatomic, retain) NSSet *inProgressGames;
@property (nonatomic, retain) NSSet *lostRounds;

// Non Core Data
@property (nonatomic, strong, readonly) NSString *statsString;

+ (Team*) teamWithID:(NSString*)team_id;
+ (Team*) newTeamWithName:(NSString*)name
           andDescription:(NSString*)description;

@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addWonGamesObject:(Game *)value;
- (void)removeWonGamesObject:(Game *)value;
- (void)addWonGames:(NSSet *)values;
- (void)removeWonGames:(NSSet *)values;

- (void)addLostGamesObject:(Game *)value;
- (void)removeLostGamesObject:(Game *)value;
- (void)addLostGames:(NSSet *)values;
- (void)removeLostGames:(NSSet *)values;

- (void)addInProgressGamesObject:(Game *)value;
- (void)removeInProgressGamesObject:(Game *)value;
- (void)addInProgressGames:(NSSet *)values;
- (void)removeInProgressGames:(NSSet *)values;

- (void)addLostRoundsObject:(Round *)value;
- (void)removeLostRoundsObject:(Round *)value;
- (void)addLostRounds:(NSSet *)values;
- (void)removeLostRounds:(NSSet *)values;

@end
