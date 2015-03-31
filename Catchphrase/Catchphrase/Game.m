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
        game.otherPlayers = [NSSet setWithArray:teams];
    }
    
    game.game_started = [NSDate new];
    game.game_id = [NSString stringWithFormat:@"%lu", [game.game_started hash]];
    
    [Model saveContext];
    
    return game;
}

- (NSInteger) numberOfPlayers
{
    NSInteger count = 0;
    if(self.winningPlayer) count++;
    if(self.losingPlayer) count++;
    count += self.otherPlayers.count;
    return count;
}

- (NSString*) gameName
{
    if(self.game_name && ![self.game_name isEqualToString:@""]) {
        return self.game_name;
    }
    
    else {
        NSMutableArray *teams = [self.otherPlayers.allObjects mutableCopy];
        if(self.winningPlayer) {
            [teams addObject:self.winningPlayer];
        }
        
        if(self.losingPlayer) {
            [teams addObject:self.losingPlayer];
        }
        
        return [teams componentsJoinedByString:@" vs. "];
    }
}

@end
