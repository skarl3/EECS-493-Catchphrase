//
//  Game.h
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Round, Team;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSDate * game_started;
@property (nonatomic, retain) NSDate * game_finished;
@property (nonatomic, retain) NSString * game_name;
@property (nonatomic, retain) NSString * game_id;
@property (nonatomic, retain) Team *winningPlayer;
@property (nonatomic, retain) Team *losingPlayer;
@property (nonatomic, retain) NSSet *otherPlayers;
@property (nonatomic, retain) NSSet *rounds;

+ (Game*) gameWithID:(NSString*)game_id;
+ (Game*) newGameWithName:(NSString*)name
                 andTeams:(NSArray*)teams;

- (NSString*) gameName;
- (NSInteger) numberOfPlayers;

@end

@interface Game (CoreDataGeneratedAccessors)

- (void)addOtherPlayersObject:(Team *)value;
- (void)removeOtherPlayersObject:(Team *)value;
- (void)addOtherPlayers:(NSSet *)values;
- (void)removeOtherPlayers:(NSSet *)values;

- (void)addRoundsObject:(Round *)value;
- (void)removeRoundsObject:(Round *)value;
- (void)addRounds:(NSSet *)values;
- (void)removeRounds:(NSSet *)values;

@end
