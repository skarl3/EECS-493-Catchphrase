//
//  Game.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "Game.h"
#import "Round.h"
#import "Team.h"
#import "Constants.h"
#import "Model.h"

@implementation Game

@dynamic game_started;
@dynamic game_finished;
@dynamic game_name;
@dynamic game_id;
@dynamic winningPlayer;
@dynamic losingPlayer;
@dynamic otherPlayers;
@dynamic rounds;

+ (Game*) gameWithID:(NSString*)game_id
{
    if([game_id isEqualToString:@""] || !game_id || [game_id isEqual:[NSNull null]]) {
        return nil;
    }
    
    Game *newGame = (Game*)[[Model sharedManager] fetchObjectWithName:@"Game"
                                                               andKey:@"game_id"
                                                               andVal:game_id];
    return newGame;
}

+ (Game*) newGameWithName:(NSString*)name
                 andTeams:(NSArray*)teams
{
    Game *game = [NSEntityDescription insertNewObjectForEntityForName:@"Game"
                                               inManagedObjectContext:[[Model sharedManager] managedObjectContext]];
    
    if(name) {
        game.game_name = name;
    }
    
    if(teams) {
        for(Team *t in teams) {
            [game addOtherPlayersObject:t];
        }
    }
    
    game.game_started = [NSDate new];
    game.game_id = [NSString stringWithFormat:@"%lu", [game.game_started hash]];
    
    [Model saveContext];
    
    return game;
}

@end
